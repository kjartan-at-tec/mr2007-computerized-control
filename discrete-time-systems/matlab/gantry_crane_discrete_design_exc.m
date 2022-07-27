%% Gantry crane design discrete time
h = 0.7;
z = tf('z', h);
H = 0.1747*(z+1) / (z^2 - 1.65*z + 1)
F = (z^2 - 1.6*z + 0.68)/(z^2 - 0.5*z - 0.5)

figure(8)
clf
rlocus(H*F)
