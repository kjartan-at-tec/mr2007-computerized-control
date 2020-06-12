%% MR2007 hw3 fall 2019


omega_n = 2.5*pi;

F = tf(omega_n^2*[1], [1, 0.1, omega_n^2]);

figure(1)
clf
bode(F)

print -dpdf bode-resonance.pdf
