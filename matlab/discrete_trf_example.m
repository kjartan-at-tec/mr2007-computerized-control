%% Example trf

G1 = zpk([],[0, -2],2)
G2 = zpk([],[-2, 2],1)
G3 = zpk([],[-1+2*i, -1-2*i],1)
G4 = zpk([],[-2+1*i, -2-1*i],1)

h = 0.2;
G1d = c2d(G1, h)
G2d = c2d(G2, h)
G3d = c2d(G3, h)
G4d = c2d(G4, h)

figure(2)
clf
pzmap(G1d, G2d, G3d, G4d)


G =