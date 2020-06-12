function p = dc_p_control_poles(K)

    p = roots([1, -1.67+0.07*K, 0.06*K + 0.67])
    