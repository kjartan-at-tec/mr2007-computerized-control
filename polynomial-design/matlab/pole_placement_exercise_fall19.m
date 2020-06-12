%% MR2007 fall 19
% Generate step plots

zero = -0.95;
poles = [1, 0.8,
    0.8, 1.2,
    0.6, 0.6,
    0.8 + 0.5*1j , 0.8-0.5*1j,
    0.8 + 0.2*1j, 0.8-0.2*1j];


tvec = (0:1:40)';
ys = zeros(length(tvec), 5);
for i=1:size(poles,1)
    p = poles(i,:);
    G = zpk(zero, p, 1, 1);
    dcg = dcgain(G);
    if ~isinf(dcg)
        G = G/abs(dcg);
    end
    G
    figure(i)
    clf
    subplot(121)
    pzmap(G)
    subplot(122)
    step(G)
    [ys(:,i), t] = step(G, tvec);
end

fname = 'pole-placement-exercise-step-plot-fall19.dta';
dlmwrite(fname, cat(2, t, ys));
