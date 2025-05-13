function thermal_expansion_coef(tx) {
    val = 0.0;

    dt = 100.0;
    tm = 2327.0;
    smeared = 0.0009;
    
    t0 = tm - dt;
    t1 = tm;

    if (tx < t0) {
        val = 1.0e-06 * (5.49141 + tx * (4.504526e-03 - 8.69767e-07 * tx));
    } else if ((tx >= t0) & (tx < t1)) {
        val = smeared;
    } else {
        val = 0.0;
    }

    _thermal_expansion_coef = val;
}
