% MR2007
% Generating data sets for the students to work on to identitfy the model

% Kjartan Halvorsen
% 2017-04-21

h = 1;
noisestd = 0.1;
sigma = 0.08;

%% Model 1, first order, one pole no zeros
p1 = 0.8;
H1 = tf([1-p1], [1, -p1], h);
[num, den] = tfdata(H1);
H1e = tf([1, 0], den{1}, h)


% Generate identification data
N = 400;
t = (0:(2*N-1))'*h;

uu = 2*( -0.5 + randi([0,1], 1, N) );
u = cat(1, uu, uu);
u1 = u(:);
e1 = sigma*randn(size(u1));     

y1 = lsim(H1, u1) + lsim(H1e, e1);

% Generate validation sequence
uu = 2*( -0.5 + randi([0,1], 1, N) );
uv = cat(1, uu, uu);
u1_val = uv(:);
ev1 = sigma*randn(size(u1_val));

y1_val = lsim(H1, u1_val) + lsim(H1e, ev1);


%% Model 2, first order, one pole, one zero one delay
p2 = 0.9;
z2 = -0.6;
H2 = tf((1-p2)/(1-z2)*[1, -z2], [1, -p2, 0], h)
[num, den] = tfdata(H2);
H2e = tf([1, 0, 0], den{1}, h)

u2 = u1;
u2_val = u1_val;
y2 = lsim(H2, u2) + lsim(H2e, e1);
y2_val = lsim(H2, u2_val) + lsim(H2e, ev1);


figure(2)
clf
subplot(211)
stairs(t, u2, 'linewidth', 2)
hold on
stairs(t, u2_val, 'linewidth', 1)
ylabel('u')
subplot(212)
ylabel('y')
stairs(t, y2_val, 'linewidth', 1)
hold on
plot(t, y2, 'o')


%% Model 3, second order, two poles, no zero, no delay
p31 = 0.7 + 0.3*1j;
p32 = 0.7 - 0.3*1j;
den = conv([1, -p31], [1, -p32]);
k3 = sum(den);
H3 = zpk([],[p31, p32], k3, h);

[num, den] = tfdata(H3);
H3e = tf([1, 0, 0], den{1}, h)

u3 = u1;
u3_val = u1_val;
y3 = lsim(H3, u3) + lsim(H3e, e1);
y3_val = lsim(H3, u3_val) + lsim(H3e, ev1);

figure(3)
clf
subplot(211)
stairs(t, u3, 'linewidth', 2)
hold on
stairs(t, u3_val, 'linewidth', 1)
ylabel('u')
subplot(212)
stairs(t, y3, 'linewidth', 2)
ylabel('y')
hold on
stairs(t, y3_val, 'linewidth', 1)

save('sysid_exercise_data.mat', ...
    'u1', 'y1', 'u1_val', 'y1_val',...
    'u2', 'y2', 'u2_val', 'y2_val',...
    'u3', 'y3', 'u3_val', 'y3_val')

 
%% Estimation with least squares "by hand"

% Model 1 - one pole, no zero, no delay
Phi_1 = [-y1(1:end-1), u1(1:end-1)];
par_1 = Phi_1 \ y1(2:end);

disp('Estimation of first-order model with one pole, no zero')
disp(sprintf('Estimated pole: %f    True pole: %f', [-par_1(1), p1]))
disp(sprintf('Estimated gain: %f    True gain: %f', [par_1(2), 1-p1]))

% Model 2 - one pole, one zero, one delay

Phi_2 = [-y2(2:end-1), u2(2:end-1), u2(1:end-2)];
par_2 = Phi_2 \ y2(3:end);

disp('Estimation of first-order model with one pole, one zero and one delay')
disp(sprintf('Estimated pole: %f    True pole: %f', [par_2(1), p2]))
disp(sprintf('Estimated zero: %f    True zero: %f', [-par_2(3)/par_2(2), z2]))

% Model 3 - Second order, two poles, no zeros, no delays

Phi_3 = [-y3(2:end-1), -y3(1:end-2), u3(1:end-2)];
par_3 = Phi_3 \ y3(3:end);
a = [1, par_3(1:2)'];
p3hat = roots(a);

disp('Estimation of second-order model with two poles, no zero, no delay')
disp(sprintf('Estimated poles: %f + %f i and %f + %f i    ', ...
    [real(p3hat(1)), imag(p3hat(1)), real(p3hat(2)), imag(p3hat(2))]))
disp(sprintf('True poles: %f + %f i and %f + %f i', ...
    [real(p31), imag(p31), real(p32), imag(p32)]))
disp(sprintf('Estimated gain: %f    True gain: %f', [par_3(3), k3]))


% Try over-parameterized model for system 1

Phi_12 = [-y1(2:end-1), -y1(1:end-2), u1(2:end-1), u1(1:end-2)];
par_12 = Phi_12 \ y1(3:end);
a = [1, par_12(1:2)'];
b = par_12(3:4)';
[num, den] = tfdata(H1);

disp('Estimation of over-parameterized second-order model with two poles, one zero, no delay')
disp(sprintf('Estimated A(q): [%f,  %f,  %f]', a))
disp(sprintf('True A(q): [1, %f]', -p1))
disp(sprintf('Estimated B(q): [%f, %f]', b))
disp(sprintf('True B(q): %f',1-p1))


%% Simulate and plot 
H1hat = tf(par_1(2), [1, par_1(1)], 1);
H1hat2 = tf(b, a, 1);
y1_val_hat = lsim(H1hat, u1_val);
y1_val_hat2 = lsim(H1hat2, u1_val);
figure(1)
clf
stairs(y1_val)
hold on
stairs(y1_val_hat)
stairs(y1_val_hat2)
legend('Validation data', 'True model order', 'Over-parameterized')

figure(2)
clf
step(H1, H1hat, H1hat2)
legend('Validation data', 'True model order', 'Over-parameterized')



