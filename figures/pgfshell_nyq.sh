julia -q --eval "H=tf([1,-0.5],[1,-1],1)*tf([1,0.4], [1, -0.3], 1)*tf([1], [1,-0.1],1);print_nyq_real_im(H, -1, 0.49);"
