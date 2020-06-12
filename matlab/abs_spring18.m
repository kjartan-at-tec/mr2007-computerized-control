%% ABS brakes exercise

% Plant
a = -1;  % Nominal
a0 = 0; % True
s = tf('s');
G = 1/(s*(s+a));
Gd = -1/(s+a);

G0 = 1/(s*(s+a0));
Gd0 = -1/(s+a0);

% Discretization
h = 0.2;
H = c2d(G, h)
Hd = c2d(Gd, h)

H0 = c2d(G0, h);
Hd0 = c2d(Gd0, h);




%% Lead compensator
F_l = zpk(0.9,0.2, 1, h)

figure(1)
clf
rlocus(F_l*H)


K = 10;

% closed-loop system from disturbance
Hcd = minreal(Hd*feedback(1, K*F_l*H));
Hcd0 = minreal(Hd0*feedback(1, K*F_l*H0));
Hcd2 = minreal(Hd0*feedback(1, K*F_l*H*tf([1],[1, 0], h)));

pole(Hcd)

figure(2)
clf
step(Hcd, Hcd0, Hcd2)
tvec = 0:h:7;
ys = step(Hcd, tvec);
dlmwrite('abs-lead-steps.dat', cat(2, tvec', ys), 'delimiter', '\t');



figure(3)
set(gcf, 'position', [100,100, 700, 600])
clf
zgrid
hold on
plot(real(pole(Hcd)), imag(pole(Hcd)), 'x', 'markersize', 10, 'linewidth', 1.5)
axis equal
print -dpdf abs-lead-poles.pdf

pc = log(pole(Hcd))/h

pcdesired = [-4+1j, -4-1j, -3-2*1j, -3+2*1j];
pddesired = exp(h*pcdesired);
plot(real(pddesired), imag(pddesired), 'rx', 'markersize', 10, 'linewidth', 1.5)
plot(0, 0, 'gx', 'markersize', 10, 'linewidth', 1.5)
axis equal

print -dpdf abs-desired-poles.pdf


figure(6)
h = 0.2;
pcdesired0 = [-1 + 0.6*1j, -1 - 0.6*1j];
pddesired0 = exp(h*pcdesired0);
set(gcf, 'position', [100,100, 700, 600])
clf
zgrid
hold on
plot(real(pddesired0), imag(pddesired0), 'x', 'markersize', 10, 'linewidth', 1.5)
axis equal
print -dpdf abs-desired0-poles.pdf

figure(7)
set(gcf, 'position', [200,200, 400, 600])
plot(real(pcdesired0), imag(pcdesired0), 'x', 'markersize', 10, 'linewidth', 1.5)
xlabel('Re')
ylabel('Im')
xlim([-2,0])
ylim([-1, 1])
sgrid
print -dpdf abs-desired0-cont-poles.pdf



%% RST design

syms r1 r2 r3 s0 s1 s2 s3 z 

% Plant
[num,den] = tfdata(H);
A = z^2+den{1}(2)*z + den{1}(3);
B = num{1}(1)*z^2 + num{1}(2)*z + num{1}(3);
d = 2;

% Controller polynomials
R = z^3 + r1*z^2 + r2*z + r3;
S = s0*z^3 + s1*z^2 + s2*z + s3;

% Left hand side of Diophantine eqn
LHS = collect(A*R*z^d + B*S, z)

% Right hand side
Ao = z^3;
Ac = 1;
for i=1:4
    Ac = Ac*(z-pddesired(i));
end

RHS = collect(Ac*Ao, z)

% Coefficients
LHScoeffs = coeffs(LHS, z, 'All') % Coefficients in decreasing power of z
RHScoeffs = coeffs(RHS, z, 'All')

% Set up system of equations
unknowns = [r1, r2, r3, s0, s1, s2, s3];
%[M, b] = equationsToMatrix(LHScoeffs(1:end-1) - RHScoeffs(1:end-1), ...
%    unknowns)

% Or use the solve function
sol = solve(LHScoeffs(2:end) - RHScoeffs(2:end), unknowns)

% Find t0
t0 = subs(Ac, z, 1) / subs(B, z, 1)

%% Substitute with numerical values
r1_n = double(sol.r1);
r2_n = double(sol.r2);
r3_n = double(sol.r3);
s0_n = double(sol.s0);
s1_n = double(sol.s1);
s2_n = double(sol.s2);
s3_n = double(sol.s3);

t0_n = double(t0);

%% Form closed-loop system and simulate
Ao_n = [1, 0, 0, 0];
Sp = [s0_n, s1_n, s2_n, s3_n];
Rp = [1, r1_n, r2_n, r3_n];
Fb = tf(Sp, Rp, h);
Ff = t0_n*tf(Ao_n, Rp, h);

Gc = minreal( Ff*feedback(H, Fb*tf([1], [1, 0, 0], h)) )
Gcd = minreal(Hd*feedback(1, H*Fb*tf([1], [1, 0, 0], h)))
Gc2 = minreal( Ff*feedback(H, Fb) )
Gcd2 = minreal(Hd*feedback(1, H*Fb))

figure(4)
clf
subplot(121)
step(Gc)
subplot(122)
step(Gcd)

tvec = 0:h:7;
ys = step(Gcd, tvec);
dlmwrite('abs-rst-steps.dat', cat(2, tvec', ys), 'delimiter', '\t');














