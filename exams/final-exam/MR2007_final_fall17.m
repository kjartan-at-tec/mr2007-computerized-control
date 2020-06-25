% MR2007 final exam fall 2017

omega0 = 1;

A = [0, 1; omega0^2, 0];
B = [0;1];
C = [1, 0];

sys_c = ss(A, B, C, 0);

% Discretization
h = 0.5

Phi = [cosh(omega0*h), 1/omega0*sinh(omega0*h)
    omega0*sinh(omega0*h), cosh(omega0*h)]
Gamma = [1/omega0^2*(cosh(omega0*h) - 1); 1/omega0*sinh(omega0*h)]

L = [1.61, 1.61];
eig(Phi-Gamma*L)


sys_d = c2d(sys_c, h);
[Phid, Gammad] = ssdata(sys_d)
H = tf(sys_d);
[num, den] = tfdata(H);
AA = den{1}
BB = num{1}

% Controller design
% Make use of the symbolic toolbox for matlab

% Desired closed-loop poles
pd = exp(-omega0*h);
Ac = conv([1, -pd], [1, -pd]);
% Observer pole
po = exp(-2*omega0*h);
Ao = [1, -po];
Acl = conv(Ac, Ao)

syms z r1 s0 s1
Rs = z + r1
Ss = s0*z + s1;
As = z^2 + z*AA(2) + AA(3)
Bs = z^2*BB(1) + z*BB(2) + BB(3)

% LHS of the Diophantine equation
LHS = As*Rs + Bs*Ss
LHScoeffs = fliplr(coeffs(LHS, z)) % Must flip, since coeffs() returns the coefficient in the lowest term first.

% The equations
eqs = LHScoeffs(2:end) - Acl(2:end)
[ADioph, bbdioph] = equationsToMatrix(eqs, [r1, s0, s1]);
RSparams = linsolve(ADioph,bbdioph)
params = double(RSparams);

R = [1; params(1)]'
S = params(2:end)'

% Check calculations
(conv(AA, R) + conv(BB, S) - Acl)'

t_0 = sum(Ac)/sum(BB) % t0 = Ac(1) / B(1) 
T = Ao * t_0;

F_fb = tf(S, R, h);
F_ff = tf(T, R, h);
%H_aa = tf([1], [1, 0, 0], h) % Delay of two sampling periods
H_aa = 1;

% Closed-loop system from command signal to output
Hc = F_ff * feedback(H, F_fb*H_aa);
% Closed-loop system from disturbance to output
Hd = feedback(1, H*F_fb*H_aa);
% Closed-loop system from noise to output
Hn = -feedback(H*F_fb*H_aa, 1)

% We can simulate the response to each of the input signals separately,
% then add the result.

% Simulate step in command signal at t=5
NN = 150;
tvec = (0:(NN-1))*h;
uc = zeros(1,NN);
uc(6:end) = 1;
[yc, tc] = lsim(Hc, uc, tvec);
    
% Simulate step disturbance at t=45
v = zeros(1,NN);
v(46:end) = 1;
[yv, tv] = lsim(Hd, v, tvec);
    
   
figure(1)
clf
stairs(tvec, yc+yv, 'color', [0.1, 0.1, 0.8], 'linewidth', 2)
hold on
stairs(tvec, uc, 'k:', 'linewidth', 2)
xlabel('sample')
ylabel('y')

