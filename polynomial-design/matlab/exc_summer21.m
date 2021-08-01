%% Exercises RST

z = tf('z', 1);
H = 0.02*(z+1)/(z^2 - 2.04*z + 1)
Fb = (5.5*z - 4)/(z-0.3);

Ss = feedback(1, H*Fb);
Tt = feedback(H*Fb, 1);
abs(pole(Ss))

figure(1)
clf
bode(Ss, Tt)

figure(2)
step(Ss)

