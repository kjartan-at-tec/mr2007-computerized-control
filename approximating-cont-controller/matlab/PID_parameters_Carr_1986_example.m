%% Problem solving session 5  
%% 2015-10-02

G = zpk([-3], [0, -2, -1+2*i, -1-2*i], 5)

figure(1)
clf
margin(G)
grid on

wp = 2.04;
Tu = 2*pi/wp;
Ku = db2mag(2.56)

%% PID parameters according to 8.3
Kp = 0.6*Ku;
Ti = Tu/2;
Td = Tu/8;

s = tf('s') % Laplace s
F = Kp*(1 + 1/(Ti*s) + Td*s);

G0 = G*F;
Gc = feedback(G0, 1);

figure(2)
clf
step(Gc)

figure(3)
clf
nyquist(G0)

figure(4)
clf
margin(G0)

%% PID parameters according to Carr 1986
Kp2 = 0.6667*Ku;
Ti2 = Tu;
Td2 = 0.167*Tu;

s = tf('s') % Laplace s
F2 = Kp2*(1 + 1/(Ti2*s) + Td2*s);

G02 = G*F2;
Gc2 = feedback(G02, 1);

figure(2)
hold on
step(Gc2)

figure(3)
hold on
nyquist(G02)

figure(5)
clf
margin(G02)

