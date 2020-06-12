function u = tank_pid(e)
% Implementation of discretized PID controller
% The PID parameters are contained in the global variable G_PID_PAR
% The state of the controller is contained in the global variable
% G_PID_STATE

global G_PID_PAR  G_PID_STATE;

% The proportional part
up = G_PID_PAR.K * e;

% The derivative part
k1 = G_PID_PAR.Td/(G_PID_PAR.Td + G_PID_PAR.N*G_PID_PAR.h);
k2 = G_PID_PAR.Td*G_PID_PAR.K*G_PID_PAR.N/(G_PID_PAR.Td + G_PID_PAR.N*G_PID_PAR.h);
ud = k1 * G_PID_STATE.ud + k2 * (e - G_PID_STATE.e);

% Calculate the command signal
u = up + G_PID_STATE.ui + ud

% Update the integral part
ui = G_PID_STATE.ui + G_PID_PAR.K*G_PID_PAR.h/G_PID_PAR.Ti * e;

% Update the state variable
G_PID_STATE.ud = ud;
G_PID_STATE.ui = ui;
G_PID_STATE.e = e;


