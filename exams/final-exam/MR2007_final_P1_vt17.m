%% MR2007 final exam VT17, problem 1
close all
clear all

G = tf([1], [1, 0, -1]);
h = 0.1;
H = c2d(G, h)
F = tf([1, -0.8], [1, 0], h)

figure(1)
clf
rlocus(F*H)
xlim([-3,2])
ylim([-2,2])
set(findobj(gca, 'type', 'line'), 'linewidth', 2)
axis equal
print -dpdf final_p1_rlocus_vt17.pdf


K = [6, 54, 180, 200];
  
for i = 1:length(K)
    sys = feedback(K(i)*F*H, 1);
    figure(1+i)
    clf
    step(sys, 20)
    %xlim(k_limes(i,2:3))
    %ylim(k_limes(i,4:5))
    hh = findobj(gcf, 'type', 'line')
    set(hh, 'linewidth', 2)
    fname = sprintf('step-plot-%d-vt17', i)
    print(fname, '-dpdf')
end

[num, den] = tfdata(H);
Phi = cat(1, -den{1}(2:end), [1, 0])
Gamma = [1;0];
C = num{1}(2:end)

Hss = ss(Phi, Gamma, C, 0, h)

Htf = tf(Hss)

