%% Root locus for example of control of disk drive arm
omega0 = 1;
b = 1/2*omega0;
a = 2*omega0;

G = tf([1], [1, 0, 0])
Fb = tf([1 b], [1 a])
Go = G*Fb;


h = figure(3)
clf
rlocus(Go)

set(gca, 'Ylim',[-3,3]);
set(gca, 'Xlim', [-3,3]);

hold on
plot(cos(linspace(0,2*pi, 800)), sin(linspace(0,2*pi,800)), 'k:')
plot(linspace(-3,0,10), linspace(3,0,10), 'k:')
plot(linspace(-3,0,10), linspace(-3,0,10), 'k:')

axis equal


%% sin in - sin out example

Gio = tf([1, 0.5], [1, 2, 1, 0.5]);
w = pi/2;

[mag,ph] = bode(Gio, w)

Gsio = 0.5/mag*Gio;

[mag,ph] = bode(Gsio, w)




