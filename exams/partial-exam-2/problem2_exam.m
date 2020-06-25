%%Partial 2 2015-10-23

h = 0.2;
G = zpk([2], [-2, 0],-1)
F = tf(3*[1, 2], [1, 8])
s = tf('s');
%SH = (1-exp(-s*h))/s
SH = 1/s - tf([1],[1, 0], 'InputDelay', h);

Go = 1/h*G*F*SH;

Gc = feedback(Go,1);

figure(1)
clf
margin(Go)

[mag,pha,w] = bode(Go)
dlmwrite('bode-exam-dta.dta', [w(:), mag(:), pha(:)])

figure(2)
clf
step(Gc)

%% Complete discrete controller
Gd = c2d(G, h)
Fd = c2d(F, h, 'tustin')

Gd0 = Gd*Fd;
Gdc = feedback(Gd0, 1);

figure(3)
clf
margin(Gd0)

figure(4)
clf
step(Gc, Gdc)

