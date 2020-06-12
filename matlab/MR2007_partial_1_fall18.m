% MR2004 partial exam 1 fall 18

% Plant
G = tf([1], [1, 1, 0])

% Controller
F = tf([1, 2], [1, 6,0])

figure(1)
clf
rlocus(G*F)

% Closed loop system from reference to error

Hc = feedback(1, 0.4*H*F);

figure(2)
yimp = impulse(Hc);

% Some input signals
u = zeros(28, 5);
u(4, 1) = 1;
u(14, 1) = 0.3;
u(4, 2) = 1;
u(14, 2) = -0.3;
u(1, 3) = 1;
u(10, 3) = 0.3;
u(3:end, 4) = 1;
u(1, 5) = 1;

y = zeros(size(u));
for i = 1:size(u,2)
    u_ = u(:,i);
    y(:,i) = lsim(Hc, u_);
    figure(i+3)
    plot(y(:,i))
end

dlmwrite('inputs.dat', cat(2, (0:27)', u), 'delimiter', ',');
dlmwrite('responses.dat', cat(2, (0:27)', y), 'delimiter', ',');


