%% Disk drive Jury's criterion, root locus

G = tf([1], [1,0,0]);
H = c2d(G, 1);
Fb = tf([1, -0.8], [1, 0], 1);

figure(1)
clf
rlocus(Fb*H)

% The critical gain
K = 35/18;

pole(feedback(H, K*Fb))
abs(pole(feedback(H, K*Fb)))
