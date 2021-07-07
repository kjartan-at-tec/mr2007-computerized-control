%% Nyquist exercise

% Kjartan Halvorsen
% 2021-06-30

h = 0.1;
s = tf('s');
Gs = { 1/(s*(s+1)), ...
    (s+3)/((s+0.5)*(s+1)*(s+5)), ...
     (s+1)/(s*s), ...
     (s + 2)/((s+3)*(s+4))};
 
 for i=1:4
     i
     G = Gs{i};
     Gd = c2d(G, h);
     pole(Gd)
     zero(Gd)
     [zz, pp, gg] = zpkdata(Gd);
     gg
     figure(i)
     clf
     rlocus(Gd)
     xlim([-1.5, 1.5])
     ylim([-1.2, 1.2])
     axis equal
     set(findobj(gca, 'type', 'line'), 'linewidth', 2);
     set(findobj(gca, 'type', 'line'), 'MarkerSize', 10);
     
     print(sprintf('rlocus-exc-%d', i), '-dpng')
 end
 