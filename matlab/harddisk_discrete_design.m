%% Harddisk drive position control 

% Kjartan Halvorsen 
% 2021-06-27

close all 
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

figure(2)
clf
step(Gc);
set(findobj(gca, 'type', 'line'), 'linewidth', 2);
set(findobj(gca, 'type', 'line'), 'MarkerSize', 10);


figure(3)
clf
pzmap(Gc)
set(findobj(gca, 'type', 'line'), 'linewidth', 2);
set(findobj(gca, 'type', 'line'), 'MarkerSize', 10);


% Effect of anti-aliasing filter
H_aa = tf([1], [1, 0], h)

figure(4)
clf
Go = K*F*Gd;
Go_aa = K*F*Gd*H_aa;
margin(Go)
set(findobj(gcf, 'type', 'line'), 'linewidth', 2);
set(findobj(gcf, 'type', 'line'), 'MarkerSize', 10);

ch = get(gcf, 'Children');
ch(2).FontSize = 14;
ch(3).FontSize = 14;
ch(2).YLim = [-270, -90];
ch(3).YLim = [-50, 100];

print(gcf, '-dpdf', 'harddisk_margin.pdf')
unix('pdfcrop harddisk_margin.pdf harddisk_margin_crop.pdf')


figure(5)
margin(Go_aa)
set(findobj(gcf, 'type', 'line'), 'linewidth', 2);
set(findobj(gcf, 'type', 'line'), 'MarkerSize', 10);
ch = get(gcf, 'Children');
ch(2).FontSize = 14;
ch(3).FontSize = 14;
ch(2).YLim = [-270, -90];
ch(3).YLim = [-50, 100];

print(gcf, '-dpdf', 'harddisk_margin_aa.pdf')
unix('pdfcrop harddisk_margin_aa.pdf harddisk_margin_aa_crop.pdf')


figure(6)
Gc_aa = t0*feedback(Gd, K*F*H_aa)
bodemag(Gc, Gc_aa)
ylim([-50, 20])
legend

figure(7)
clf
nyquist(Go)
hold on
plot(cosd(linspace(0,360)), sind(linspace(0, 360)), 'k:')
set(findobj(gcf, 'type', 'line'), 'linewidth', 2);
set(findobj(gcf, 'type', 'line'), 'MarkerSize', 10);
ylim([-2, 2])
xlim([-5, 1])
axis equal

ax = gca;

print(gcf, '-dpdf', 'harddisk_nyquist.pdf')
unix('pdfcrop harddisk_nyquist.pdf harddisk_nyquist_crop.pdf')

figure(8)
clf
nyquist(Go_aa)
hold on
plot(cosd(linspace(0,360)), sind(linspace(0, 360)), 'k:')
set(findobj(gcf, 'type', 'line'), 'linewidth', 2);
set(findobj(gcf, 'type', 'line'), 'MarkerSize', 10);
ylim([-2, 2])
xlim([-5, 1])
axis equal
print(gcf, '-dpdf', 'harddisk_nyquist_aa.pdf')
unix('pdfcrop harddisk_nyquist_aa.pdf harddisk_nyquist_aa_crop.pdf')

