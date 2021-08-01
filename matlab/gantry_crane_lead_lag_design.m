%% Gantry crane position control 

% Kjartan Halvorsen 
% 2021-06-27

clear all
close all
% Parameters
g = 9.8;
l = 15; % Length of cable
wn = sqrt(g/l);

s = tf('s');
G = wn^2/(s^2 + wn^2)

F = (2*s+1)/(s*(s+7))

figure(1)
rlocus(G*F)

F2 = (2*s+1)*F;
figure(2)
clf
rlocus(F2*G)

F3 = (s+5)*F;
figure(3)
clf
rlocus(F3*G)

Gc2 = feedback(10*F2*G, 1);
figure(4)
step(Gc2)

F4 = (s+0.8)*F;

%% Discretizationm
h = 0.07;

Fz = c2d(F4, h, 'tustin')

Gz = c2d(G, h);

Gc = feedback(30*Fz*Gz, 1);
abs(pole(Gc))

figure(5)
clf
step(Gc)
