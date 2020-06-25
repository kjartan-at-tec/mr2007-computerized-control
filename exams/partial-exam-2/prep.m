G = zpk([2],[0, -2], -1)
Fzn = tf(1.2*[pi*pi/8, pi, 2], [pi, 0])
F = tf([1, 2], [1/3, 2/3+2])

G0zn = G*Fzn
G0 = G*F

figure(1)
clf
margin(G0)

figure(2)
clf
margin(G0zn)

figure(3)
clf
bode(tf('s')*G)
