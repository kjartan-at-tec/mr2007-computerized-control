%% System identification example MR2007 Spring 18
% Kjartan Halvorsen

s = tf('s');
omega = 1;
zeta = 0.4;
G = omega^2/(s^2 + 2*zeta*omega*s + omega^2);
h = 0.3;

Gd = c2d(G, h);
[num, den] = tfdata(Gd)
disp('True model')
Gd

He = tf([1, 0, 0], den{1}, h)


% Generate identification data
sigma = 0.02;
N = 400;
uu = 2*( -0.5 + randi([0,1], 1, N) );
u = cat(1, uu, uu);
u = u(:);
e = sigma*randn(size(u));

y = lsim(Gd, u) + lsim(He, e);

figure(1)
clf
subplot(211)
stairs(u)
hold on
stairs(e)
subplot(212)
stairs(y)

% Generate validation sequence
uu = 2*( -0.5 + randi([0,1], 1, N) );
uv = cat(1, uu, uu);
uv = uv(:);
ev = sigma*randn(size(uv));

yv = lsim(Gd, uv) + lsim(He, ev);

figure(2)
clf
subplot(211)
stairs(uv)
hold on
stairs(ev)
subplot(212)
stairs(yv)

%% Estimate first-order model (q + a_1) y(k) = (b_0q + b_1) q^{-1} u(k) + qe(k)
% \hat{y}(k+1) = -a_1y(k) +  b_0u(k) + b_1u(k-1) 
%              = [-y(k) u(k) u(k-1) ] * [a_1; b_0; b_1]
n = 1;
m = 1;
d = 1;

[sys1, resid1, resval1, rms1, fit1] = estimate_arx(u, y, n, m, d, uv, yv, figure(1));

sys1

%% Estimate second-order model (q^2 + a_1q + a_2) y(k) = (b_0q^2 + b_1a + b_2) q^{-d} u(k) + q^2e(k)
% \hat{y}(k+1) = -a_1y(k) - a_2y(k-1) +  b_0u(k+1-d) + b_1u(k-d) + b_2u(k-1-d) 
%              = [-y(k) -y(k-1) u(k+1-d) u(k-d) u(k-1-d) ] * [a_1; a_2; b_0; b_1; b_2]
n = 2;
m = 1;
d = 0;

[sys2, resid2, resval2, rms2, fit2] = estimate_arx(u, y, n, m, d, uv, yv, figure(2));
sys2

%% Estimate second-order model (q^2 + a_1q + a_2) y(k) = (b_0q^1 + b_1) q^{-0} u(k) + q^2e(k)
% \hat{y}(k+1) = -a_1y(k) - a_2y(k-1) +  b_0u(k) + b_1u(k-1) 
%              = [-y(k) -y(k-1) u(k) u(k-1) ] * [a_1; a_2; b_0; b_1]
n = 2;
m = 1;
d = 0;

[sys2, resid2, resval2, rms2, fit2] = estimate_arx(u, y, n, m, d, uv, yv, figure(2));
sys2

%% Estimate second-order model (q^2 + a_1q + a_2) y(k) = (b_0q^2 + b_1q+ b_2) q^{-0} u(k) + q^2e(k)
% \hat{y}(k+1) = -a_1y(k) - a_2y(k-1) +  b_0u(k+1) + b_1u(k) + b_2u(k-1) 
%              = [-y(k) -y(k-1) u(k+1) u(k) u(k-1) ] * [a_1; a_2; b_0; b_1;b_2]
n = 2;
m = 2;
d = 0;

[sys2b, resid2b, resval2b, rms2b, fit2b] = estimate_arx(u, y, n, m, d, uv, yv, figure(3));
sys2b

%% Estimate third-order model (q^3 + a_1q^2 + a_2q + a_3) y(k) = (b_0q^3 + b_1q^2+ b_2q + b_3) q^{-0} u(k) + q^3e(k)
% \hat{y}(k+1) = -a_1y(k) - a_2y(k-1) +  b_0u(k+1) + b_1u(k) + b_2u(k-1) 
%              = [-y(k) -y(k-1) u(k+1) u(k) u(k-1) ] * [a_1; a_2; b_0; b_1;b_2]
n = 3;
m = 3;
d = 0;

[sys3, resid3, resval3, rms3, fit3] = estimate_arx(u, y, n, m, d, uv, yv, figure(4));
sys3

