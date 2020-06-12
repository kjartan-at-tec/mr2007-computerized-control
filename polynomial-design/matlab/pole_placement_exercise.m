%% MR2007 Spring 18
% Generate step plots for RST exercise

numerators = [0.5, 0.45
    0.8, 0.78
    0.8, 0.78
    0.8, 0.78
    0.5, 0.45];
denominators = [1, -0.95, 0
    1, -1, 0.25
    1, -1, 0.81+0.5^2
    1, -1.6, -0.09+0.8^2
    1, -1.6, 0.09+0.8^2];


tvec = (0:1:40)';
ys = zeros(length(tvec), 5);
for i=1:size(numerators,1)
    num = numerators(i,:);
    den = denominators(i,:);
    Gc = abs(sum(den)/sum(num))*tf(num, den, 1)
    figure(i)
    clf
    subplot(121)
    pzmap(Gc)
    subplot(122)
    step(Gc)
    [ys(:,i), t] = step(Gc, tvec);
end

fname = 'pole-placement-exercise-step-plot.dta';
dlmwrite(fname, cat(2, t, ys));
