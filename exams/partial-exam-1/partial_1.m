%% MR2007 partial exam 1
close all

s = tf('s');
kv = 1;
Tv = 1;
h = 0.3;

G = kv/(s*(s*Tv+1))
Gd = c2d(G, h, 'zoh')
[num,den] = tfdata(Gd);


figure(1)
clf
rlocus(Gd)
xlim([-4,2])
ylim([-2, 2])
axis equal
% print -dpdf 'root-locus.pdf'

figure(1)
clf
rlocus(G)
%xlim([-4,2])
%ylim([-2, 2])
axis equal
print -dpdf 'root-locus.pdf'


K=1;
figure(2)
clf
w = logspace(-1, log10(pi/h), 400);
bode(K*Gd, w)
grid on
xlim([0.1, 20])
print -dpdf 'bode-diagram.pdf'

figure(2)
clf
w = logspace(-1, log10(pi/h), 400);
margin(K*Gd)
grid on
xlim([0.1, 20])
print -dpdf 'margin-diagram.pdf'

% Lead compensator
figure(3)
clf
pzmap(Gd)
F = tf([1, -0.65], [1, -0.3], h)
figure(4)
rlocus(Gd*F)

% Cont time lead compensator
a = 4;
b = 3/2;
F = (s+b)/(s+a)
h = 0.2;
Fd = c2d(F, h, 'foh')

