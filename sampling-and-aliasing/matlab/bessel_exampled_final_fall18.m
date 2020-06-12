%% For final exam fall 18

s = tf('s');

% Some cut-off frequencies and model orders
cutoffs = [10, 80, 80, 320];
modelorders = [4, 4, 2, 6];

N = 400;
w = logspace(0, 3, N);

wmag = zeros(N, 5);
wmag(:,1) = w';

for i = 1:length(cutoffs)
    cf = cutoffs(i);
    mo = modelorders(i);

    [b, a] = besself(mo, cf);
    
    H = tf(b, a);
    
    [mag, phas] = bode(H, w);
    wmag(:,i+1) = mag;
end

dlmwrite('bessel-examples-fall18.dta', wmag, 'delimiter', ',');
