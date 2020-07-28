function [r, k] = covfcn(x, kmax)
% [r,k] = covfcn(x [, kmax])
% Computes the covariance function for the signal x, and plots in
% the current figure. 
%
% Input
%    x    ->  Scalar signal (N x 1)
%    kmax ->  Max number of delays in the covariance function 
% Output
%    r     <-  covariance function (kmax+1 x 1), r(k) = cov(x(1:end-k), x(k+1:end))
%    k     <-  for convenience, the lags 
%                k = [0, 1, 2, ..., kmax]
% Kjartan Halvorsen
% 2018-10-16

if nargin == 0
    unit_test();
    return
end

x  = x(:);
N = length(x);

if nargin < 2
    kmax = floor(N/30);
end

r = zeros(kmax+1, 1);

k = (0:kmax)';
for kk = k'
    covk = cov(x(1:end-kk), x(kk+1:end)); 
    r(kk+1) = covk(1,2);
end

plot(k, r)
xlabel('lag')
ylabel('cov')

end

function unit_test()
    % Generate some data and test method
    x  = randn(300,1);
    kmax = 10;
    figure
    [r, k] = covfcn(x, kmax);  
end

