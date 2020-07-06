%% Soluciones a autodiagnostico 2 de LC Felix-Herrera

%% 6)

F = tf(0.25*ones(1,4), [1, -1, 0,0,0], 1)

figure(6)
clf
impulse(F)