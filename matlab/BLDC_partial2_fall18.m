%% Model of DC brushless motor with ESC
% https://www.hindawi.com/journals/mpe/2015/879581/
% 
s = tf('s');
w = 0.5; % Normalization constant
Hw0 = 2057342/((s/w)^3 + 189.5*(s/w)^2 + 13412*(s/w) + 142834);
% Simplified
ps = pole(Hw0)
zs = zero(Hw0)

Hw = zpk(zs, ps, 10^5);

figure(1)
clf
pzmap(Hw)

figure(2)
clf
step(Hw)

stepinfo(Hw)

%% Discretize
h = 0.05;

Hwd = c2d(Hw, h)*tf([1], [1,0], h)
pole(Hwd)

figure(2)
clf
step(Hw, Hwd)

[y, t] = step(Hwd,  1.2);
dlmwrite('BLDC-step-partial2-fall18.dta', cat(2, t(:), ((0:length(t)-1))', y(:)), 'delimiter', ','); 

%% RST design
syms r1 r2 r3 s0 s1 s2 s3 s4 p1 p2 p3 p4 po1 po2 po3 po4 z

% Plant
[num, den] = tfdata(Hwd);
Bp = num{1}
Ap = den{1}

% Incremental controller
[sol, t0, LHS, RHS] = RST_sym(Bp, Ap, 0, 1);

%% Substitute numerical values

p_n = 0.6;
po_n = 0;
Ao_n = [1, 0, 0, 0, 0];

vars = [p1, p2, p3, p4, po1, po2, po3, po4];
numvals = cat(2, repmat(p_n, 1, 4), repmat(po_n, 1, 4));
r1_n = double( subs(sol.r1, vars, numvals) );
r2_n = double( subs(sol.r2, vars, numvals) );
r3_n = double( subs(sol.r3, vars, numvals) );
s0_n = double( subs(sol.s0, vars, numvals) );
s1_n = double( subs(sol.s1, vars, numvals) );
s2_n = double( subs(sol.s2, vars, numvals) );
s3_n = double( subs(sol.s3, vars, numvals) );
s4_n = double( subs(sol.s4, vars, numvals) );

RHS0 = RHS;
LHS0 = LHS;
RHScoeffs0 = coeffs(subs(RHS, vars, numvals));
LHScoeffs0 = coeffs(subs(LHS, vars, numvals));

t0_n = double( subs(t0, vars, numvals) );

%allvars = [p1, p2, po1, po2, r1, s0, s1, s2];
%allnumvals = [p1_n, p2_n, po1_n, po2_n, r1_n, s0_n, s1_n, s2_n];
%LHS = subs(LHS, allvars, allnumvals);
%RHS = subs(RHS, allvars, allnumvals);
%LHScoeffs = coeffs(LHS);
%RHScoeffs = coeffs(RHS);

%LHSroots = roots(double(fliplr(LHScoeffs)))
%RHSroots = roots(double(fliplr(RHScoeffs)))


%% Form closed-loop system and simulate

Sp = [s0_n, s1_n, s2_n, s3_n, s4_n];
Rp = conv([1, -1], [1, r1_n, r2_n, r3_n]);

Fb = tf(Sp, Rp, h);
Ff = t0_n*tf(Ao_n, Rp, h);


Hc = minreal( Ff*feedback(Hwd, Fb))
Hd = minreal( feedback(1, Hwd*Fb))

Hdel = tf([1], [1, 0, 0], h); % Delay
Hc2 = minreal( Ff*feedback(Hwd, Fb*Hdel))
Hd2 = minreal( feedback(1, Hwd*Fb*Hdel))

figure(1)
pzmap(Hc)

figure(2)
clf
step(Hc, Hd)

figure(3)
clf
step(Hc2, Hd2)

[y, t] = step(Hd, 3);
[y2, t2] = step(Hd2, 3);

dlmwrite('BLDC-closed-loop-step-partial2-fall18.dta', cat(2, t(:), ((0:length(t)-1))', y(:), y2), 'delimiter', ','); 

figure(4)
clf
bode(Hc2)

[mag,phas, ww] = bode(Hd2);
dlmwrite('BLDC-closed-loop-bode-partial2-fall18.dta', cat(2, ww(:), mag(:), phas(:)), 'delimiter', ','); 


%% Exercise 1
z = tf('z', h);
H1 = 0.66*(z+1.13)*(z+0.08)/( (z*(z-0.73)*(z-0.01+0.1*1j)*(z-0.01-0.1*1j)));
H2 = 0.66*(z+1.13)*(z+0.08)/( (z*(z-0.99)));
H3 = 0.66*(z+1.13)*(z+0.08)/( (z*(z-0.73)*(z-0.8+0.6*1j)*(z-0.8-0.6*1j)));
H4 = 0.66*(z+1.13)*(z+0.08)/( (z^2*(z-0.73)*(z-1.03)));

figure(5)
clf
pzmap(H1, H2, H3, H4)
zgrid

print -dpdf BLDC-pzmap.pdf

