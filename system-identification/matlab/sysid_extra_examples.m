%% A few more sysid examples

% First order example, three sampling periods delay
h = 1;
a = -0.9;
b = 0.8;
d = 2;
Gd = tf([1, b], [1, a], h, 'IODelay', d)

He = tf([1, 0], [1,a], h)

% Generate identification data
sigma = 0.02;
N = 100;
uu = 2*( -0.5 + randi([0,1], 1, N) );
u = cat(1, uu, uu);
u = u(:);
e = sigma*randn(size(u));

y = lsim(Gd, u) + lsim(He, e);


figure(1)
clf
subplot(211)
stairs(u)
hold on
stairs(e)
subplot(212)
stairs(y)

% Generate validation sequence
uu = 2*( -0.5 + randi([0,1], 1, N) );
uv = cat(1, uu, uu);
uv = uv(:);
ev = sigma*randn(size(uv));

yv = lsim(Gd, uv) + lsim(He, ev);


save sysid_data_10april2018.mat u y uv yv
