% Problem 1 final exam MR2007 HT2016
G = tf([1], [1, 0, 0]);
%H = tf([1, 1], 2*[1, -2, 1], 1);






H = c2d(G, 1, 'zoh');

Fff = tf(2*[1, 0], [1, 1], 1);

Ffb0 = tf(2*[2, -1], [1, 1], 1);
Ffb1 = tf(2*[2, -1], [2, 1], 1);
Ffb2 = tf(2*[2, -1], [4, -1], 1);
Ffb3 = tf(2*[2, -1], [1, 0.1,0.8], 1);

systems = {Ffb1, Ffb0, Ffb2, Ffb3}

  
for i = 1:length(systems)
    sys = systems{i};
    figure(i)
    clf
    step(sys, 20)
    %xlim(k_limes(i,2:3))
    %ylim(k_limes(i,4:5))
    h = findobj(gcf, 'type', 'line')
    set(h, 'linewidth', 2)
    fname = sprintf('step-plot-%d', i)
    print(fname, '-dpdf')
end

% System from command signal to input signal
Hcu = Fff*feedback(1, H*Ffb0);
% System from command signal to output signal
Hc = Fff*feedback(H, Ffb0);

[u, tt] = step(Hcu, 20);
tc = linspace(0,20,20000);
uc = interp1(tt, u, tc, 'previous');

figure(6)
plot(tc, uc)

[yc] = lsim(G, uc, tc);
[yd, td] = step(Hc, 20);

figure(5)
clf
set(gcf, 'position', [100,100, 800, 300])
plot(tc, yc);
hold on
plot(td, yd, 'ro');
h = findobj(gcf, 'type', 'line')
set(h, 'linewidth', 2)
    
legend('Continuous output y(t)', 'Discrete output y(k)', 'Location', 'best')

print -dpdf p1_closed_loop_step.pdf
