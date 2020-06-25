%% MR2007 partial exam 1 Fall 2019
% PID control of DC-motor

s = tf('s');

% plant model
T =  1;
G = 1/(s*(s+1));
h = 0.2;
h = 2;
H = c2d(G, h, 'zoh')

% controller
Ti = 2;
Td = 0.5;
K = 1;
N = 10;
% From table 8.1 Åström & Wittenmark
ad = Td/(N*h+Td);
bd = N*Td;
bi = h/Ti;
s0 = K*(1+bd);
s1 = -K*(1 + ad + 2*bd - bi);
s2 = K*(ad + bd - bi*ad);
F = tf([s0, s1, s2], [1, -(1+ad), ad], h);

figure(1)
clf
rlocus(F*H)
set(findobj(gca, 'type', 'line'), 'linewidth', 2)
hold on

%% Generate cases
% Gains
K_params = [0.5, 1,2, 6];


t = 0:h:20;
N = length(t),
u = ones(N,1);

y = zeros(N, length(K_params));

cm = [250,159,181
247,104,161
221,52,151
174,1,126
122,1,119];

for i =1:length(K_params)
 
    G0 = K_params(i)*F*H;
    %Gc = feedback(H, K_params(i)*F); % From disturbance to output
    Gc = feedback(H*K_params(i)*F,1); % From reference signal
    
    [num, den] = tfdata(Gc);
    zer = roots(num{1});
    poles = roots(den{1});

    % Plot the poles as  crosses in the root locus
    col = cm(i+1, :)/255;
    figure(1)
    plot(real(poles), imag(poles), ...
        'x', 'color', col, 'markersize', 14,...
        'linewidth', 2)

    y(:,i) = lsim(Gc, u, t);

    po = sort(poles, 'descend', 'ComparisonMethod', 'real')
    ze = sort(zer, 'descend', 'ComparisonMethod', 'real')
    
    dlmwrite(sprintf('dc-motor-pid-zeros-case%d.txt', i), cat(2, real(ze), imag(ze)), 'delimiter', '\t');
    dlmwrite(sprintf('dc-motor-pid-poles-case%d.txt', i), cat(2, real(po), imag(po)), 'delimiter', '\t');

    figure(i+1)
    clf
    subplot(122)
    %plot(t,u, '--');
    %hold on
    stairs(t, y(:,i))

    subplot(121)
    zplane(num{1},den{1})
    ylim([-7,7])
    xlim([-7,7])
    

end

dlmwrite('dc-motor-pid-timeseries.dat', cat(2, t', y), 'delimiter', ',');






