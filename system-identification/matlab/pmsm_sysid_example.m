%% System identification of the PMSM

h = 0.01;
% Create prbs sequence
N = 1600;
u_id = idinput(N, 'PRBS', [0 0.3]); % Requires the sysid toolbox
t_id = (0:N-1)'*h;
u_input = [t_id u_id];
 
save pmsm_sysid_input.mat u_input

%% Run the simulation

%% Load results 

simres = load('pmsm_sysid_sim.mat')
u = simres.uy.Data(1:800, 1);
y = simres.uy.Data(1:800, 2);
 
u_val = simres.uy.Data(801:1600, 1);
y_val = simres.uy.Data(801:1600, 2);

h = simres.uy.Time(3)- simres.uy.Time(2)

%% Detrend data
u = detrend(u, 'constant'); % Same as u = u - mean(u)
y = detrend(y, 'constant');
u_val = detrend(u_val, 'constant');
y_val = detrend(y_val, 'constant');

%% Estimate models

% Second order model with two poles one zero
% y(k+1) = -a1*y(k) - a2*y(k-1) + b0*u(k) + b1*u(k-1) + e(k+1)
NN = length(y);
yy = y(3:end);
Phi = [-y(2:NN-1) -y(1:NN-2) u(2:NN-1) u(1:NN-2)];

theta = Phi \ yy
a1 = theta(1); a2 = theta(2);
b0 = theta(3); b1 = theta(4);
% Pulse transfer fcn
H2p1c = tf([b0,b1], [1, a1, a2],h) 

% Autocorrelation of prediction error for validation data
yy_val = y_val(3:end);
Phi_val = cat(2, -y_val(2:NN-1), -y_val(1:NN-2), ...
    u_val(2:NN-1), u_val(1:NN-2));

eps2p1c = yy_val - Phi_val*theta;
acf2p1c = covf(eps2p1c, 40);
figure(6)
clf
subplot(211)
title('Two poles, one zero')
stem(acf2p1c/acf2p1c(1))

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


% Third order model with three poles one zero
% y(k+1) = -a1*y(k) -a2*y(k-1) -a3*y(k-2)
%           +b0*u(k-1) + b1*u(k-2) + e(k+1)
NN = length(y);
yy3 = y(4:end);
Phi3 = cat(2, -y(3:NN-1), -y(2:NN-2), -y(1:NN-3),...
    u(2:NN-2), u(1:NN-3));

theta3 = Phi3 \ yy3
a1 = theta3(1); a2 = theta3(2); a3 = theta3(3);
b0 = theta3(4); b1 = theta3(5);
% Pulse transfer fcn
H3p1c1d = tf([b0,b1], [1, a1, a2],h) 
 
% Autocorrelation of prediction error for validation data
yy3_val = y_val(4:end);
Phi3_val = cat(2, -y_val(3:NN-1), -y_val(2:NN-2), ...
    -y_val(1:NN-3), u_val(2:NN-2), u_val(1:NN-3));

eps3p1c = yy3_val - Phi3_val*theta3;
acf3p1c = covf(eps3p1c, 40);
figure(7)
clf
subplot(211)
title('Three poles, one zero')
stem(acf3p1c/acf3p1c(1))

k = 10; % Using 10-step ahead predictor for validation
[ykpred, tk] = predictlti([b0, b1], [1, a1, a2,a3], ...
    u_val, y_val, k, 0);
resval = y_val(k+1:end) - ykpred;
rms = sqrt(mean(resval.^2));
fit = 100* (1 - norm(resval) / norm(y_val - mean(y_val)));
figure(7)
subplot(212)
stairs(y_val, 'linewidth', 1)
hold on
plot(tk, ykpred, 'ro')
title(sprintf('RMS= %f,  FIT= %f', [rms, fit]));

% Model with two poles two zeros, one delay
% y(k+1) = -a1*y(k) -a2*y(k-1)
%           +b0*u(k) + b1*u(k-1) + b2 u(k-2) + e(k+1)
NN = length(y);
yy22 = y(4:end);
Phi22 = cat(2, -y(3:NN-1), -y(2:NN-2), ...
    u(3:NN-1), u(2:NN-2), u(1:NN-3));

theta22 = Phi22 \ yy22
a1 = theta22(1); a2 = theta22(2); b0 = theta22(3);
b1 = theta22(4); b2 = theta22(5);
% Pulse transfer fcn
H2p2c1d = tf([b0,b1, b2], [1, a1, a2, 0],h) 
[num, den] = tfdata(H2p2c1d);
[z,p,k] = tf2zpk(num{1}, den{1})

% Autocorrelation of prediction error for validation data
yy22_val = y_val(4:end);
Phi22_val = cat(2, -y_val(3:NN-1), -y_val(2:NN-2), ...
    u_val(3:NN-1), u_val(2:NN-2), u_val(1:NN-3));

eps22 = yy22_val - Phi22_val*theta22;
acf22 = covf(eps22, 40);
figure(8)
clf
subplot(211)
title('Three poles, one zero')
stem(acf22/acf22(1))

k = 10; % Using 10-step ahead predictor for validation
[ykpred, tk] = predictlti([b0, b1, b2], [1, a1, a2], ...
    u_val, y_val, k, 1);
resval = y_val(k+2:end) - ykpred(2:end);
rms = sqrt(mean(resval.^2));
fit = 100* (1 - norm(resval) / norm(y_val - mean(y_val)));
figure(8)
subplot(212)
stairs(y_val, 'linewidth', 1)
hold on
plot(tk(2:end), ykpred(2:end), 'ro')
title(sprintf('RMS= %f,  FIT= %f', [rms, fit]));


