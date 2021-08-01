%% Sysid for gantry crane

% Kjartan Halvorsen
% 2021-07-11

clear all
close all

h = 0.2;
F0=0.8e3;
uu = F0*idinput(1000, 'prbs',  [0, 0.25]);
uu1 = uu(1:500); uu2 = uu(501:end);
uu1 = cat(1, uu1, flipud(uu1));
uu2 = cat(1, uu2, flipud(uu2));
tt = (0:999)'*h;
simin1 = cat(2, tt, uu1);
simin2 = cat(2, tt, uu2);


% Run simulation crane_sysid_KH

% Simulation output
sdata = iddata(out.simout.Data(:,2), out.simout.Data(:,1), h);
vdata = iddata(out.simout2.Data(:,2), out.simout2.Data(:,1), h);

% Estimate 6th order model
arx561 = arx(sdata, [6, 5, 1])

[num, den] = tfdata(arx561);
A = den{1};
B = num{1};

save crane-sysid-results.mat arx561 A B sdata vdata

