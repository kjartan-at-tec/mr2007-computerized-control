% Solve "analytically"
f = inline('-atan2(x,2) - 0.2*x + pi')
wp = fsolve(inline('-atan2(x,2) - 0.2*x + pi'), 0)
Tu = 2*pi/wp
K = 10;
T = 0.2;
s = tf('s');

G = exp(-s*T) / (s+2)
Ku = 1/abs(evalfr(G, i*wp))

t = linspace(0,6, 400);
[y,ty]=step(G, t);
figure(1)
clf
plot(ty,y)

figure(2)
clf
bode(G)


figure(3)
clf
Gc = feedback(Ku*G, 1);
step(Gc)

if 0
for K = linspace(9,9.7,8)    
    sprintf('%2.4f', K)
    Gc = feedback(K*G, 1);
    step(Gc)
    pause
end
end

%% PID parameters according to 8.3
Kp = 0.6*Ku;
Ti = Tu/2;
Td = Tu/8;

F = Kp*(1 + 1/(Ti*s) + Td*s);

G0 = ss(F)*ss(G);
Gc = feedback(G0, 1);

Gc2 = pade(Gc, 2)

figure(2)
clf
step(Gc2)

figure(3)
clf
nyquist(G0)

figure(4)
clf
margin(G0)

figure(5)
clf
bode(Gc)
bandwidth(Gc)