%% Lecture 11. State space models

% On controllable canonical form
A = [-2, -0.02, 0; 1, 0, 0; 0, 1, 0];
B = [1;0;0];
C = [0,0,2];

sys_c = ss(A,B,C,[])

figure(1)
clf
rlocus(sys_c)


% Discretize model
% Assume we want a t_r of the closed-loop  system of 0.8s
% => 
h = 0.8/8;
sys_d = c2d(sys_c, h);

[Bd,Ad] = tfdata(sys_d)

% Construct controllable canonical state-space model
Fcc = [-Ad{1}(2:end);1,0,0;0,1,0];
Gcc = [1;0;0];
Ccc = Bd{1}(2:end);

sys_cc = ss(Fcc, Gcc, Ccc, [], h)
[Fd, Gd, Cd, Dd] = ssdata(sys_cc)

figure(2)
rlocus(sys_cc)


% Diago
figure(3)
clf
step({sys_d,sys_cc})

