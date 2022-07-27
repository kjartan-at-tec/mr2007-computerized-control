%% Harddisk drive position control 

% Kjartan Halvorsen 
% 2021-06-27

%close all 
%clear all

% Parameters
l = 1*2.54/100; % Length from CoM to axis
m = 9.83e-4; %kg
J = 4.78e-7 + m*l*l;

% Continuous-time model
s = tf('s');
G = (1/J)/s^2;

h = 2e-4; % Sampling period
Gd = c2d(G, h)

F = tf([1, -0.8], [1, .2], h);
figure(1)
clf
rlocus(Gd*F)
set(findobj(gca, 'type', 'line'), 'linewidth', 2);
set(findobj(gca, 'type', 'line'), 'MarkerSize', 10);

K = 20;


Gcb = feedback(Gd, K*F);
t0 = 1/dcgain(Gcb)

Gc = t0*Gcb

Gc2 = feedback(K*Gd*F, 1);

figure(2)
clf
step(Gc, Gc2);
set(findobj(gca, 'type', 'line'), 'linewidth', 2);
set(findobj(gca, 'type', 'line'), 'MarkerSize', 10);


figure(3)
subplot(121)
pzmap(Gc, 'b')
title('Gc')
set(findobj(gca, 'type', 'line'), 'linewidth', 2);
set(findobj(gca, 'type', 'line'), 'MarkerSize', 10);
subplot(122)
pzmap(Gc2, 'r')
title('Gc2')
set(findobj(gca, 'type', 'line'), 'linewidth', 2);
set(findobj(gca, 'type', 'line'), 'MarkerSize', 10);


% Effect of anti-aliasing filter
H_aa = tf([1], [1, 0], h)

figure(4)
Go = K*F*Gd;
Go_aa = K*F*Gd*H_aa;
margin(Go)
figure(5)
margin(Go_aa)

figure(6)
Gc_aa = t0*feedback(Gd, K*F*H_aa)
bodemag(Gc, Gc_aa)

ylim([-50, 20])


