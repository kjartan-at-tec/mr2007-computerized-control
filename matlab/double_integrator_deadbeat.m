%% MR2007 dead beat control of double integrator
A = [0 1; 0 0]; B = [0;1]; C=[1, 0]; D = 0;
sys_c = ss(A, B, C, D)

h = 1; % Sampling time

sys_d = c2d(sys_c, h) % Sampled system

% Desired coefficients in charact polynomial double pole in
p = 0.0;
coef = conv([1,-p], [1, -p])

L = [1/2  1; 1/2  -1 ] \  [2+coef(2); -1+coef(3)];
L = L'
% Verify
[Phi, Gamma, C, D] = ssdata(sys_d)
eig(Phi - Gamma*L)

% Also deadbeat observer
K = [2;1];
% Verify
eig(Phi - K*C)


% The complete system
Phi_e = [Phi  -Gamma*L
    K*C  Phi-K*C-Gamma*L];
Gamma_e = [Gamma; Gamma];
C_e = [C zeros(size(C))];

% Verify poles
eig(Phi_e)

sys_complete = ss(Phi_e, Gamma_e, C_e, zeros(1,1), h);

figure(2)
clf
step(sys_complete)
