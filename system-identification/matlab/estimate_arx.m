function [sys, resid, resval, rms, fit] = estimate_arx(u, y, n, m, d, uval, yval, figh)
%
%[sys, resid, resval, rms, fit] = estimate_arx(u, y, n, m, d, [uval, yval, figh])
%
% Estimates the ARX model
%   (q^n + a_1q^{n-1} + ... + a_n)y(k) = 
%                      (b_0q^m + b_1q^{m-1} + ... + b_m)q^{-d}u(k)
%                      + q^ne(k)
% Input arguments
%    u             ->   input data (N,1)
%    y             ->   output data (N,1)
%    n             ->   model order ( order of A(q) polynomial)
%    m             ->   order of B(q) polynomial. Must have m <= n
%    d             ->   number of delays in input data 
%    uval          ->   validation input data (N,1)
%    yval          ->   validation output data (N,1)
%    figh          ->   figure handle. If not given new figure created
% Return arguments
%    sys           ->   estimated model
%    resid         ->   residuals y - \hat{y}
%    resval        ->   residuals of validation data yval - yvalsim
%    rms           ->   root mean square of validation residuals
%    fit           ->   fit measure of validation residuals 

if nargin < 8
    figh = figure();
end

if nargin < 6
   validate = 0;
else
    validate = 1;
end

 
nn = n+d;
yy = y(nn+1:end);
Phi = [];
for i=1:n
    Phi = cat(2, Phi, -y(nn+1-i:end-i));
end
for i=(d+n-m):(d+n)
    Phi = cat(2, Phi, u(nn+1-i:end-i));
end

theta = (Phi\yy)';
resid = yy - Phi*theta';

den = [1, theta(1:n)];
num = theta(n+1:end);
sys = tf(num, den, 1, 'IODelay', d);

if validate
    k = 10; % Using 10-step ahead predictor for validation
    [ysim, tk] = predictlti(num, den, uval, yval, k, d);
    resval = yval(k+1:end) - ysim;
    rms = sqrt(mean(resval.^2));
    fit = 100* (1 - norm(resval) / norm(yval - mean(yval)));
    
    
    figure(figh)
    clf
    subplot(211)
    stairs(uval, 'linewidth', 0.5)
    hold on
    stairs(tk, ysim, 'linewidth', 2)
    stairs(yval, 'linewidth', 1)
    legend('Input','10-step ahead pred', 'Output', 'location', 'best')
    subplot(212)
    stairs(resval)
    legend(sprintf('RMS= %f,  FIT= %f', [rms, fit]), 'location', 'best')
    
end






