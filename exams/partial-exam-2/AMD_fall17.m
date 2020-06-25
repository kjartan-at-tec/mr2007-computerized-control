%% Partial 2 MR2007 Fall 17

clear all
close all
den = [1, 0.7, 1.533, 0.589, 0.4267];
G = tf([1,0,0], den);

H = c2d(G, 0.2)


figure(1)
clf
pzmap(H)
%grid on
%xlim([0.5, 1.1])
%ylim([-0.5, 0.5])
%axis equal
print -dpdf amd_pzmap.pdf


%% Sample 60Hz signal
wr = 1.15;
w60 = 60*2*pi;
wN = (wr+w60)/2;
h = pi/wN;
td = (0:800)*h;
tc = (0:8000)*(h/10);

yc = sin(60*2*pi*tc);
yd = yc(1:10:end);

figure(2)
clf
plot(tc, yc)
hold on
plot(td, yd, 'o')
%

walias =  2*pi/(9.55-4.1)
