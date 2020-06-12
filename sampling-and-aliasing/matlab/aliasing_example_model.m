%% Set values for aliasing example
s = tf('s');

% Tank and valve system
G1 = 1/(s + 1);
G2 = 3/(s+3);
G = G1*G2; % 

%% Controller: PI
Ti = 0.4;
%Td = 4;
%N = 30;
K = 3;
F = K *(1 +  1/(Ti*s));

%% Loop gain
Go = F*G;
figure(1)
clf
margin(Go)

figure(2)
clf
step(G)

[Gnum, Gden] = tfdata(G);

%% Closed-loop continuous system
Gc = feedback(Go, 1);
figure(3)
bode(Gc)
ww = logspace(-1, 2, 400);
[mag,phas] = bode(Gc, ww);
dlmwrite('alias-example-GC-bode.dta', cat(2, ww(:), mag(:), phas(:)), 'delimiter', ','); 

%% Discretize the controller

h = 2/10; % tr about 2s
Fd = c2d(F, h, 'foh');
[Fdnum, Fdden] = tfdata(Fd)

%% Bad excitation frequency
% Resonance freq
wr = 2.75;
ws = 2*pi/h;
wN = ws/2;
wralias = wN + (wN-wr)




