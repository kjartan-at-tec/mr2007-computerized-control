 s = tf('s');
 h = 0.62; % Use your own last two digits here!
 ws = 2*pi/h;
 
 G_zoh = 1/s * (1 - exp(-h * s) )
 G_approx = h * exp(-h/2*s)    % Your code

 figure(1)
 clf
 bode(G_zoh, G_approx, logspace(-1, log10(10*ws), 500));
 ah = findobj(gcf, 'Type', 'axes');
 hold on
 yl = get(gca, 'YLim');
 plot([ws, ws], yl, 'k--')
 plot([ws/2, ws/2], yl, 'k:')
 legend('Sample-and-hold', 'Approximation', '\omega_s', '\omega_N','Location', 'Best')

 axes(ah(2))
 ylim([-100,0])
 yl = get(gca, 'YLim');
 plot([ws, ws], yl, 'k--')
 plot([ws/2, ws/2], yl, 'k:')
 
 
 figure(2)
 clf
 step(G_zoh, G_approx);
 hold on
 legend('Sample-and-hold', 'Approximation', 'Location', 'Best')
 