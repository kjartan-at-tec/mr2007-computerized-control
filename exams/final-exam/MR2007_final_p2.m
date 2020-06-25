% MR2007 final exam p2

Phi = [1 1; 0 1];
Gamma = [0.5;1];
C = [1, 0];

sys = ss(Phi, Gamma, C, [0], 1)

K = [1, 1.5]

eig(Phi - Gamma*K)

sys_c = ss(Phi - Gamma*K, Gamma, C, [0], 1);

figure
step(sys_c)

