octave -q --eval "format long; pkg load control; G=tf(2*[0 0.215472893222061 -0.117551386132128],[1 -1.650518719342394 0.657046819815057], 0.1); [mag,phi,w]=bode(G,{1e-2, 5e1} ); disp(cat(2,w',phi))"
