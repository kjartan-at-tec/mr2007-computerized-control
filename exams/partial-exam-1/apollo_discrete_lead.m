%% Lead regulator for apollo lunar module exercise 
%%

%% Kjartan Halvorsen
%% 2017-09-05

clear all
close all

h = 1;
s = tf('s');
G = 1/( s*s*s);

H = c2d(G, h)

%F = tf([0.3, -0.6, 0.27],[1, -0.25, 0.13], h)
zrs = [0.8+0.2*1j, 0.8-0.2*1j, 0.9];
pls = [0, -0.27, -0.5];
kk = sum(1-pls)/sum(1-zrs);
F = zpk(zrs, pls, kk, 1);


figure(1)
clf
rlocus(H*F)
set(findobj(gca, 'type', 'line'), 'LineWidth', 2)

figure(2)
clf
pzmap(feedback(H*F, 1))

%% Generate cases
% Gains
K_params = [0.0124, 0.1, 0.18, 0.3];


N = 60;
u = ones(N+1,1);
t = (0:N)';

y = zeros(N+1, length(K_params));

for i =1:length(K_params)
 
    %G0 = K_params(i)*G*F1*F2;
    G0 = K_params(i)*H*F;
    Gc = feedback(G0, 1);
    
    [num, den] = tfdata(Gc);
    zer = roots(num{1});
    poles = roots(den{1});


    y(:,i) = lsim(Gc, u, t);

    po = sort(poles, 'descend', 'ComparisonMethod', 'real')
    ze = sort(zer, 'descend', 'ComparisonMethod', 'real')
    
    dlmwrite(sprintf('apollo-discrete-lead-zeros-case%d.txt', i), cat(2, real(ze), imag(ze)), 'delimiter', '\t');
    dlmwrite(sprintf('apollo-discrete-lead-poles-case%d.txt', i), cat(2, real(po), imag(po)), 'delimiter', '\t');

    figure(i+1)
    clf
    subplot(122)
    plot(t,u, '--');
    hold on
    stairs(t, y(:,i))

    subplot(121)
    zplane(num{1},den{1})
    ylim([-7,7])
    xlim([-7,7])
    

end

dlmwrite('apollo-discrete-lead-timeseries.txt', cat(2, t, y), 'delimiter', '\t');



