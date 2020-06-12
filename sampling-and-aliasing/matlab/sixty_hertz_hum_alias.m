%% Testing alias of 60Hz hum when sampled with h=0.1


% "continuous signal"
Tend = 4;
tc = linspace(0,Tend,8000); % 
ph = 2*pi*rand(1); % Random phase shift

% Sampling with h=0.1 gives six samples from 0 to 0.5
h = 0.1;
Tend = 4;
N = floor(Tend/h); 
td = (0:N)*h

figure(1)
clf
plot(tc, sin(60*2*pi*tc + ph), td, sin(60*2*pi*td+ph), 'o')


% Sampling with ws = 378 rad/s
ws = 378;
h2 = 2*pi/ws;
N2 = floor(Tend/h2);
td2 = (0:N2)*h2;
hold on
plot(td2, sin(60*2*pi*td2+ph), 'mo')
