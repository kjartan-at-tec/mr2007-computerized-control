julia -q --eval "G=2*tf([1], [1, 0])*tf([2], [1, 4])*tf([3], [1, 6]);H=c2d(G, 0.2); print_nyq_real_im(H, -1, 1);"
