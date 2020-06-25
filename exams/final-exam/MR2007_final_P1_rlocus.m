% Problem 1 final exam MR2007 HT2016
H = tf([1, 1], 2*[1, -2, 1], 1);

Ffb = tf(2*[2, -1], [1, 1], 1);
Fff = tf(2*[2, -1], [1, 1], 1);

figure(1)
clf
rlocus(H*F)
axis equal
print -dpdf p2_rlocus_rlocus.pdf

k_limes=[0.00263 0 100 0 4
    0.8  0 100 0 4
    1  0 100 -6 6
    3  0 10 -6 6;
    4  0 10 -6 6];
    
%for i = 1:size(k_limes, 1)
for i = 2:3
    figure(i)
    clf
    step(feedback(k_limes(i,1)*H*F,1))
    xlim(k_limes(i,2:3))
    ylim(k_limes(i,4:5))
    h = findobj(gcf, 'type', 'line')
    set(h, 'linewidth', 2)
    fname = sprintf('step-plot-%d', i)
    print(fname, '-dpdf')
end
