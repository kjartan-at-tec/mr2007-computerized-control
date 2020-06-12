% The plant model with delay of 0.1s
Td = 0.1;
s = tf('s');
G1 = 2/s;
G2 = 4/(s+2);
G = G1*G2

% Set D and I gain to zero and try different values of the proportional 
% gain of the controller
Ki = 0;
Kd = 0;
Kp = 2.58  ; %Ku = 2.58 
F = Kp + s*Kd + Ki/s;

% The loop gain and closed loop system
Go = G*F;
Gc = feedback(Go,exp(-Td*s)); % Note the delay

% Step response
t = linspace(0,10,10000);
figure(1)
clf
[y,t] =  step(Gc, t);
plot(t,y)
[pks, locs] = findpeaks(y,t)
Tu = locs(3:end) - locs(2:end-1)
hold on
findpeaks(y,t)
%arrow([locs(3); pks(3)], [locs(4); pks(4)])
%arrow([locs(4); pks(4)], [locs(3); pks(3)])
text(0.6*locs(3)+0.4*locs(4), pks(3) + 0.1, 'T_u = 1.45', 'fontsize', 14)
title('Step-response, ultimate-gain test')
xlabel('Time [s]')
print -dpdf ultimate_period.pdf

Ku = 2.58;
Tu = 1.45;
F = 0.6*Ku*(1 + 1/(0.5*Tu*s) + 0.125*Tu*s)
Fsomeovershoot = 0.33*Ku*(1+1/(Tu/2*s) + Tu/3*s)
Fsomeovershoot = 0.2*Ku*(1+1/(Tu/2*s) + Tu/3*s)

Go = G*F;
Gosomeovershoot = G*Fsomeovershoot;

Gc = feedback(Go,exp(-Td*s)); % Note the delay

Gcsomeovershoot = feedback(Gosomeovershoot,exp(-Td*s)); % Note the delay

% Check discretization by hand using tustin
z = tf('z',Td) 
Fd_byhand = 0.6*Ku * ( 0.7248 *(z-1)^2 + 2*Td*(z-1)*(z+1) + 1.3793* Td^2*(z+1)^2)/(2*Td*(z-1)*(z+1))

Gd = c2d(G, Td, 'zoh');
Fd = c2d(F, Td, 'tustin')
God = Gd*Fd;
Gcd = feedback(God,tf([1],[1 0], Td)); % Note the delay
Gcd_byhand = feedback(Gd*Fd_byhand,tf([1],[1 0], Td)); % Note the delay

% Step response
figure(3)
clf
step(Gc, Gcd, Gcd_byhand, 10)
print -dpdf tuned_response_c_and_d.pdf

% Step response also half sampling perio
Fd2 = c2d(F, Td/2, 'tustin')
God2 = c2d(G,Td/2, 'zoh')*Fd2;
Gcd2 = feedback(God2,tf([1],[1 0 0], Td/2)); % Note the delay
figure(4)
clf
step(Gc, Gcd, Gcd2, 10)
print -dpdf tuned_response_c_and_d_half_sampling.pdf


% Simulate with simulink
[Gnum, Gden] = tfdata(G);
[Fdnum, Fdden] = tfdata(Fd)

% Step response
figure(4)
clf
step(Gc, Gcsomeovershoot, Gcd, 10)
legend('ZN', 'Some overshoot', 'Discretized ZN')
print -dpdf tuned_response_ht16.pdf
