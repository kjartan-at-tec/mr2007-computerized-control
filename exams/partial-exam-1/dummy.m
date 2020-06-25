% Dummy partial exam 1 HT2016
G = tf([1,1], [1, 3, 0])
F = tf([1, 2.5], [1, 0.5])

figure(1)
clf
rlocus(G*F)