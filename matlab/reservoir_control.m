%% Control of reservoir

% Kjartan Halvorsen
% 2019-09-03

% Plant
G = tf([1], [1,-1], 1)

% PI controller
F_pi = tf([1, -0.5], [1, -1], 1)

figure(1)
clf
rlocus(G*F_pi)
