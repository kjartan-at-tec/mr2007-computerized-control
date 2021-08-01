%% Lead controller DC motor 

% Kjartan Halvorsen
% 2021-07-07

s = tf('s');
G = 1/(s*(s+1));

F = 4*(s+1)/(s+2);

wc = 1.57; % Cross-over frequency
abs(evalfr(G*F, 1j*wc)) % Check

argFatwc = angle(evalfr(F, 1j*wc))*180/pi

h = 0.25;
wcd = exp(1j*wc*h)

% Euler 
% 4 * ( (z-1)/h + 1 ) / ( (z-1)/h + 2 ) = 4* (z-1+h)/(z-1 + 2h)
Fd = 4*tf([1, h-1], [1, 2*h-1], h)
figure(2)
clf
bode(Fd)

argFdatwc = angle(evalfr(Fd, wcd))*180/pi

% Backw
% 4 * ( (z-1)/zh + 1 ) / ( (z-1)/zh + 2 ) = 4 * ( z-1 + zh) / (z-1 + 2zh)
Fd2 = 4*tf([1+h, -1], [1+2*h, -1], h)

argFd2atwc = angle(evalfr(Fd2, wcd))*180/pi

% foh
Fd3 = c2d(F, h, 'foh')
argFd3atwc = angle(evalfr(Fd3, wcd))*180/pi


figure(3)
clf
bode(F, Fd, Fd2, Fd3)
hl = legend('Cont', 'Fwd', 'Bckwd', 'foh');
hl.FontSize = 16;
set(findobj(gcf, 'Type', 'Line'), 'Linewidth', 2)
set(findall(gcf, 'Type', 'Text'), 'Fontsize', 16)

