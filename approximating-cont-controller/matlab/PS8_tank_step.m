
% PI tuning of double tank system with valve dynamics

G = zpk([], [-0.0179, -0.0129], 0.00048)*tf([1],[40 1]);

[y, ts] = step(G);
figure(1)
clf
plot(ts, y, 'b', 'linewidth', 3);
set(gca, 'xlim', [0,400])
xlabel('Time [s]')


ylabel('y')
title('Step response')
grid on
