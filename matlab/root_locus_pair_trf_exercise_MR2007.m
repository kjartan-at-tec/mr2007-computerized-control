%% Root locus exercise. Pair transfer function and root locus
% Kjartan halvorsen
% 2018-02-15

s = tf('s');
kv = 1;
Tv = 1;
h = 0.3;

G = kv/(s*(s*Tv+1))

G1 = G*zpk([-4],[-1.5],1)
G2 = G*zpk([-1.5],[-4],1)
G3 = G*zpk([-1.5],[],1)
G4 = G*zpk([-4],[],1)


figure(1)
%clf
subplot(221)
rlocus(G1)
title('')
xlabel('Re')
ylabel('Im')
xlim([-5, 2])
ylim([-3,3])
text(-3,1, '1', 'fontsize', 32)

subplot(222)
rlocus(G2)
xlabel('Re')
ylabel('Im')
title('')
xlim([-5, 2])
ylim([-3,3])
text(-3,1, '2', 'fontsize', 32)

subplot(223)
rlocus(G3)
xlabel('Re')
ylabel('Im')
title('')
xlim([-5, 2])
ylim([-2,2])
text(-4,1, '3', 'fontsize', 32)

subplot(224)
rlocus(G4)
xlabel('Re')
ylabel('Im')
title('')
xlim([-10, 2])
ylim([-6,6])
text(-8,3, '4', 'fontsize', 32)

print -dpdf -bestfit rlocus_2x2.pdf

