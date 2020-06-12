function sol = first_order_RST_sym(d)

syms alpha beta k 
r = sym('r', [1
r1 r2 r3 s0 s1 s2 s3 z p1 p2 p3 po1 po2

% Plant

A = z+alpha;
B = k*(z+beta);

    

% Controller polynomials
R = z^2 + r1*z + r2;
S = s0*z^2 + s1*z + s2;

% Left hand side of Diophantine eqn
LHS = collect(A*R*z^d + B*S, z)

% Right hand side
Ac = (z-p1)*(z-p2)*(z-p3);
Ao = (z-po1)*(z-po2);
RHS = collect(Ac*Ao, z)

% Coefficients
LHScoeffs = coeffs(LHS, z) % Coefficients in increasing power of z
RHScoeffs = coeffs(RHS, z)

% Set up system of equations
unknowns = [r1, r2, s0, s1, s2];
[M, b] = equationsToMatrix(LHScoeffs(1:end-1) - RHScoeffs(1:end-1), ...
    unknowns)

% Or use the solve function
sol = solve(LHScoeffs(1:end-1) - RHScoeffs(1:end-1), unknowns)

% Find t0
t0 = subs(Ac, z, 1) / subs(B, z, 1)

%% Substitute with numerical values
 
alpha_n = -0.9;
beta_n = 0.9;
k_n = 0.1;
p1_n = 0.8;
p2_n = 0.7+1j*0.3;
p3_n = 0.7-1j*0.3;
po1_n = 0.3;
po2_n = 0.3;

vars = [alpha, beta, k, p1, p2, p3, po1, po2];
numvals = [alpha_n, beta_n, k_n, p1_n, p2_n, p3_n, po1_n, po2_n];
r1_n = double( subs(sol.r1, vars, numvals) );
r2_n = double( subs(sol.r2, vars, numvals) );
s0_n = double( subs(sol.s0, vars, numvals) );
s1_n = double( subs(sol.s1, vars, numvals) );
s2_n = double( subs(sol.s2, vars, numvals) );

t0_n = double( subs(t0, vars, numvals) );
Ao_n = double(subs(coeffs(Ao, z), vars, numvals));
Ao_n = fliplr(Ao_n)

%% Form closed-loop system and simulate

h = 1;
G = k_n*tf([1, beta_n], [1, alpha_n], h);
Sp = [s0_n, s1_n, s2_n];
Rp = [1, r1_n, r2_n];
Fb = tf(Sp, Rp, h);
Ff = t0_n*tf(Ao_n, Rp, h);

Gc = minreal( Ff*feedback(G, Fb*tf([1], [1, 0, 0], h)) )

figure(2)
clf
step(Gc)




