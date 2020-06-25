% RST design
% MR2007 partial exam 2 March 2017
% Kjartan Halvorsen

% Plant model
omega0 = 1;
h = 0.35/omega0;
beta = cos(omega0*h);

B = (1-beta)*[1, 1];
A = [1, -2*beta, 1];
H = tf(B, A, h) % Discrete-time transfer function

% Desired closed-loop poles
pdd = 0.4;
ac = [1,-pdd];
Ac = conv(ac, ac) % (z-0.4)^2

% Observer polynomial
Ao = [1,0] % Singe pole in the origin
% RHS of the Diophantine equation
Acl = conv(Ac, Ao)

% Controller design
% Make use of the symbolic toolbox for matlab
syms z r1 s0 s1
R = z + r1
S = s0*z + s1;

% LHS of the Diophantine equation
LHS = (z^2 - 2*beta*z + 1)*R + (1-beta)*(z + 1)*S
LHScoeffs = fliplr(coeffs(LHS, z)) % Must flip, since coeffs() returns the coefficient in the lowest term first.

% The equations
eqs = LHScoeffs(2:end) - Acl(2:end)
[AA, bb] = equationsToMatrix(eqs, [r1, s0, s1]);
RSparams = linsolve(AA,bb)
params = double(RSparams);

R = [1, params(1)];
S = params(2:end)';

t_0 = sum(Ac)/sum(B) % t0 = Ac(1) / B(1) 
T = Ao * t_0;

F_fb = tf(S, R, h);
F_ff = tf(T, R, h);
%H_aa = tf([1], [1, 0, 0], 1) % Delay of two sampling periods
H_aa = 1;

% Closed-loop system from command signal to output
Hc = F_ff * feedback(H, F_fb*H_aa);
% Closed-loop system from disturbance to output
Hd = feedback(1, H*F_fb*H_aa);
% Closed-loop system from noise to output
Hn = -feedback(H*F_fb*H_aa, 1)

% We can simulate the response to each of the input signals separately,
% then add the result.

% Simulate step in command signal at t=5
NN = 200;
tvec = (0:(NN-1))*h;
uc = zeros(1,NN);
uc(6:end) = 1;
[yc, tc] = lsim(Hc, uc, tvec);
    
% Simulate step disturbance at t=100
v = zeros(1,NN);
v(100:end) = 1;
[yv, tv] = lsim(Hd, v, tvec);
    
   
figure(1)
set(gcf, 'position', [100,100, 800, 400])
clf
stairs(tvec, yc+yv, 'color', [0.1, 0.1, 0.8], 'linewidth', 2)
hold on
%stairs(tvec, uc, 'k:', 'linewidth', 2)
xlabel('Time')
ylabel('y')


%% Now design a lead-lag compensator

G = tf([1], [1, 0, 1]);

pcd = log(pdd)/h % Desired cont. time pole
zl = -0.2;   % Place lead zero just left of plant poles

% Find p,K,b in
% (s^2 + 1)(s+p) + K(s-zl) = (s+a)^2(s+b), a = -pcd
a = -pcd

pKb = [1 0 -1; 0 1 -2*a; 1 -zl -a^2]\[2*a; a^2-1; 0]

s = tf('s');
F_lead = pKb(2)* (s-zl)/(s+pKb(1))
Ti = 4/(-pcd); % Time constant of lag filter
F_lag = (Ti*s + 1)/(Ti*s);

Fc = F_lag*F_lead;

G0 = Fc*G;
Gc = feedback(G0, 1);

figure(2)
clf
rlocus(G0)

figure(3)
clf
pzmap(Gc)

F_leadlag_d = c2d(Fc, h, 'Tustin')


% Closed-loop system from command signal to output
Hc2 = feedback(F_leadlag_d*H, 1);
% Closed-loop system from disturbance to output
Hd2 = feedback(1, H*F_leadlag_d);

% We can simulate the response to each of the input signals separately,
% then add the result.

% Simulate step in command signal at t=5
[yc2, tc2] = lsim(Hc2, uc, tvec);
    
% Simulate step disturbance at t=45
[yv2, tv2] = lsim(Hd2, v, tvec);
    
   
figure(1)
stairs(tvec, yc2+yv2, 'r--', 'linewidth', 2)
xlabel('Time')
ylabel('y')
print -dpdf RST_leadlag_sim.pdf

figure(4)
margin(F_leadlag_d*H)



