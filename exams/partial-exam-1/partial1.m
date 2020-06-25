% MR2007 VT2017 

s = tf('s')
G1 = 4/(s+1) * 2/(s+2);
G2 = 4/(s+1);

h = 0.2;
eh = exp(-h);
e2h = exp(-2*h);

H1 = tf([ 4-8*eh+4*e2h, 4*eh*(e2h+1)-8*e2h], [1, -eh-e2h, eh*e2h], h)
H2 = tf([ 4*(1-eh) ], [1, -eh], h)

H1_check = c2d(G1, h, 'zoh')
H2_check = c2d(G2, h, 'zoh')

% Controller
F = c2d(1+1/s, h, 'foh');

figure(1)
clf
rlocus(F*H1)
axis equal
print -dpdf p3_rlocus.pdf

Tlim = 10;
k_limes=[0.1 0 Tlim -6 6
    0.8  0 Tlim -6 6
    2  0 Tlim -6 6
    2.88  0 Tlim -6 6;
    4  0 Tlim -6 6];
    
for i = 1:size(k_limes, 1)
%for i = 2:3
    figure(i+1)
    clf
    step(H2*feedback(1, k_limes(i,1)*H1*F))
    xlim(k_limes(i,2:3))
    ylim(k_limes(i,4:5))
    h = findobj(gcf, 'type', 'line')
    set(h, 'linewidth', 2)
    fname = sprintf('step-plot-%d', i)
    print(fname, '-dpdf')
end



% Closed-loop system from disturbance to output
Hc = feedback(H2, F*H1);

