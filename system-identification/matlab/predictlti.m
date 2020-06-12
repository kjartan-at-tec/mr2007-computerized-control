function [ypredk, tk] = predictlti(b, a, u, y, k, d)
% [ypredk, tk] = predictlti(b, a, u, y, k, d)
% Computes the k-step ahead prediction given the discrete LTI system
%     H(q) = b(q) / a(q),
% the input signal u and the output signal y.
%
% Input
%    b  ->  numerator coefficients (1 x m) row vector
%    a  ->  denominator coefficients (1 x n) row vector
%    u  ->  input data (N x 1) column vector 
%    y  ->  output data (N x 1) column vector 
%    k  ->  prediction horizon (integer > 0)
%    d  ->  input delay (integer >= 0)
% Output
%    ypredk  <-  predicted output ((N-k) x 1) column vector
%    tk      <-  for convenience, discrete time vector for predicted values 
%                tk = [1+k, 2+k, ..., N]
% Kjartan Halvorsen
% 2018-10-16

if nargin == 0
    unit_test();
    return
end

if nargin < 6
    d = 0;
end
if nargin < 5
    k = 1;
end

aa = cat(2, a, zeros(1,d));
bb = cat(2, zeros(1, length(aa)-length(b)), b);

n = length(aa) - 1; % System order
N = length(u); % Length of data

yy = cat(1, zeros(n,1), y); % Prepad with initial values
uu = cat(1, zeros(n,1), u); % Prepad with initial values

ypredk = nan(N-k, 1);
tk = (1+k:N)';

for i=1:(N-k)
    ysim = yy(i+1:i+n+k); % First n are initial values, last k will be overwritten 
    usim = uu(i+1:i+n+k);
    %keyboard
    for l=1:k
        ysim(n+l) = -aa(2:end)*flipud(ysim(l:(n+l-1))) ...
            + bb*flipud(usim(l:(n+l)));
    end
    ypredk(i) = ysim(end);
end
end

function unit_test()
    % Generate some data and test method
    b = [0, 0, 1,0.9];
    a = [1, -sqrt(3), 1, 0];
    
    N = 50;
    u = randn(N, 1);
    %y = filter(b, a, u);
    y = lsim(tf(b, a, 1), u);
    
    k = 10;
    [ypred, tpred] = predictlti(b(3:end), a(1:3), u, y, k, 1);
    
    tt = (1:N)';
    figure()
    clf
    plot(tt, y, 'bo');
    hold on
    plot(tpred, ypred, 'rx');
    
    
end

