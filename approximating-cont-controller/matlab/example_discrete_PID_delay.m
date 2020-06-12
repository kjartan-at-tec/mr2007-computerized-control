%% Analyze discrete case
%h = hmax
if 0
FD = tf(Td*[1 -1], [h+Td/N, -Td/N], h)
FI = tf([h/Ti],[1 -1], h)

Fdiscrete = Kp*(1 + FD + FI)

figure(6)
clf
bode(Fdiscrete)

Fd19 = evalfr(Fdiscrete, exp(i*wc*h));
F19 = evalfr(F, i*wc);
% Phase of discrete PID filter at cross-over frequency
sprintf('Phase of discrete PID at cross-over: %f', phase(Fd19))
sprintf('Phase of continuous PID at cross-over: %f', phase(F19))

sprintf('Should correspond to delay of h=%f', 2*(phase(F19)-phase(Fd19))/wc) 
end

