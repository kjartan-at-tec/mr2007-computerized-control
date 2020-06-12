julia -q --eval "G=2*tf([1], [1, 0])*tf([2], [1, 2])*tf([3], [1, 3]);print_bode_mag(G, -2, 2);"
