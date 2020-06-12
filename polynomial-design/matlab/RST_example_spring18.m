%% MR2007 RST example spring 18
alpha = -0.9;
beta = 0.9;
k = 0.1;

% Plant
z = tf('z', 1);
G = k*(z + beta)/(z+alpha);

figure(1)
clf
step(G)

% Desired poles
p1 = 0.8;
p2 = 0.8;
p0 = 0; % Observer pole
Ac = conv( conv([1, -p1], [1, -p2]), [1, -p0])

% System of eqns
M = [1, k, 0
    alpha, k*beta, k
    0, 0, k*beta]
b = [-(p1+p2+p0) - alpha
    p0*p1 + p0*p2 + p1*p2
    -p1*p2*p0]

% Solution
params = M \ b;

r1 = params(1)
s0 = params(2)
s1 = params(3)

Fb = (s0*z + s1) / (z + r1);

t0 = (1-p1)*(1-p2) / (k*(1+beta))

Ff = t0*z/(z + r1);

% The closed-loop system

Gc = minreal(Ff * feedback(G, Fb/z))
pole(Gc)


figure(2)
clf
step(Gc)





