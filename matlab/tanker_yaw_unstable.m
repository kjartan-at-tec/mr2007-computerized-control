%% Final exam
% 2nd order system, unstable normalized model of yaw dynamics of tanker

h = 0.2; % Sampling period
eh = exp(h);

% Cont time model
G = tf([1], [1, -1, 0])

% Discretized
Hc2d = c2d(G, h)

% Explicit discrete model
Hde = tf([-1+eh-h, 1-(1-h)*eh], [1, -1-eh, eh], h)

% Approximate model
Hd = tf([0.02, 0.02], [1, -2.2, 1.2], h)

figure(1)
bode(Hde, Hd)

%% PD control
N= 20;
Td = 0.762;
s = tf('s');
Fpd = 1 + Td*s/(1 + Td*s/N)
Fpdd = c2d(Fpd, h, 'tustin')

Hopd = Hd*Fpdd
figure(2)
rlocus(Hopd)  % K=4 seems reasonable

Hcpd = feedback(4*Hopd, 1);
figure(3)
bode(Hcpd)
bandwidth(Hcpd)

[mag,ph,w] = bode(Hcpd);

dlmwrite('final-bode-closed.dat', [w(:), mag2db(mag(:)), ph(:)], 'delimiter', ',')

%% State feedback
F = [2.2 -1.2;1 0];
G = [1;0];
C = [0.02, 0.02];
sys_d = ss(F,G,C,[], h)
L = [0.4, -0.38];
eig(F - G*L)

m0 = (1-1.8+0.82)/sum(C)

sys_cl = ss(F-G*L, m0*G, C, [], h);
figure(4)
bode(sys_cl)

[mag,ph,w] = bode(sys_cl);
dlmwrite('final-bode-statefb-closed.dat', [w(:), mag2db(mag(:)), ph(:)], 'delimiter', ',')

bandwidth(sys_cl)
