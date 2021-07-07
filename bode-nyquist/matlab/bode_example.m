%% Bode example

s = tf('s');

Go = (s+0.5)/(s*s*(s+1))

figure(1)
clf
rlocus(Go)

Gc = feedback(15*Go, 1);

figure(2)
bode(Gc)

ww = logspace(-1, log10(20), 40)';
[mag, ph] = bode(Gc, ww);

ph = ph(:);
mag = mag(:);
mag(1:10)


dlmwrite('bode-example.dta', cat(2, ww, mag, ph))

