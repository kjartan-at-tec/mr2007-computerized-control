%% Hw1 spring 2016

t1 = linspace(0,4, 4*100);

y1 = 1-exp(-t1);
y2 = -y1;
% Delay y2, add 100 zeros (one second)
y2 = [zeros(1,100) y2];

y = y1 + y2(1:4*100);

figure(1)
clf
plot(t1, y)
xlabel('t')
ylabel('x')

%% Alternative way of computing the solution
yint = exp(-t1+1)-exp(-t1);

figure(2)
clf
plot(t1, yint)
xlabel('t')
ylabel('x')
