% L8 - spring 2016
% PI tuning of double tank system

G = zpk([], [-0.0179, -0.0129], 0.00048)

[y, ts] = step(G);
figure(1)
clf
plot(ts, y, 'b', 'linewidth', 3);
xlabel('Time [s]')
ylabel('y')
title('Step response')
grid on

figure(2)
clf
impulse(G);

% From plots above,
R = 0.01
t_R = 65;
DT = 0.5/R;
L = 65-DT
a=R*L

t = linspace(0, 250, 4);
ytang = R*t - L*R;
figure(1)
hold on
plot(t, ytang, 'r', 'linewidth', 2)
set(gca, 'xtick', [0, L, 100, 200, 300, 400, 500, 600])
text(270, 2.2, 'R=0.01,  a=RL=0.15')
print -dpdf tank_step_ZN.pdf

K_P = 1/a;
K_PI = 0.9/a;
K_PID = 1.2/a;

T_i = 3*L;
T_iD = 2*L;
T_d = 0.5*L;

s = tf('s') 
N = 20
F_P = K_P
F_PI = K_PI*(1 + 1/(T_i*s));
F_PID = K_PID*(1 + 1/(T_i*s) + T_d*s/(1 + T_d*s/N));
Gc_P = G*F_P/(1+G*F_P);
Gc_PI = G*F_PI/(1+G*F_PI);
Gc_PID = G*F_PID/(1+G*F_PID);

figure(3)
clf
step(Gc_P, Gc_PI, Gc_PID)

hline = findobj(gcf, 'type', 'line');
set(hline, 'linewidth', 3)
print -dpdf tank_step_Gc.pdf

%legend('P-control', 'PI-control', 'PID-control')

% Add a first order system for the valve dynamics. Do the ultimate
% sensitivity test
Gv = 1/(s+1);
G2 = Gv*G;

Ku = 66.1;
Gcu = Ku*G2/(1+Ku*G2);
[yu, tu] = step(Gcu, 200);
figure(4)
clf
plot(tu, yu, 'linewidth', 3)
grid on
ylabel('y')
xlabel('time [s]')
title('Ultimate sensitivity test. Ku=66.1')
print -dpdf tank_ultimate_sens.pdf

Tu = (180-35)/4

K = 0.6*Ku
Ti = Tu/2
Td = Tu/8

F_PID = K*(1 + 1/(Ti*s) + Td*s);
Gc_PID = G2*F_PID/(1+G2*F_PID);

figure(3)
clf
step(Gc_PID)

hline = findobj(gcf, 'type', 'line');
set(hline, 'linewidth', 3)
print -dpdf tank_step_Gc_ultimate.pdf







