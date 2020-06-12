% Script to compute parameters for RST-controller
% Spring 16

% Kjartan Halvorsen
% 2016-02-02

Tr = 1;
omega0 = 2.2/Tr;
a_c = -2*omega0;
h = 0.1;
a_d = exp(a_c*h);

r1 = -0.856007930368168*a_d + 0.143992069631831
s0 =-28.7984139263664*a_d + 32.9380169529651
s1 = 24.6588108997672*a_d - 28.7984139263663
t0 = 4.13960302659890