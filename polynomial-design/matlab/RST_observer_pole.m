function [Ss, Tt, w, sol] = RST_observer_pole(p, sol, hS, hT)
% [Ss, Tt, w, sol] = RST_observer_pole(p, sol, hS, hT)
% Returns gains of sensitivity function and complementary
% sensitivity for RST design of first order system with
% incremental controller.

beta = 1;
alpha = -0.9;

syms s1 s2 z p1 po1
if nargin == 1
    [sol, t0] = RST_sym([0, beta], [1, alpha], 0, 1);

    % Substitute numerical values
    p1_n = 0.8;

    vars = [p1];
    numvals = [p1_n];

    sol.s1 = subs(sol.s1, vars, numvals);
    sol.s2 = subs(sol.s2, vars, numvals)
end

s0_n = double(subs(sol.s1, [po1], p));
s1_n = double(subs(sol.s2, [po1], p));


%% Form closed-loop system

h = 1;
G = tf([0, beta], [1, alpha], h);
Sp = [s0_n, s1_n];
Rp = [1, -1];
Fb = tf(Sp, Rp, h);

%Gc = minreal( Ff*feedback(G, Fb) );
Gd = minreal( feedback(1, G*Fb) );
Gn = minreal( feedback(G*Fb, 1) );

[Ss, ph, w] = bode(Gd);
[Tt, ph] = bode(Gn, w);
Ss = Ss(:);
Tt = Tt(:);

if nargin == 4
    set(hS, 'YData', Ss);
    set(hT, 'YData', Tt);
    ylim([0.001, 10]);
end 
