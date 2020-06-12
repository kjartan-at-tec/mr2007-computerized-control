% HW3 2018 fall - RST for oscillator
h=1; 
w = pi/6;
cwh = cos(h*w);
b1 = 1-cwh;
b2 = b1;
a1 = -2*cwh;
a2 = 1;

H = tf([0, b1, b2], [1, a1, a2], h);
figure(1)
pzmap(H)
zgrid

% The coefficients of the controller
R_coeffs = [1, 0.31405]; 
S_coeffs = [1.6272, -2.344];
T_coeffs = 0.597*[1,0];

% The forward part of the controller
TR = tf(T_coeffs, R_coeffs, h);
% The feedback part of the controller
SR = tf(S_coeffs, R_coeffs, h);

% The closed-loop system
Hc = TR*feedback(H,SR)
Hv = feedback(1, H*SR);

figure(1)
clf
pzmap(Hc) % Verify that the closed-loop poles are as desired

figure(2)
clf
step(Hc, Hv) % OK performance?
legend('Step from reference', 'Step from disturbance')

figure(3)
clf
margin(H*SR) % What are the stability margins?


%% Design with incremental controller

r_1 = 0.657025;
s_0 = 6.531281;
s_1 = -10.838255;
s_2 = 4.904102;
t_0 = 0.597128;

% The coefficients of the controller
R_coeffs = conv([1, -1], [1, r_1]); 
S_coeffs = [s_0, s_1, s_2];
T_coeffs = t_0*[1,0,0];

% The forward part of the controller
TR = tf(T_coeffs, R_coeffs, h);
% The feedback part of the controller
SR = tf(S_coeffs, R_coeffs, h);

% The closed-loop system
Hc = TR*feedback(H,SR)
Hv = feedback(1, H*SR);

figure(1)
clf
pzmap(Hc) % Verify that the closed-loop poles are as desired

figure(2)
clf
step(Hc, Hv) % OK performance?
legend('Step from reference', 'Step from disturbance')

figure(3)
clf
margin(H*SR) % What are the stability margins?

