%% Notch-filter example
% MR2007 Spring18

omega1 = 1;
Q = 10;
s = tf('s');
h = 0.5/omega1;

F = (s^2 + omega1^2)/(s^2 + omega1/Q*s + omega1^2)


% Discretization with Tustin, no prewarp
Fdt = c2d(F, h, 'tustin')

% Discretization with Tustin, with prewarp
opt = c2dOptions('Method','tustin','PrewarpFrequency', omega1);
Fdtpw = c2d(F, h, opt)

figure(1)
clf
w = logspace(-1, 1, 810);
bode(F, Fdt, Fdtpw, w)
legend('Continuous', 'Tustin', 'Tustin prewarp')

figure(2)
clf
step(F, Fdt, Fdtpw)
legend('Continuous', 'Tustin', 'Tustin prewarp')
