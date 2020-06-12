%% System identification of DC motor model fall 18
% Kjartan Halvorsen

s = tf('s');
T = 1;
k = 2;
G = k/(s*(s*T+1));

h = 0.3;

Gd = c2d(G, h);
[num, den] = tfdata(Gd)
disp('True model')
Gd

He = tf([1, 0, 0], den{1}, h)


% Generate identification data
sigma = 0.02;
N = 400;
uu = 2*( -0.5 + randi([0,1], 1, N) );
u = cat(1, uu, uu);
u = u(:);
e = sigma*randn(size(u));

y = lsim(Gd, u) + lsim(He, e);
yn = y + sigma*randn(size(y));

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
yvn = yv + sigma*randn(size(yv));

figure(2)
clf
subplot(211)
stairs(uv)
hold on
stairs(ev)
subplot(212)
stairs(yv)




%% Generate antithetic input sequence

Np = 30; % Number of pulses
uai = [];
for i=1:Np
    % Draw the pulse width
    pw = randi([1,4])
    
    % Do first a positive pulse, then a negative pulse of same length
    uai = cat(1, uai, ones(pw,1), -ones(pw,1));
end
 
eai = 0*sigma*randn(size(uai));

yai = lsim(Gd, uai) + lsim(He, eai);
Hd = tf([1, -1], [1, 0], h);
ydai = lsim(Hd, yai);

figure(2)
clf
subplot(211)
stairs(uai)
hold on
stairs(eai)
subplot(212)
stairs(yai)
hold on
stairs(ydai)


%% Prediction filter
Hpred = tf([1+h, -h], [1, 0, 0], h)

ypred = lsim(Hpred, yai);

figure(3)
stairs(yai)
hold on
stairs(ypred)

