octave -q --eval "format long; G=tf([3],[28.387, 3*sqrt(28.387), 3]); [mag,phi,w]=bode(G); disp(cat(2,w',phi))"
