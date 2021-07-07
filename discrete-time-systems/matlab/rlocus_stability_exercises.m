%% Rlocus exercises 

% Kjartan Halvorsen
% 2021-07-04
clear all
s = tf('s');
G1 = 1/s^2;
G1d = c2d(G1, 1)*tf([1, -0.5], [1, 0.4], 1)
figure(1)
clf
rlocus(G1d)
[z, p, k] = zpkdata(G1d);
z{1}
p{1}
k



g = 9.8;
l = 15; % Length of cable
wn = sqrt(g/l);
h = 0.6/wn; % Sampling period

G2 = wn^2/(s^2 + wn^2);
G2d = c2d(G2, h)
figure(2)
clf
rlocus(G2d)
rpart = 0.8;
impart = 0.2;
F2 = tf(conv([1, -rpart+impart*1j], [1, -rpart-impart*1j]), conv([1, 0.5], [1, -1]), h)
G2dd = G2d*F2
rlocus(G2dd)