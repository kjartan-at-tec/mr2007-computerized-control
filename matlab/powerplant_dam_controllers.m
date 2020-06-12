%% Controller design for the hydroplant dam example

% Kjartan Halvorsen
% 2018-08-21

s = tf('s');
z = tf('z', 1);
Hzoh = c2d(1/s, 'zoh')
Hzoh = c2d(1/s, 1, 'zoh')
Hfoh = c2d(1/s, 1, 'foh')
figure
bode(Hzoh, Hfoh)
bode(1/s, Hzoh, Hfoh)
legend('Continuous', 'zoh', 'foh')
bode(1/s, Hzoh, Hfoh, exp(-s*h))
legend('Continuous', 'zoh', 'foh', 'delay of h')
bode(1/s, Hzoh, Hfoh, exp(-s)/s)
bode(1/s, Hzoh, Hfoh, exp(-s/2)/s)
legend('Continuous', 'zoh', 'foh', 'cont-time w delay of h/2')
Hc1 = feedback(Hzoh, 0.5);
Hc1 = feedback(Hzoh, 1);
Hc05 = feedback(Hzoh, 0.5);
Hc15 = feedback(Hzoh, 1.5);
figure
step(Hc05, Hc1, Hc15)
figure
K=linspace(0,10, 100);
plot(K, 4*K); hold on; plot(K, K.^2)
figure
rlocus(z/(z-1)^2)
rlocus((z+0.5)/(z-1)^2)
rlocus((z-0.5)/(z-1)^2)
s0=2; s1 = -1;
F = (s0*z + s1)/(z-1);
Hc = feedback(H, F);
Hc = feedback(Hzoh, F);
z
z = tf('z', 1)
Hc = feedback(Hzoh, F);
Hzoh
F = (s0*z + s1)/(z-1);
Hc = feedback(Hzoh, F);
figure
step(Hc)