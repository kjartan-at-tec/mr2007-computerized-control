m1 = 2500;
m2 = 320;
k1 = 80000;
k2 = 500000;
b1 = 350;

% ubar = [w; u]
A=[0                 1                0                     0
  -(1/m1+1/m2)*k1  -(1/m1+1/m2)*b1  k2/m2                   0
   0                  0                 0                   1
   k1/m2              b1/m2            -k2/m2               0];
B=[0                 0
   -k2/m2            1/m1+1/m2  
   0                 0
   k2/m2             -1/m2 ];
C=[1 0 0 0];
D=[0, 0];
sys_uy=ss(A,B(:,2),C,D(:,2));
sys_wy=ss(A,B(:,1),C,D(:,1));


figure(1)
clf
subplot(121)
stepplot(sys_uy);
title('Response from u')
xlabel('Time (seconds)')
ylabel('y (meters)')
subplot(122)
stepplot(sys_wy);
title('Response from w')
xlabel('Time (seconds)')
ylabel('y (meters)')

% Simulate step response for first half second
T = linspace(0, 0.5, 800);

figure(2)
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

% Choose sampling time from the period of oscillations
w0 = 2*pi/(0.264-0.133);
h = 0.2/w0

% Sample
sys_uy_d = c2d(sys_uy, h);
sys_wy_d = c2d(sys_wy, h);

figure(3)
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
[Ad, Bd, Cd, Dd] = ssdata(sys_uy_d); 
Wo = [Cd;Cd*Ad;Cd*Ad*Ad; Cd*Ad*Ad*Ad]
det(Wo)
Wc = [Bd  Ad*Bd  Ad*Ad*Bd Ad*Ad*Ad*Bd]
det(Wc)

% Place poles at desired location
P=exp(h*[-1*w0, -1.2*w0, -1.3*w0, -1.25*w0])
[L, prec] = place(Ad, Bd, P)
eig(Ad-Bd*real(L))

% Form closed-loop system and simulate

[Adw, Bdw, C, D] = ssdata(sys_wy_d);

Ac = Ad - Bd*L;

sys_c_d = ss(Ac, Bdw, C, D, h); % Closed-loop, but with input from disturbance w


figure(4)
clf
w = 0.1*ones(100,1);
[y, T, x] = lsim(sys_c_d, w);

subplot(211)
lsimplot(sys_c_d, w)
title('Closed-loop response to disturbance of 10cm')
ylabel('z_1 -z_2 [m]')
xlabel('Time [s]')
subplot(212)
stairs(T, -L*x')
title('Input signal u=-Lx')
ylabel('Active suspension force [N]')
xlabel('Time [s]')

[Phi, Gamma, C, D] = ssdata(sys_uy_d); % Get the system matrices from the discrete-time state space model

%P = % Your choice of poles goes here
[L, prec] = place(Phi, Gamma, P)  % Calculate the feedback gain L
eig(Phi - Gamma*L) % Check that this is indeed the poles you specified in P

% Form closed-loop system and simulate. Simulate the system with input from the disturbance w
[Phi, Gammaw, C, D] = ssdata(sys_wy_d);
Phic = Phi - Gamma*L;
sys_c_d = ss(Phic, Gammaw, C, D, h); % Closed-loop, but with input from disturbance w

w = 0.1*ones(100,1);
[y, T, x] = lsim(sys_c_d, w);

figure(1)
clf
subplot(211)
stairs(T, y)
title('Closed-loop response to disturbance of 10cm')
ylabel('z_1 -z_2 [m]')
xlabel('Time [s]')
subplot(212)
stairs(T, -L*x')
title('Input signal u=-Lx')
ylabel('Active suspension force [N]')
xlabel('Time [s]')

% Plot the input signal
