%% HW 6

h = 0.3;
emh = exp(-h);

F = [emh, 1-emh; 0, 1];
G = [emh+h-1;h];
C = [1, 0];
D = [];

B =[emh+h-1, 1-emh-h*emh];
A = [1, -1-emh, emh];

sys = ss(F,G,C,D,h);

pdesired = [0.5+0.5*i, 0.5-0.5*i];
polydesired = [1, -sum(pdesired), pdesired(1)*pdesired(2)]

place(F,G,pdesired)
m0 = sum(polydesired)/sum(B)

% Controllable form

Fc = [1+emh, -emh; 1, 0];
Gc = [1;0];
Cc = [emh+h-1, 1-emh-h*emh];

sysc = ss(Fc, Gc, Cc, D, h);

place(Fc, Gc, pdesired)
