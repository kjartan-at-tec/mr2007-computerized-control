% The plant model with delay of 0.1s
Tdelay = 0.1;
s = tf('s');
G1 = 2/s;
G2 = 4/(s+2);
G = G1*G2
[B1, A1] = tfdata(G1);
[B2, A2] = tfdata(G2);


Ku = 2.58;
Tu = 1.45;
K = 0.6*Ku;
Ti = Tu/2;
Td = Tu/8;
N = 15; % Maximal gain of derivative part
h = Tdelay;

Tt = Ti/2; % Reset time for the anti-windup protection

% Saturation
uHigh = 0.7;
uLow = -0.7;
