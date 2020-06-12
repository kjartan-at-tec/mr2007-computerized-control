%% MR2004 final exam fall 18

%% Match trfs with bode and sine in - sine out

w1 = 2;
w2 = 20;
zeta1 = 0.4;
zeta2 = 0.2;

poles = {[-zeta1*w1 + sqrt(1-zeta1^2)*w1*1j, ...
                -zeta1*w1 - sqrt(1-zeta1^2)*w1*1j ], ...
    [-0.5, -4], ...
    [-zeta1*w1 + 2*sqrt(1-zeta1^2)*w1*1j, ...
                -zeta1*w1 - 2*sqrt(1-zeta1^2)*w1*1j, ...
                -zeta2*w2 + sqrt(1-zeta2^2)*w2*1j, ...
                -zeta2*w2 - sqrt(1-zeta2^2)*w2*1j], ...
    [-2,-2,-2]};


N = 400;
w = logspace(-1,1.5,N);
mag = zeros(N, length(poles));
ph = zeros(N, length(poles));

ws = 2; 
t = linspace(0, 12, N)';
u = sin(ws*t);
y = zeros(N, length(poles));


for i=1:length(poles)
    G = zpk([], poles{i}, abs(prod(poles{i})))
    figure(i)
    clf
    bode(G, w)
    [mag(:,i),ph(:,i)] = bode(G, w);
    Gatws = evalfr(G, 1j*ws);
    y(:,i) = abs(Gatws)*sin(ws*t + angle(Gatws));
end

dlmwrite('bode-examples-mag-fall18.dta', cat(2, w', mag) , 'delimiter', ',');
dlmwrite('bode-examples-ph-fall18.dta', cat(2, w', ph) , 'delimiter', ',');
dlmwrite('bode-examples-sine-fall18.dta', cat(2, t, u, y) , 'delimiter', ',');


    
    