% Script for declaring and setting global variables used py the explicit
% implementation of the pid control of the tank

global G_PID_PAR G_PID_STATE

L = 15;
R = 0.01;
a = R*L;

G_PID_PAR.N=10;
G_PID_PAR.Td = 0.5*L;
G_PID_PAR.K = 1.2/a;
G_PID_PAR.Ti = 2*L;
G_PID_PAR.h = 1;

G_PID_STATE.e = 0;
G_PID_STATE.ud = 0;
G_PID_STATE.ui = 0;
G_PID_STATE.y = 0;

