%% Set values for pole-placement example
a = 4;      % Observer pole
h = 0.14; % Sampling time in sec
aa = exp(-a*h); % Discrete time observer pole
ws = 2*pi/h; % Sampling frequency rad/s
wN = ws/2; % Nyquist frequency rad/s
%% Discretize the controller


Ffb = tf([1+3/2*a, 4*a], [1, 3+5/2*a])
Fff = tf(4*[1, a], [1, 3+5/2*a])

Ffbd = c2d(Ffb, h, 'tustin');
Fffd = c2d(Fff, h, 'tustin');

G = tf([-1, 2], [1, 2, 0]);
H = c2d(G, h, 'zoh');

Go_cd = Ffbd*H;

%% Discrete design
wn = 2*sqrt(2);
zeta = cos(pi/4);
[r1, s0, s1, t0, aa] = RST_example(a, h, wn, zeta)
Ffb_dd = tf([s0, s1],[1, r1], h)
Fff_dd = tf(t0*[1, -aa],[1, r1], h)



Go_dd = Ffb_dd*H;


figure(1)
clf
margin(Go_cd)
figure(2)
clf
margin(Go_dd)

%% Effect of anti-aliasing filtering

% Add a delay of 2h
Ha = H * zpk([],[0,0], 1, h)
Goa_dd = Ha*Ffb_dd;

figure(3)
clf
margin(Goa_dd)

% An actual bessel filter
[z,p,k] = besself(4, 1.6);
Hb = zpk(z,p,k);
   
figure(4)
clf
bode(Hb)
bandwidth(Hb)

%% Design of controller with anti-aliasing

[r1,r2,r3,s0,s1,s2,s3,t0,aa] = RST_example_aliasing(a);


