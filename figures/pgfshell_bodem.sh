julia -q --eval "H=tf([1,0.1],[1, 2 * 0.95* 10, 10* 10]);print_bode_mag(H, -2, 0.49);"
