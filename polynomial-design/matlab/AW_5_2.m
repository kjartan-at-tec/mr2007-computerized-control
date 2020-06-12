% MR2007 Exc 5.2
close all
clear all

a = 0.9;
beta = 0.2;
H = tf([beta], [1, -a], 1)

[sol, t0] = RST_sym([beta], [1, -a], 1)

alpha = 0.8;
p1_n = alpha;
p2_n = alpha;
po_n = 0;

syms p1 p2 po1
vars = [p1 p2 po1];
vals = [p1_n p2_n po_n];

r1 = double(subs(sol.r1, vars, vals))
s0 = double(subs(sol.s0, vars, vals))
s1 = double(subs(sol.s1, vars, vals))

t0_n = double(subs(t0, vars, vals))

Fb = tf([s0, s1], [1, r1], 1)
Ff = tf(t0_n*[1, 0], [1, r1], 1)
delay = tf([1], [1, 0], 1);

Hc = Ff * feedback(H, Fb*delay)
Hd = feedback(1, H*Fb*delay)

figure(1)
step(Hc, Hd)
