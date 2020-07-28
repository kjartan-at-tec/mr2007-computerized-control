% MR2007 HW4 Fall 2019
% Generating data set for the students to work 
% on to identitfy the model

% Kjartan Halvorsen
% 2019-10-10

%% Second-order plant and second-order anti-aliasing filter
clear all

s = tf('s');
G = 1 / (s^2 + s + 1);

h = 0.1;
wN = pi/h;
w0 = wN/sqrt(148.48);
Ha = 3/( (s/w0)^2 + 3*(s/w0) + 3);

H = G*Ha;
Hd = c2d(H, h)
[num,den] = tfdata(Hd)


noisestd = 0.01;
sigma = 0.08;
sigma = 5e-4;

Hde = tf([1, 0,0,0,0], den{1}, h)


% Generate identification data
N = 400;
t = (0:(2*N-1))'*h;

uu = 2*( -0.5 + randi([0,1], 1, N) );
u = cat(1, uu, uu);
u1 = u(:);
e1 = sigma*randn(size(u1));     

y1 = lsim(Hd, u1) + lsim(Hde, e1);

% Generate validation sequence
uu = 2*( -0.5 + randi([0,1], 1, N) );
uv = cat(1, uu, uu);
u1_val = uv(:);
ev1 = sigma*randn(size(u1_val));

y1_val = lsim(Hd, u1_val) + lsim(Hde, ev1);

save('sysid_hw_data.mat', ...
    'u1', 'y1', 'u1_val', 'y1_val')

figure(1)
clf
subplot(211)
stairs(u1)
subplot(212)
stairs(y1)

 
%% Estimation with least squares "by hand"

% Model 1 - four poles, three zeros
Phi_1 = [-y1(4:end-1), -y1(3:end-2), -y1(2:end-3), -y1(1:end-4), ...
    u1(4:end-1), u1(3:end-2), u1(2:end-3), u1(1:end-4)];
par_1 = Phi_1 \ y1(5:end);
resids1 = y1(5:end) - Phi_1*par_1;

a1 = [1, par_1(1:4)']
num{1}
b1 = par_1(5:end)'
den{1}

Hhat1 = tf(b1, a1, h);



% Simulate

figure(2)
clf
step(Hd, Hhat1)

figure(3)
clf
pzmap(Hd, Hhat1)

figure(4)
bode(Hd, Hhat1)

figure(5)
covfcn(resids1)

figure(6)
clf

% Validate using k-step ahead predictor
k = 10; % Using 10-step ahead predictor for validation
[ykpred, tk] = predictlti([b0, b1], [1, a1, a2], ...
    u_val, y_val, k, 0);
resval = y_val(k+1:end) - ykpred;
rms = sqrt(mean(resval.^2));
fit = 100* (1 - norm(resval) / norm(y_val - mean(y_val)));
figure(6)
subplot(212)
stairs(y_val, 'linewidth', 1)
hold on
plot(tk, ykpred, 'ro')
title(sprintf('RMS= %f,  FIT= %f', [rms, fit]));

