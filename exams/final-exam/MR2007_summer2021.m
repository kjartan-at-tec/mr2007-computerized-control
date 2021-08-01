%% Exam Summer 2021

% Inverted pendulum
s = tf('s');
g = 9.8;
l = 1;
m = 1;
M = 1;
Mt = m+M;

G = 1/(M*l) / (s^2 - Mt/M*g/l)

%% Q1
F = 10*(s + 4.4)

figure(1)
clf
rlocus(G*F)

figure(2)
clf
margin(F*G)

%% Q2
h = 0.1;
Fd = c2d(F, h, 'tustin')



%% Q3
h=0.2;
Gd = c2d(G, h)
A = [1, -2.837, 1];
B = [0.02134, 0.02134];
H = tf(B, A, h)

% For symbolic computations
syms z
As = poly2sym(A, z); % Generates polynomial A(1)*z^nA + A(2)*z^(nA-1) + ...
Bs = poly2sym(B, z);

% Desired characteristic polynomial
p1 = 0.5;
p2 = 0.5;

Acs = (z-p1)*(z-p2);

% Observer pole
p0 = 0;
Aos = (z-p0);

% Controller polynomials
r = [1, sym('r', [1, 1])]
s = sym('s', [1, 1]); % Vector starts with s1
s = cat(2, sym('s0'), s) % Now it starts with s0
Rs = poly2sym(r, z);
Ss = poly2sym(s, z);
    

% Left hand side of Diophantine eqn
disp('Left hand side of Diophantine eqn')
LHS = collect(As*Rs + Bs*Ss, z)

% Right hand side

disp('Right hand side of Diophantine eqn')
RHS = collect(Acs*Aos, z)

% Coefficients
LHScoeffs = coeffs(LHS, z, 'All'); % Coefficients in increasing power of z
RHScoeffs = coeffs(RHS, z, 'All');

% Set up system of equations and solve
unknowns = cat(2, r(2:end), s);
sol = solve(LHScoeffs(2:end) - RHScoeffs(2:end), unknowns); %

% Find t0 as Ac(1)/B(1)
t0 = subs(Acs, z, 1) / subs(Bs, z, 1);

% Substitute numerical values
s0_n = double(sol.s0);
s1_n = double(sol.s1);
r1_n = double(sol.r1);

t0_n = double(t0);

R_c = [1, r1_n];
S_c = [s0_n, s1_n];
T_c = t0_n*double(coeffs(Aos, z, 'All')) 


% Define the controller
F_fb_c = tf(S_c, R_c, h)
F_ff_c = tf(T_c, R_c, h);

% Closed-loop system from command signal to output
Hc_c = minreal(F_ff_c * feedback(H, F_fb_c))

% Closed-loop system from command signal to control signal
Huc_c = minreal(F_ff_c * feedback(1, H*F_fb_c));

% Closed-loop system from disturbance signal to output
Hvc_c = minreal(feedback(1, H*F_fb_c));



%% Q4
Phi = [-A(2:end); 1 0]
Gamma = [1;0];
C = B
sys = ss(Phi, Gamma, C, [0], h)

pc = [0.5, 0.5];
L = acker(Phi, Gamma, pc)
sys_c = ss(Phi-Gamma*L, Gamma, C, [0], h);
l0 = 1/dcgain(sys_c)


%% Q5
Phi_e = [Phi, zeros(2,1); -C, 1]
Gamma_e = [Gamma;0];
L_e = acker(Phi_e, Gamma_e, [pc, 0.5])
% check
eig(Phi_e - Gamma_e*L_e)
Phi_e

figure(8)
clf
margin(G)

