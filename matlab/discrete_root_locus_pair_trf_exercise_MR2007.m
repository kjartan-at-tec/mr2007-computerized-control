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
G3 = G*zpk([-Tv/2],[],1)
G4 = G*zpk([-Tv/2],[0],1)

G1d = c2d(G1, 1);
G2d = c2d(G2, 1);
G3d = c2d(G3, 1);
G4d = c2d(G4, 1);



figure(1)
%clf
subplot(221)
rlocus(G1d)
title('')
xlabel('Re')
ylabel('Im')
xlim([-3, 1.1])
ylim([-2.1,2.1])
axis equal
text(-2,1, '1', 'fontsize', 32)

subplot(222)
rlocus(G2d)
xlabel('Re')
ylabel('Im')
title('')
xlim([-1.6, 1.1])
ylim([-1.2,1.2])
axis equal
text(-1.2,0.8, '2', 'fontsize', 32)

subplot(223)
rlocus(G3d)
xlabel('Re')
ylabel('Im')
title('')
xlim([-1.6, 1.1])
%ylim([-2,2])
axis equal
text(-1.2,0.8, '3', 'fontsize', 32)

subplot(224)
rlocus(G4d)
xlabel('Re')
ylabel('Im')
title('')
xlim([-3.,1.2])
ylim([-2.1,2.1])
axis equal
text(-2,1, '4', 'fontsize', 32)

set(findobj(gcf, 'Type', 'Line'), 'Markersize', 12)

print -dpdf -bestfit discrete_rlocus_2x2.pdf


%% Extra exercise
G4d
feedback(G4d, 1)
