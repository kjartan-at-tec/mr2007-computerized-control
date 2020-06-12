%% Final exam - dummy
% 2nd order system, friktionless cart on wheels with spring attached to
% wall. External driving force Fu = ku acting on the cart

w = 1; % sqrt(k/m)
h = 0.4/w; % Sampling period, wh = 0.1 

% Sampled system
F = [cos(w*h), 1/w*sin(w*h); -w*sin(w*h), cos(w*h)]
G = [(1-cos(w*h)); w * sin(w*h)]
C = [1, 0];
D = [];
Hss = ss(F,G,C,D, h);

[Bd,Ad] = tfdata(Hss)

Hd = tf(Hss);

% PD-regulator
Nd = 20;
Kpd = 1;
Td = 1;
s = tf('s');
Fpd = c2d(Kpd*(1 + Td*s/(1 + Td*s/Nd)), h, 'tustin')


Ho = Fpd*Hd;
Gcpd = feedback(Ho, 1);

figure(1)
clf
margin(Ho)
[mag,ph, w] = bode(Ho);
[Hmag, Hph] = bode(Hd, w);
[Fmag,Fph] = bode(Fpd, w);

dlmwrite('final-bode-open.dat', [w(:), mag(:), Hph(:)+Fph(:)], 'delimiter', ',')


figure(2)
clf
nyquist(Ho)

figure(3)
step(Gcpd)

figure(4)
bode(Gcpd)

figure(5)
clf
bode(Hd, Fpd)


%% Problem 4 RST design

% Desired closed-loop poles
pc = -2+2*i;

pd = exp(pc*h)

pd1 = 0.3+0.3*i
pd2 = 0.3-0.3*i
pd1+pd2
pd1*pd2

AA = [-0.079, 0, -1; 0.079, 0.079, -1.84; 0, 0.079, 1]
b = [0.6-1.84; 0.18-1; 0]
s0s1r1= AA\b
r1 = s0s1r1(3);
SR = tf(s0s1r1(1:2)',[1, r1], h)
t0 = (1-0.6+0.18)/(2*0.079)
Ac = [1, -0.6, 0.18]
sum(Ac)/sum(Bd{1})


TR = t0*tf([1, 0], [1, r1],h)

Hrst = TR*feedback(Hd, SR)

figure(6)
clf
step(Hrst)

figure(7)
clf
pzmap(Hrst)


%% Problem 5 state feedback

Asf = [0.079, 0.39; -0.92*0.079+0.39^2, -0.92*0.39-0.39*0.079];
bsf = [-0.6+1.84; 0.18-0.92^2-0.39^2];

L = Asf\bsf

eig(F - G*L')


% Explicit Asf
w=1;
Asfe = [1-cos(w*h), w*sin(w*h); 1-cos(w*h), -w*sin(w*h)]
Asf
bsfe = [-0.6+2*cos(w*h); 0.18-1]
bsf
Le = Asfe\bsfe
L








    