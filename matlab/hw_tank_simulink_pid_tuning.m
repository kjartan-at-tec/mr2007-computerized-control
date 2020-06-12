% MR2007 hw3 spring 2018 PID tuning and discretization

% From bumbtest on tank-valve system MR2007/matlab/tank_valve_system_nonlin.slx

t1 = 1.8;
t2 = 2.633;
Dt = t2-t1;
y1 = 1.78;
y2 = 2.39;
Dy = y2-y1;

% Slope
R = Dy/Dt

% Apparent deadtime
L = (y1+y2)/(2*R)

% a-param
a = R*L

% Continuous-time parameters
K = 1.2/a
Ti = 2*L
Td = 0.5*L

N=10;

% Discrete-time parameters

