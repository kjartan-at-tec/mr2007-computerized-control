%% Parameters and analysis for ant-windup demo
%%
%% Kjartan Halvorsen
%% 2015-10-09

% Saturation limits
uHigh=0.2;
uLow = -0.2;


% Open-loop tranfer function with PID will give
wc = 1.9
phi_m = 46.1

deltaPhi = 5*pi/180; % Allowable reduction in phase margin
% Sampling time
h = 2*deltaPhi/wc

% Max gain of modified D-term
N = 15;


% The plant
G = zpk([-3], [0, -2, -1+2*i, -1-2*i], 5)

figure(1)
clf
margin(G)

%% Critical gain and period
wp = 2.04;
Tu = 2*pi/wp;
Ku = db2mag(2.56)

%% PID parameters according to Carr 1986
Kp = 0.6667*Ku;
Ti = Tu;
Td = 0.167*Tu;

%% Reset time of anti-windup
Tt = 2*Ti;


s = tf('s') % Laplace s
F = Kp*(1 + 1/(Ti*s) + Td*s/(1+Td/N*s));

G0 = G*F;
Gc = feedback(G0, 1);

figure(2)
clf
nyquist(G0)

figure(3)
clf
margin(G0)

figure(4)
clf
step(Gc)


