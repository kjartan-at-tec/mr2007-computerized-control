%% Gantry crane position control 

% Kjartan Halvorsen 
% 2021-06-27

% Parameters
g = 9.8;
l = 15; % Length of cable
wn = sqrt(g/l);
h = 2/wn; % Sampling period

% Desired closed-loop poles
pc = [-1/2/wn, -1/2/wn]; % Continuous time
pd = [0, 0]; % Discrete time, dead-beat control

A = [0, 1
    -wn^2 0];
B = [0;wn^2];
C = [1, 0];
D = [0];

sys = ss(A, B, C, D);
Lc = acker(A, B, pc)
sys_cl = ss(A-B*Lc, B, C, D);
l0 = 1/dcgain(sys_cl)

sys_d = c2d(sys, h);
[Ad, Bd] = ssdata(sys_d);
Ld = acker(Ad, Bd, pd)
sys_cld = ss(Ad-Bd*Ld, Bd, C, D, h);
l0d = 1/dcgain(sys_cld)