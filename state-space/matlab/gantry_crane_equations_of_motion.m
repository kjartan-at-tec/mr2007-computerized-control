%% Equations of motion for the gantry crane.

% Kjartan Halvorsen
% 2021-07-18

syms t x(t) th1(t) th2(t) l1 l2 mt mc g

% x     -  horizontal position of trolley
% th1   -  angle of wire to vertical
% th2   -  angle of container to wire
% l1    -  length of wire
% l2    -  distance from wire connection to CoM of the container
% mt    -  mass of the trolley
% mc    -  mass of the container

v = diff(x(t), t)
w1 = diff(th1(t), t)
w2 = diff(th2(t), t)

% Position of the container
xc = x(t) + l1*sin(th1(t)) + l2*sin(th1(t) + th2(t));
yc = -l1*cos(th1(t)) - l2*cos(th1(t) + th2(t));

vc_x = diff(xc, t)
vc_y = diff(yc, t)

% Kinetic energy of the trolley
Tt = 1/2 * mt * v*v;
% Kinetic energy of the container
Tc = 1/2 * mc * (vc_x*vc_x + vc_y*vc_y)

% Potential energy of the container
V = mc*g*vc_y;

% Lagrangian
L = Tt+Tc - V;

% Derivative wrt the generalized velocities
dLdv = diff(L, v)
dLdw1 = diff(L, w1)
dLdw2 = diff(L, w2)

% ... and differentiated wrt time
ddt_dLdv = diff(dLdv, t)
ddt_dLdw1 = diff(dLdw1, t)
ddt_dLdw2 = diff(dLdw2, t)

% Derivative wrt the generalized coordinates
dLdx = diff(L, x(t))
dLdth1 = diff(L,th1(t))
dLdth2 = diff(L,th2(t))




