    % MR2007 symbolic Diophantine eqn
close all
clear all

syms r1 r2 s0 s1 s2 z p1 p2 p3 po1 po2

alpha = -0.9;
beta = 0.9;
k = 0.1;

[sol, t0] = RST_sym(k*[1, beta], [1, alpha], 2);
[sol2, t02] = RST_sym(k*[1, beta], [1, alpha], 2, 1);

%% Substitute numerical values

p1_n = 0.8;
p2_n = 0.7+1j*0.3;
p3_n = 0.7-1j*0.3;
obspole = 0.3
po1_n = obspole;
po2_n = obspole;
po3_n = obspole;
Ao_n = conv([1, -po1_n], [1, -po2_n]);

vars = [p1, p2, p3, po1, po2];
numvals = [p1_n, p2_n, p3_n, po1_n, po2_n];
r1_n = double( subs(sol.r1, vars, numvals) );
r2_n = double( subs(sol.r2, vars, numvals) );
s0_n = double( subs(sol.s0, vars, numvals) );
s1_n = double( subs(sol.s1, vars, numvals) );
s2_n = double( subs(sol.s2, vars, numvals) );

t0_n = double( subs(t0, vars, numvals) );

%% Form closed-loop system and simulate

h = 1;
G = k*tf([1, beta], [1, alpha], h);
Sp = [s0_n, s1_n, s2_n];
Rp = [1, r1_n, r2_n];
Fb = tf(Sp, Rp, h);
Ff = t0_n*tf(Ao_n, Rp, h);

Gc = minreal( Ff*feedback(G, Fb*tf([1], [1, 0, 0], h)) )
Gd = minreal( feedback(1, G*Fb*tf([1], [1, 0, 0], h)) )

figure(2)
clf
step(Gc, Gd)



%% With incremental controller
syms po3
po3_n = obspole;    
Ao_n = conv(conv([1, -po1_n], [1, -po2_n]), [1, -po3_n]);


vars = [p1, p2, p3, po1, po2, po3];
numvals = [p1_n, p2_n, p3_n, po1_n, po2_n, po3_n];
r1_n = double( subs(sol2.r1, vars, numvals) );
r2_n = double( subs(sol2.r2, vars, numvals) );
s0_n = double( subs(sol2.s0, vars, numvals) );
s1_n = double( subs(sol2.s1, vars, numvals) );
s2_n = double( subs(sol2.s2, vars, numvals) );
s3_n = double( subs(sol2.s3, vars, numvals) );

t0_n = double( subs(t02, vars, numvals) );

% Form closed-loop system and simulate

h = 1;
Sp = [s0_n, s1_n, s2_n, s3_n];
Rp = [1, r1_n, r2_n];
Rp = conv([1, -1], Rp);
Fb = tf(Sp, Rp, h);
Ff = t0_n*tf(Ao_n, Rp, h);

Gc = minreal( Ff*feedback(G, Fb*tf([1], [1, 0, 0], h)) )
Gd = minreal( feedback(1, G*Fb*tf([1], [1, 0, 0], h)) )

figure(3)
clf
step(Gc, Gd)

%% Debug
if 0
syms r1 r2 s1 s2 s3 s4
allvars = cat(2, vars, [r1, r2, s1, s2, s3, s4]);
allnumvals = cat(2, numvals, ...
            double(subs(sol2.r1, vars, numvals)),...
            double(subs(sol2.r2, vars, numvals)),...
            double(subs(sol2.s1, vars, numvals)),...
            double(subs(sol2.s2, vars, numvals)),...
            double(subs(sol2.s3, vars, numvals)),...
            double(subs(sol2.s4, vars, numvals)))
lhs_s = subs(lhs, allvars, allnumvals)
rhs_s = subs(rhs, allvars, allnumvals)

lhs_n = double( lhs_s );
rhs_n = double( rhs_s );

roots(lhs_n)
roots(rhs_n)
end