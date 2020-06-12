g = 9.8;
mr = 80; % Rider weight
mc = 200; % Bike weight
m1 = 0.5*(mr+mc); % Sprung weight
m2 = 0.1*m1; % Unsprung weight

susp_sag = 30e-3; % m sag when rider on 
tyre_sag = 5e-3; % m sag when rider on
k1 = m1*g/susp_sag; % N/m spring constant for suspension 
k2 = (m1+m2)*g/tyre_sag; % N/m spring constant for wheel and tyre 
b1 = 150/(150e-3); % N/(m/s) Damping factor

% x = [z_1, \dot{z}_1, z_2, \dot{z}_2]

% ubar = [w; u]
A=[0                 1                0                     0
    -1/m1*k1   -1/m1*b1               1/m1*k1              1/m1*b1
   0                  0                 0                   1
   k1/m2              b1/m2            -k2/m2-k1/m2         -b1/m2];
B=[0                 0
   0                1/m1  
   0                 0
   k2/m2            -1/m2 ]; 
% A positive control force is pushing the masses away from each other 
C=[0 1 0 0];
D=[0];
sys = ss(A, B, C, D);
sys_uy=ss(A,B(:,2),C,D);
sys_wy=ss(A,B(:,1),C,D);


figure(1)
clf
step(sys)

figure(2)
clf
subplot(121)
stepplot(1000*sys_uy);
title('Response from u (step 1kN)')
xlabel('Time [s]')
ylabel('y [m/s]')
subplot(122)
stepplot(0.1*sys_wy);
title('Response from w (step 0.1m)')
xlabel('Time [s]')
ylabel('y [m/s]')
print -dpdf active-suspension-step-openloop.pdf


% Simulate step response for first half second
T = linspace(0, 0.5, 800);

figure(3)
clf
subplot(121)
stepplot(sys_uy, T);
title('Response from u')
xlabel('Time (seconds)')
ylabel('y (meters)')
subplot(122)
stepplot(sys_wy, T);
title('Response from w')
xlabel('Time (seconds)')
ylabel('y (meters)')

figure(4)
clf
pzmap(sys_uy)
print -dpdf active-suspension-pzmap-openloop.pdf


% Choose sampling time from natural frequency of poles
w = max(abs(pole(sys_uy)))

%h = 0.6/w0
h = 0.004
% Sample
sys_uy_d = c2d(sys_uy, h);
sys_wy_d = c2d(sys_wy, h);

figure(5)
Td = 0:h:0.5;
clf
subplot(121)
stepplot(sys_uy, T);
hold on
stepplot(sys_uy_d, Td);
title('Response from u')
xlabel('Time (seconds)')
ylabel('y (meters)')

subplot(122)
stepplot(sys_wy, T);
hold on
stepplot(sys_wy_d, Td);
title('Response from w')
xlabel('Time (seconds)')
ylabel('y (meters)')


% Check observability and reachability
%[Ad, Bd, Cd, Dd] = ssdata(sys_uy_d); 
%Wo = [Cd;Cd*Ad;Cd*Ad*Ad; Cd*Ad*Ad*Ad]
%det(Wo)
%Wc = [Bd  Ad*Bd  Ad*Ad*Bd Ad*Ad*Ad*Bd]
%det(Wc)

% Place poles at desired location
[Phi, Gamma_w, C, D] = ssdata(sys_wy_d);
[Phi, Gamma_u, C, D] = ssdata(sys_uy_d);

wdom = max(abs(pole(sys_uy)));
wdom = 156
z = [0.8, 0.6]; 
p_c = wdom*(-z + 1j*sqrt(1-z.^2));
p_c = cat(2, p_c, conj(p_c));
p_d = exp(p_c*h)
p_d = zeros(1,4);
%[L, prec] = acker(Phi, Gamma_u, p_d)
L = acker(Phi, Gamma_u, p_d)
eig_Phic = eig(Phi-Gamma_u*real(L))

% Form closed-loop system and simulate


sys_wy_d_closed = ss(Phi-Gamma_u*real(L), Gamma_w, C, D, h); % Closed-loop, but with input from disturbance w

T = ( 0:ceil(10/h) )*h; % Discrete time-vector
w = zeros(size(T));
ind_before_2 = find(T < 2);
w(ind_before_2) = 0.3;
ind_between_2_and_4 = intersect( find(T>2), find(T<4) );
w(ind_between_2_and_4) = -0.3;


[y, Tsim, x] = lsim(sys_wy_d_closed, w, T);
[yo, Tsim, xo] = lsim(sys_wy_d, w, T);

figure(7)
clf

subplot(211)
lsimplot(sys_wy_d_closed, w)
hold on
plot(T, w, 'g--')
title('Closed-loop response')
ylabel('')
xlabel('Time [s]')
subplot(212)
stairs(T, -L*x')
title('Input signal u=-Lx')
ylabel('Active suspension force [N]')
xlabel('Time [s]')

figure(8)
clf
for i=1:4
    subplot(5,1,i)
    stairs(T, x(:,i), 'color', [0, 0.447, 0.741])
    hold on
    stairs(T, xo(:,i), 'color', [0.85, 0.325, 0.098])
    ylabel(sprintf('state %d', i))
    xlabel('Time [s]')
end
legend('Closed-loop response', 'Open-loop response')
subplot(5,1,5)
stairs(T, -L*x', 'color', [0, 0.447, 0.741])
ylabel('Control signal [N]')


    
