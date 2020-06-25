%% Mean arteriar pressure, automatic anasthesia model

% Plant
G = tf([1], [120 1 0])

a = 1/100;
b = 1/160;

s = tf('s');
F0 = (160*s+1)/(100*s+1)

    
%F0 = zpk([-b], [-a], a/b);

K = 1e-2;

F = K*F0

Gc = feedback(G*F, 1);


figure(1)
clf
rlocus(G*F)
print -dpdf map_rlocus.pdf


figure(2)
clf
step(Gc)

%%
% Sample the system

h = 12; % in seconds, equal to delay
Gd = c2d(G, h)


% State space system
A = [0, 1; 0 -1/120];
B = [0;1/120];
C = [1, 0];

sys = ss(A, B, C, [])

K = [24/1000, 1.4];

eig (A-B*K)

k0 = 12/50;

sys_c = ss(A-B*K, k0*B, C, []);

figure
step(sys_c)
