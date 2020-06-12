Phi = [0.5 1
    0 0.3];
Gamma = [1;2];
C = [1, 0];
D = [];

h = 1;

sys = ss(Phi, Gamma, C, D, h)

figure(1)
pzmap(sys)

LT = [1 2;1.7 -1]\ [0.8;-0.15]
L = LT';

% Check with matlab's acker function
Lp = acker(Phi, Gamma, [0;0])

Phi_c = Phi - Gamma*L;
m = 1 / (C*inv(eye(2) - Phi_c)*Gamma);

sys_cl = ss(Phi_c, m*Gamma, C, D, h)
figure(1)
pzmap(sys_cl)

% Step response
[y,t,x] = step(sys_cl);


% Plot the step response and the control signal
u = -L*x' + m*1;
figure(2)
clf
stairs(t, y, 'b', 'linewidth', 2)
hold on
stairs(t, u, 'r', 'linewidth', 2)

ys = lsim(sys, u, t);
stairs(t, ys, 'g')
