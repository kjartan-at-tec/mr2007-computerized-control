%% PID regulator for tank exercise, homework 3 
%%

%% Kjartan Halvorsen
%% 2016-03-08


G1 = tf([2],[1 0]);
G2 = tf([4], [1 2]);

s = tf('s');

N = 400;
u = -ones(N,1);
t = linspace(0,10,N);

             % P I D
PID_params = zeros(3,3);
% Case 1
PID_params(1,1) = 4;
PID_params(1,2) = 1;
PID_params(1,3) = 0;

PID_params(2,1) = 2;
PID_params(2,2) = 0;
PID_params(2,3) = 0;


PID_params(3,1) = 2;
PID_params(3,2) = 2;
PID_params(3,3) = 1;

y = zeros(N, size(PID_params,1));

for i =1:size(PID_params,1)
    Kp = PID_params(i,1);
    Ki = PID_params(i,2);
    Kd = PID_params(i,3);

    F = Kp + Kd*s + Ki/s;

    G0 = G1*G2*F;
    %S = feedback(G1,G0);
    S = G1/(1+G0)
    
    [num, den] = tfdata(S);
    zer = roots(num{1});
    poles = roots(den{1});


    y(:,i) = lsim(S, u, t);

    % If pole in origin, check if cancels zero in origin
    if ismember(0, poles)
        if ismember(0, zer)
            zi = find(zer == 0);
            zer(zi(1)) = [];
            pi = find(poles == 0);
            poles(pi(1)) = [];
        end
    end
    
    %po = setdiff(poles, zer);
    %ze = setdiff(zer, poles);
    po = poles
    ze = zer
    
    dlmwrite(sprintf('tank-pid-zeros-case%d.txt', i), cat(2, real(ze), imag(ze)), 'delimiter', '\t');
    dlmwrite(sprintf('tank-pid-poles-case%d.txt', i), cat(2, real(po), imag(po)), 'delimiter', '\t');

    figure(i)
    clf
    plot(t,u, '--');
    hold on
    plot(t, y(:,i))

    figure(4+i)
    clf
    zplane(num{1},den{1})


end

dlmwrite('tank-pid-timeseries.txt', cat(2, t', y), 'delimiter', '\t');



