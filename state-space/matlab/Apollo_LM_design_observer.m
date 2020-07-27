%% State-space control of Apollo Lunar module,
% horizontal movement
%
% Kjartan Halvorsen
% July 2020

% Model parameters
J = 1e5; %kg*m^2, moment of inertia
gM = 1.62; % m/s^2 gravitational acc on the moon surface

k1 = 1/J; % Torque input u has unit Nm
k2 = gM;

% Discrete-time model
h = 1; % Sampling period, in seconds

Phi = [1, 0 , 0
    h, 1, 0
    h^2*k2/2, h*k2, 1]; % x=[\dot{th}, th, \dot{z}]
Gamma = h*k1*[1;h/2; k2*h^2/6]
C = [0,0,1]; % Velocity control
D = [0]; 

% Check discretization
A = [0, 0, 0
    1, 0, 0
    0, k2, 0];
B = [k1;0;0];
sys_ct = ss(A, B, C, D)
sys_dt = c2d(sys_ct, h)
[Phi_c2d, Gamma_c2d, C_c2d, D_c2d] = ssdata(sys_dt)

% Should be the same:
[Phi, Phi_c2d]

% Desired poles
pd = [0.7, 0.7+0.1j, 0.7-0.1j];

L_a = acker(Phi, Gamma, pd)
L_p = place(Phi, Gamma, pd) % More accurate, but no repeated poles
L = L_a;

% Find gain l0
Phic = Phi - Gamma*L;
l0 = 1/(C*inv((eye(3)-Phic))*Gamma)

%% Observer design
po = pd/2; % Midway to origin

K_a = (acker(Phi', C', po))'
K_p = (place(Phi', C', po))'
K = K_a;




