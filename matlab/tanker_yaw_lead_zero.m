
% Tanker model, hw2, spring 18

% Kjartan Halvorsen
% 2018-02-16

a = -1;
s = tf('s');
G = 1/(s*(s+a))

h = 0.2;
H = c2d(G, h)

lz = 0.82;
lp = 0.25;

F1 = zpk(lz, lp, 10, h);
F2 = zpk(1, lp, 12, h);

% Closed-loop system from disturbance on output to output
Gv1 = feedback(1, H*F1);
Gv2 = feedback(1, H*F2);


% Closed-loop system from reference signal to output
Gc1 = feedback(H*F1, 1);
Gc2 = feedback(H*F2, 1);

figure(2)
clf
rlocus(F2*H)

figure(3)
clf
step(Gc1, Gc2)
title('Response to step in reference signal')
legend('Lead-zero in 0.82', 'Lead-zero in 1')


figure(4)
clf
step(Gv1, Gv2)
title('Response to step in disturbance')
legend('Lead-zero in 0.82', 'Lead-zero in 1')

figure(5)
clf
h = bodeplot(Gv1, Gv2, logspace(-4, 1, 400));
setoptions(h,'PhaseVisible','off');
%legend('Lead-zero in 0.82', 'Lead-zero in 1')

figure(6)
clf
h = bodeplot(Gv1, Gv2, logspace(-4, 1, 400));
setoptions(h,'PhaseVisible','off');
legend('Lead-zero in 0.82', 'Lead-zero in 1')

