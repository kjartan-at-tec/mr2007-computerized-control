%% Maglev exercise Partial exam 2 MR2007 Spring18

w = 1;
h = 0.2/w;

A = [0, 1; w^2, 0];
B = [0;1];
C = [1, 0];

sys_c = ss(A ,B,C, 0)

sys_d = c2d(sys_c, h)


% Continuous-time design. Bode plot. 
pc = [-1+1j, -1-1j]; % Desired closed-loop poles
po = pc*4; % Desired observer poles
L = place(A, B, pc)
K = place(A', C', po)'

% Form the open-loop state-space system
AA = [A zeros(size(A)); K*C A-K*C];
BB = [B;B];
CC = [zeros(size(L)) L];
sys_o = ss(AA, BB, CC, zeros(1, 1))

% Form the closed-loop state-space system
AA = [A -B*L; K*C A-K*C-B*L];
BB = [B;B];
CC = [C zeros(size(C))];

sys_c = ss(AA, BB, CC, zeros(1, 1))


% Discrete-time system
[Phi, Gamma] = ssdata(sys_d)
pd = exp(h*pc);
pod = [0,0];
Ld = place(Phi, Gamma, pd)
Kd = acker(Phi', C', pod)'

% Form the open-loop discrete-time state-space system
PP = [Phi zeros(size(A)); Kd*C Phi-Kd*C];
GG = [Gamma;Gamma];
CCd = [zeros(size(Ld)) Ld];
sys_od = ss(PP, GG, CCd, zeros(1, 1), h)
% Form the closed-loop discrete-time state-space system
PP = [Phi -Gamma*Ld; Kd*C Phi-Kd*C-Gamma*Ld];
GG = [Gamma;Gamma];
CCd = [C zeros(size(C))];
sys_cd = ss(PP, GG, CCd, zeros(1, 1), h)

figure(1)
clf
bode(sys_o, sys_od)
print -dpdf maglev_ss_bode.pdf
ww = logspace(-1, 2, 400);
[mag,ph] = bode(sys_od, ww);
dlmwrite('maglev_ss_bode.dta', cat(2, ww', mag(:), ph(:)))

figure(2)
clf
nyqlog(tf(sys_o))
print -dpdf maglev_ss_nyqlog.pdf


figure(3)
clf
step(sys_c, sys_cd)

figure(4)
clf
margin(sys_od)


%% Bessel filter
wN = pi/h
w0 = wN/5.33;

Ha = tf([3], [(1/w0)^2, 3/w0, 3]);
figure(5)
bode(Ha)
abs(evalfr(Ha, 1j*wN))
[mag,ph] = bode(Ha, ww);
dlmwrite('bessel_bode.dta', cat(2, ww', mag(:), ph(:)))


