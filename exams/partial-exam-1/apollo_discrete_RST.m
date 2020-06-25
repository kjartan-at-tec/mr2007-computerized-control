% Simulation of RST design
% MR2007 partial exam 1
% Kjartan Halvorsen

close all
clear all

% Plant model
h = 1;
B = 1/6*[1, 4, 1];
aint = [1, -1];
A = conv(aint, conv(aint, aint));

H = tf(B, A, h) % Discrete-time transfer function

% Desired closed-loop poles. All in the same location
ac = [1, -0.8];
Ac = conv(conv(ac, ac), ac)

% Observer polynomial
ao = [1, -0.] % Note the observer pole
Ao = conv(ao,ao) % (z-a)^2

% RHS of the Diophantine equation
Acl = conv(Ac, Ao)

% Controller design
% Make use of the symbolic toolbox for matlab
syms z r1 r2 s0 s1 s2
Rs = z^2 + r1*z + r2
Ss = s0*z^2 + s1*z + s2;
As = z^3*A(1) + z^2*A(2) + z*A(3) + A(4);
Bs = z^2*B(1) + z*B(2) + B(3)

% LHS of the Diophantine equation
LHS = As*Rs + Bs*Ss
LHScoeffs = fliplr(coeffs(LHS, z)) % Must flip, since coeffs() returns the coefficient in the lowest term first.

% The equations
eqs = LHScoeffs(2:end) - Acl(2:end)
[AA, bb] = equationsToMatrix(eqs, [r1, r2, s0, s1, s2]);
RSparams = linsolve(AA,bb)
params = double(RSparams);

R = [1; params(1:2)]'
S = params(3:end)'

t_0 = sum(Ac)/sum(B) % t0 = Ac(1) / B(1) 
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
tvec = 0:(NN-1);
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



figure(2)
clf
step(feedback(F_fb*H, 1))


figure(3)
clf
set(gcf, 'Position', [100,100,700,700])
rlocus(F_fb*H)
xlim([-1.4,1.4])
ylim([-1.1,1.2])
axis equal
set(findobj(gcf, 'Type', 'Line'), 'Linewidth', 2)
print -dpdf apollo_rst_rlocus.pdf


%% Generate some step responses
Tlim = 80;
k_limes=[0.08 0 Tlim -3 3
    0.3  0 Tlim -3 3
    1  0 Tlim -3 3;
    2.5  0 Tlim -3 3
    3  0 Tlim -3 3];
    
for i = 1:size(k_limes, 1)
%for i = 2:3
    %Gc = F_ff*feedback(H, k_limes(i,1)*F_fb);
    Gc = feedback(k_limes(i,1)*F_fb*H,1);
    %t0 = 1/evalfr(Gc, 1)
    t0 = 1;
    figure(i+10)
    clf
    step(t0*Gc)
    xlim(k_limes(i,2:3))
    ylim(k_limes(i,4:5))
    h = findobj(gcf, 'type', 'line');
    set(h, 'linewidth', 2)
    fname = sprintf('apollo-step-plot-%d', i)
    print(fname, '-dpdf')
    
    %figure(i+20)
    %clf
    %pzmap(Gc)
    
end


figure(6)
clf
margin(F_fb*H)


