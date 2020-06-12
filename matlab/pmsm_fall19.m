%% PMSM AC motor
% Kjartan Halvorsen
% 2019-10-24

% Model: Kt/(Js + f) = b/(s + a)
% Kt = 3n_p\phi_v/2
np = 4;
phiv = 0.1167;
Kt = 3/2*np*phiv;
f = 7.43e-5;
J = 1.74e-4;
a = f/J
b = Kt/J
k = 1/J

s = tf('s');
G = b/(s+a)

% Sampling time
h = 1e-2;

H = c2d((1/(s+a)), h, 'zoh')
[Hnum,Hden] = tfdata(H);
bd = Hnum{1}*b
kd = Hnum{1}/J


%% Create some step-responses
Hs = {H, tf([10], [1, -0.7], h),...
    tf([1], [1, -0.996], h), ...
    tf([0.25], real(conv([1,-0.95+0.05*1j],[1,-0.95-0.05*1j])), h)};

t = h*(0:100)';
y = zeros(length(t), length(Hs));
figure(1)
clf
for i=1:length(Hs)
    HH = Hs{i};
    [yy, ] = step(HH,  t);
    y(:,i) = yy;
    subplot(2,2,i)
    stairs(t,yy)
end
dlmwrite('pmsm-step-partial2-fall19.dta', cat(2, t(:), y, zeros(size(t))), 'delimiter', ','); 


% Check desired system
ac = 0.6;
Hc = tf([1-ac], [1, -ac], h);
% Step response will be y = 1 - ac^(k-1)
figure(2)
clf
step(Hc)
hold on
td = 0:20;
stairs(td*h, 1 - ac.^(td), 'color', [0.6, 0.6, 0])

% So rise time is found by 
% 1-ac^t1 = 0.1 <=> 1 - (e^ln(ac))^t1 = 0.1  <=> 1-e^(t1*ln(ac)) = 0.1
%  =>  t1*ln(ac) = ln(0.9)  => t1 = ln(0.9)/ln(ac)
% 1-ac^t2 = 0.9  => t2 = ln(0.1)/ln(ac)
t1 = log(0.9)/log(ac)
t2 = log(0.1)/log(ac)
tr = t2-t1   % Want tr=10h
% (log(0.1)-log(0.9))/log(ac) = 10 % rise time is 10 times h
% => log(ac) = (log(0.1) - log(0.9)) / (10)
% => ac = e^((log(0.1) - log(0.9)) / (10))
ac = exp((log(0.1)-log(0.9))/(10))
stepinfo(tf([1-ac], [1, -ac],1)) % Time unit h


%% Find 2dof controller
% Plant model
B = bd;
A = Hden{1}

[sol, t0, LHS, RHS] = RST_sym(B, A, 1, 1);

% Substitute numerical values

p1_n = 0.8;
p2_n = 0.8;
obspole = 0.5;
po1_n = obspole;
po2_n = obspole;
Ao_n = conv([1, -po1_n], [1, -po2_n]);

syms p1 p2 po1 po2
vars = [p1, p2, po1, po2];
numvals = [p1_n, p2_n, po1_n, po2_n];
r1_n = double( subs(sol.r1, vars, numvals) )
s0_n = double( subs(sol.s0, vars, numvals) )
s1_n = double( subs(sol.s1, vars, numvals) )
s2_n = double( subs(sol.s2, vars, numvals) )

t0_n = double( subs(t0, vars, numvals) )

LHS = subs(LHS, vars, numvals) 
RHS = subs(RHS, vars, numvals) 

R = conv([1, -1], [1, r1_n]);
S = [s0_n, s1_n, s2_n];
T = Ao_n * t0_n;

F_fb = tf(S, R, h);
F_ff = tf(T, R, h);

Haa = tf([1],[1,0], h);
% Closed-loop system from command signal to output
Hc = F_ff * feedback(H, F_fb*Haa)

% Closed-loop system from disturbance signal to output
Hvc = feedback(1, H*F_fb*Haa);

figure(4)
%clf
step(Hc, Hvc)
set(findobj(gcf,'Type', 'line'), 'linewidth', 2)
hold on


%% Alias of 60Hz
fs = 1/h;
fN = fs/2;
f1 = 60;
fa = abs( mod(f1 + fN, fs) -fN)






