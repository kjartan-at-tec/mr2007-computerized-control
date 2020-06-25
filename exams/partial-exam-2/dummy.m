GS = zpk([], [-1, -1, -3], 1)

figure(1)
clf
margin(GS)

wp = 2.65;
Tu = 2*pi/wp
