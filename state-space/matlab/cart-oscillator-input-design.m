%% PS11 - State-space models
% 2nd order system, friktionless cart on wheels with spring attached to
% wall. External driving force Fu = ku acting on the cart

w = 1; % sqrt(k/m)
h = 0.5/w; % Sampling period, wh = 0.1 

G = tf([w^2],[1, 0, w^2])

A = [0, 1; -w^2, 0];
B = [0;w^2];
C = [1, 0];
D = [];
Gss = ss(A,B,C,D);

% Sampled system
F = [cos(w*h), 1/w*sin(w*h); -w*sin(w*h), cos(w*h)];
G = [1/w^2 * (1-cos(w*h)); 1/w * sin(w*h)];
Hss = ss(F,G,C,D, h);

% Verify that it is the same as numerically sampling the cont time sys
Hcss = c2d(Gss, h);

[Bd,Ad] = tfdata(Hss);
[Bc, Ac] = tfdata(Hcss);

[Bd{1};Bc{1}]
[Ad{1};Ac{1}]


% Explicit Hq from calculations
Bde = [0, 1-cos(w*h), 1-cos(w*h)]
Ade = [1, -2*cos(w*h), 1]


% Explicit determinant of observability matrix. Compare to numerical
Wc = [G, F*G];
detWc = 2*w*sin(w*h)*(cos(w*h)-1)
det(Wc)

% Numerical example of input signal design
x2 = [2;-1];
u = inv(Wc)*x2


%% Input design with tikhonov regularization.
% x = Wce*ue, formulate as minimization problem
%   min. ||Wce*ue - x|| + delta ||ue||
% With ||x|| meaning the squared euclidean norm of x.
% See Boyd & Vandenberghe p 306

delta = 1e-4;
% Extended observability matrix
Wce = [G, F*G, F*F*G, F*F*F*G, F*F*F*F*G, F*F*F*F*F*G];

ue = inv(Wce'*Wce + delta*eye(6))*Wce'*x2
t = h*(0:10);
uu = [fliplr(ue'), zeros(1,length(t)-length(ue))];
