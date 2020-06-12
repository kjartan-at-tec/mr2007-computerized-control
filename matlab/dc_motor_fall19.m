s = tf('s');
T = 1;
h = 0.2;
h = 2;

G = 1/(s*(s*T+1));
H = c2d(G, h);

b0 = T*(exp(-h/T) - 1 + h/T)
b1 = T*(1-exp(-h/T)*(1+h/T))
figure(1)
clf
pzmap(H)
figure(2)
clf
rlocus(H)