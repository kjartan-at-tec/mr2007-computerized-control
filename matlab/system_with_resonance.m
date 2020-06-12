%% MR2007 hw3 fall 2019

zeta = 0.95;
omega_n = 2.5*pi;

F = tf([1, 0.1], [1, 2*zeta*omega_n, omega_n^2]);

figure(1)
clf
bode(F)

