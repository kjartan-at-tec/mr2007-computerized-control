    % MR2007 symbolic Diophantine eqn
close all
clear all

syms r1 s0 s1 s2 p1 p2 po1 po2 z

% Plant
wh = pi/6;
cwh = cos(wh);
b1 = 1-cwh;
b2 = b1;
a1 = -2*cwh;
a2 = 1; 

Bp = [b1, b2];
Ap = [1, a1, a2];

% Incremental controller
[sol, t0, LHS, RHS] = RST_sym(Bp, Ap, 0, 1);

%% Substitute numerical values

p1_n = 0.6+1j*0.3;
p2_n = 0.6-1j*0.3;
obspole = 0.3
po1_n = obspole;
po2_n = obspole;
Ao_n = conv([1, -po1_n], [1, -po2_n]);

vars = [p1, p2, po1, po2];
numvals = [p1_n, p2_n, po1_n, po2_n];
r1_n = double( subs(sol.r1, vars, numvals) );
s0_n = double( subs(sol.s0, vars, numvals) );
s1_n = double( subs(sol.s1, vars, numvals) );
s2_n = double( subs(sol.s2, vars, numvals) );

RHS0 = RHS
LHS0 = LHS
RHScoeffs0 = coeffs(subs(RHS, vars, numvals));
LHScoeffs0 = coeffs(subs(LHS, vars, numvals));

t0_n = double( subs(t0, vars, numvals) );

allvars = [p1, p2, po1, po2, r1, s0, s1, s2];
allnumvals = [p1_n, p2_n, po1_n, po2_n, r1_n, s0_n, s1_n, s2_n];
LHS = subs(LHS, allvars, allnumvals);
RHS = subs(RHS, allvars, allnumvals);
LHScoeffs = coeffs(LHS);
RHScoeffs = coeffs(RHS);

LHSroots = roots(double(fliplr(LHScoeffs)))
RHSroots = roots(double(fliplr(RHScoeffs)))


%% Form closed-loop system and simulate

h = 1;
G = tf(Bp, Ap, h);
Sp = [s0_n, s1_n, s2_n];
Rp = conv([1, -1], [1, r1_n]);

%Sp = [1.79, -1.25, 1.99]
%Rp = conv([1, -1], [1, 0.39]);


Fb = tf(Sp, Rp, h);
Ff = t0_n*tf(Ao_n, Rp, h);

Gc = minreal( Ff*feedback(G, Fb))
Gd = minreal( feedback(1, G*Fb))

figure(1)
pzmap(Gc)

figure(2)
clf
step(Gc, Gd)


