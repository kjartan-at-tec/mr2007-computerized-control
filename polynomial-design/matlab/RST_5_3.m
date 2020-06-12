% Åström & Wittenmark 5.3
set(0,'defaultlinelinewidth',2)

% Plant model
B = [1, 0.7];
A = [1, -1.8, 0.81];
H = tf(B, A, 1)

% Check behaviour
figure(1)
clf
subplot(121)
pzmap(H)
subplot(122)
step(H)


% Desired characteristic polynomial
Ac = [1, -1.5, 0.7];

% Controller (a)
r0 = 1;
R_a = [1, 0.7]*r0;
S_a = [0.3, -0.11];
T_a = 0.2*[1, 0];

F_fb_a = tf(S_a, R_a, 1);
F_ff_a = tf(T_a, R_a, 1);

% Closed-loop system from command signal to output
Hc_a = F_ff_a * feedback(H, F_fb_a)

% Closed-loop system from command signal to control signal
Huc_a = F_ff_a * feedback(1, H*F_fb_a);

% Closed-loop system from disturbance signal to output
Hvc_a = feedback(1, H*F_fb_a);


%% Controller (b), no cancellation of the zero
Ao = [1, 0]; % Observer polynomial
params = [1,     1,    0
          -1.8,  0.7,  1
          0.81,  0,   0.7] \ [-1.5+1.8; 0.7-0.81; 0]
      
R_b = [1, params(1)];
S_b = [params(2), params(3)];
t_0 = sum(Ac)/sum(B)
T_b = Ao * t_0;

F_fb_b = tf(S_b, R_b, 1);
F_ff_b = tf(T_b, R_b, 1);

% Closed-loop system from command signal to output
Hc_b = F_ff_b * feedback(H, F_fb_b)

% Closed-loop system from command signal to control signal
Huc_b = F_ff_b * feedback(1, H*F_fb_b);

% Closed-loop system from disturbance signal to output
Hvc_b = feedback(1, H*F_fb_b);

%% Controller (c), incremental control

params = [1, 1, 0, 0
    -2.8, 0.7, 1, 0
    2.61, 0, 0.7, 1
    -0.81, 0, 0, 0.7] \ [-1.5+2.8; 0.7-2.61; 0+0.81; 0];

% Also with symbolic computation
[sol, t0, LHS, RHS] = RST_sym(B, A, 0, 1);

% Substitute nume   rical values

p1_n = 0.75+1j*0.3708;
p2_n = 0.75-1j*0.3708;
obspole = 0;
po1_n = obspole;
po2_n = obspole;
Ao_n = conv([1, -po1_n], [1, -po2_n]);

syms p1 p2 po1 po2
vars = [p1, p2, po1, po2];
numvals = [p1_n, p2_n, po1_n, po2_n];
r1_n = double( subs(sol.r1, vars, numvals) );
s0_n = double( subs(sol.s0, vars, numvals) );
s1_n = double( subs(sol.s1, vars, numvals) );
s2_n = double( subs(sol.s2, vars, numvals) );

t0_n = double( subs(t0, vars, numvals) );

LHS = subs(LHS, vars, numvals) 
RHS = subs(RHS, vars, numvals) 

R_c = conv([1, -1], [1, r1_n]);
S_c = [s0_n, s1_n, s2_n];
Ao_c = [1, 0, 0];
T_c = Ao_c * t0_n;

F_fb_c = tf(S_c, R_c, 1);
F_ff_c = tf(T_c, R_c, 1);

% Closed-loop system from command signal to output
Hc_c = F_ff_c * feedback(H, F_fb_c)

% Closed-loop system from command signal to control signal
Huc_c = F_ff_c * feedback(1, H*F_fb_c);

% Closed-loop system from disturbance signal to output
Hvc_c = feedback(1, H*F_fb_c);

%% Plots
p = timeoptions;
p.XLabel.String = 'Time';

set(groot, 'Default', struct())

figure(1)
clf
step(Hc_a, Hc_b, Hc_c, p)
title('Response to step in reference signal')
legend('(a)', '(b)', '(c)')
h = findobj(gca,'Type','line')
set(h, 'linewidth', 2)
xlabel('Time')
%print -dpdf aw5_3_refstep.pdf


figure(2)
clf
set(gcf, 'position', [100,100, 600, 1200])
subplot(311)
step(Huc_a)
title('Step response of control signal, (a)')
h = findobj(gca,'Type','line')
set(h, 'linewidth', 2)

subplot(312)
step(Huc_b)
title('Step response of control signal, (b)')
h = findobj(gca,'Type','line')
set(h, 'linewidth', 2)

subplot(313)
step(Huc_c)
title('Step response of control signal, (c)')
h = findobj(gca,'Type','line')
set(h, 'linewidth', 2)

figure(5)
clf
step(Huc_a, Huc_b, Huc_c)
title('Response of control signal to step disturbance')
h = findobj(gca,'Type','line')
set(h, 'linewidth', 2)
legend('(a)', '(b)', '(c)')

figure(3)
clf
h=stepplot(Hvc_a, Hvc_b, Hvc_c, p)
title('Response to step in disturbance signal')
legend('(a)', '(b)', '(c)')
h = findobj(gca,'Type','line')
set(h, 'linewidth', 2)
%print -dpdf aw5_3_diststep.pdf

figure(4)
clf
co_orig = get(groot, 'defaultAxesColorOrder');
co = [0 0 1;
      0 0.5 0;
      1 0 0;
      0 0.75 0.75;
      0.75 0 0.75;
      0.75 0.75 0;
      0.25 0.25 0.25];
set(groot,'defaultAxesColorOrder',co)
bode(Hc_a, Hc_b)
legend('With cancellation of the zero', 'Without cancellation',...
        'Location', 'best')
h = findobj(gcf,'Type','line')
set(h, 'linewidth', 2)
print -dpdf aw5_3_bode.pdf
set(groot,'defaultAxesColorOrder',co_orig)


% figure(2)
% clf
% [ua,ta] = step(Huc_a);
% [ub,tb] = step(Huc_b);
% stairs(ta, ua-ub)
% h = findobj(gca,'Type','line')
% set(h, 'linewidth', 2)


% Extra: choose T to cancel the plant zero using controller of (b)
% t0 = sum(Ac); % t0 = Ac(1)
% T = t0*tf(Ao, B, 1);
% F_ff_c = T*tf(1, R_b, 1);
% 
% % Closed-loop system from command signal to output
% Hc_c = F_ff_c * feedback(H, F_fb_b)
% 
% % Closed-loop system from command signal to control signal
% Huc_c = F_ff_c * feedback(1, H*F_fb_b);
% 
% figure(3)
% clf
% step(Hc_a, Hc_b, Hc_c)
% title('Step response of output')
% legend('(a)', '(b)', '(c)')
% h = findobj(gca,'Type','line')
% set(h, 'linewidth', 2)
% 
% figure(4)
% set(gcf, 'position', [200,200, 600, 900])
% subplot(311)
% step(Huc_a)
% title('Step response of control signal, (a)')
% h = findobj(gca,'Type','line')
% set(h, 'linewidth', 2)
% subplot(312)
% step(Huc_b)
% title('Step response of control signal, (b)')
% h = findobj(gca,'Type','line')
% set(h, 'linewidth', 2)
% subplot(313)
% step(Huc_c)
% title('Step response of control signal, (c)')
% h = findobj(gca,'Type','line')
% set(h, 'linewidth', 2)
