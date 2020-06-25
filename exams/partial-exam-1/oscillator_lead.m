omega=pi/4;
h = 1;
beta = cos(omega*h);

H = tf((1-beta)*[1,1], [1, -2*beta, 1], 1);

figure(1)
clf
pzmap(H)

F1 = tf([1, -0.9], [1, -0.1], 1);
F2 = tf([1, -1.5, 0.6], conv([1, -0.3], [1, -0.3]), 1)

figure(2)
clf
rlocus(F2*H)
%axis equal
xlim([-2,2])
ylim([-1.8,1.8])
set(findobj(gcf, 'Type', 'Line'), 'Linewidth', 2)
print -dpdf oscillator_lead_rlocus.pdf


%% Generate some step responses
Tlim = 10;
k_limes=[0.1 0 Tlim -6 6
    0.2  0 Tlim -6 6
    0.4  0 Tlim -6 6
    2  0 Tlim -6 6;
    4  0 Tlim -6 6];
    
for i = 1:size(k_limes, 1)
%for i = 2:3
    Gc = feedback(F2*H, k_limes(i,1));
    t0 = 1/evalfr(Gc, 1)
    figure(i+10)
    clf
    step(t0*Gc)
    xlim(k_limes(i,2:3))
    ylim(k_limes(i,4:5))
    h = findobj(gcf, 'type', 'line');
    set(h, 'linewidth', 2)
    fname = sprintf('oscillator-step-plot-%d', i)
    print(fname, '-dpdf')
    
    figure(i+20)
    clf
    pzmap(Gc)
    
end


