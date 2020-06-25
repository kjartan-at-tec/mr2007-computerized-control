Hc = tf(0.3, [1, -0.7, 0], -1)

figure(1)
clf
step(Hc, 0:20)
xlabel('Time [in h]')

% With observer pole in 0.5
num = [ 1.   -1.2   0.32 ]
den = [ 1.   -1.2   0.35 ]

% With deadbeat observer
num = [ 1.   -0.7  -0.08  0.  ]
den = [ 1.  -0.7  0.   0. ]

Hd = tf(num, den, -1)

figure(2)
clf
step(Hd, 0:20)