function [sol, t0, LHS, RHS] = RST_sym(num, den, d, incr)
% [sol, t0] = RST_sym(num, den, d, incr)
%
% Returns symbolic solution to RST design for plant G(z)=B(z)/A(z)
% with delay 1/z^d or d time steps. The order of the plant is deg(A)=nA. 
%
% Input
%   num       ->  Vector of coefficients for numerator polynomical
%                 B(z) of the plant
%   den       ->  Vector of coefficients for denominator polynomical
%                 A(z) of the plant
%   d         ->  Integer number of delays in the feedback loop
%   incr      ->  1 for incremental controller, 0 for non-incremental
%
% Output
%   sol       <-  Struct containing the symbolic solutions to the
%                 controller parameters r1, r2, ..., rn and s0, s1,
%                 s2, ..., sn. 
%                 The solutions contain symbols for the closed-loop
%                 poles p1, p2, ..., pnA and the observer poles
%                 po1, po2, ..., pon
%   t0        <-  Symbolic expression for the forward controller
%                 gain t0
%
% In order to obtain numerical values for the solution, substitute
% numerical values for the desired closed-loop poles and observer
% poles. For instance
%  syms p1, p2, po1, po2  % Declare symbols for the desired poles
%  p1_n = 0.8; p2_n=0.8; po1_n=0; po2_n=0; % Desired poles
%  vars = [p1, p2, po1, po2];
%  vals = [p1_n, p2_n, po1_n, po2_n];
%  r1_n = subs(sol.r1, vars, vals);

% Kjartan Halvorsen
% 2018-09-05

if nargin < 4
    incr = 0; % Default is non-incremental
end

syms z

% Plant
A = poly2sym(den, z); % Generates polynomial den(1)*z^nA + den(2)*z^(nA-1) + ...
B = poly2sym(num, z);


% Determine degree of controller
nA = length(den)-1; % Degree of plant denominator
nR = nA + d - 1;

if incr 
    nS = nR + 1;
else
    nS = nR;
end

% Controller polynomials
r = sym('r', [1, nR])
R = poly2sym([1, r], z);

s = sym('s', [1, nS]); % Vector starts with s1
s = cat(2, sym('s0'), s); % Now it starts with s0
S = poly2sym(s, z);
    
if incr
    R = R*(z-1);
end

% Closed-loop polynomial and observer polynomial
p = sym('p', [1, nA+d]);
po = sym('po', [1, length(coeffs(R, z, 'All'))-1]);

Ac = poly2sym(charpoly(diag(p)), z);
Ao = poly2sym(charpoly(diag(po)), z);


% Left hand side of Diophantine eqn
disp('Left hand side of Diophantine eqn')
LHS = collect(A*R*z^d + B*S, z)

% Right hand side
disp('Right hand side of Diophantine eqn')
RHS = collect(Ac*Ao, z)

% Coefficients
LHScoeffs = coeffs(LHS, z, 'All'); % Coefficients in increasing power of z
RHScoeffs = coeffs(RHS, z, 'All');

% Set up system of equations and solve
unknowns = cat(2, r, s);
sol = solve(LHScoeffs(2:end) - RHScoeffs(2:end), unknowns); %

% Find t0 as Ac(1)/B(1)
t0 = subs(Ac, z, 1) / subs(B, z, 1);

