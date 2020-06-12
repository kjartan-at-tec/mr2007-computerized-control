% Script for setting values of RST-controller for the example of ship
% heading

% Kjartan Halvorsen 
% 2016-02-04

h = 0.2; % Fixed

a = 0; % Deadbeat observer
a = 0.003; % Twice as fast as closed-loop poles
%a = 0.2; % Less fast observer

[r1, r2, r3, s0, s1, s2, s3, t0] = PS4_ship_heading_RST_example_aliasing(a)

