Gs = tf([2],[1,2,0.02, 0])

nyquist(Gs)

rlocus(Gs)

F = tf([1,2.5, 1.5], [1])
FG = F*Gs

rlocus(FG)

figure()
nyquist(FG)

Gc = feedback(FG,1)
figure()
step(Gc)

h = 0.01
Gd = c2d(Gs, h)
figure(4)
rlocus(Gd)

[z,p,k] = tf2zpk(Gd.num{1}, Gd.den{1})

G2 = tf([1],[1 1 0])
G2d = tf([0.19 0.15], [1 -1.5 0.5], log(2))

H32 = tf([1],[1,-0.6,0.08, 0], 1)
figure()
nyquist(H32)

figure()
bode(H32)

nyquist(G2,G2d)