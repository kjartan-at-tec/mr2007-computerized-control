% Script for setting values of RST-controller for the example of ship
% heading. Plant model including delay of 3h

% Kjartan Halvorsen 
% 2016-02-04

h = 0.2; % Fixed

a = 0; % Deadbeat observer
a = 0.1; % Almost deadbeat observer
a = 0.9; % Less fast observer

[r1, r2, r3, r4, s0, s1, s2, s3, s4, t0] = PS4_ship_heading_RST_example_aliasing_3h(a)

