// slycke.sce

disp("*** SLYCKE MODEL OF CARBONITRIDING ***")
exec("src/model.sci", -1)

validate_table_iv()

p = [
    %nan,     // 1 (N2)
    0.33,     // 2 (H2)
    0.0,      // 3 (CO)
    0.0,      // 4 (O2)
    0.0,      // 5 (CO2)
    0.0,      // 6 (CH4)
    2000e-06  // 7 (NH3)
]

p(1) = 1 - sum(p(2:$))
validate_slycke_composition(p)

T = 870 + 273.15

v7_f = velocity_7furnace(T, p)
v7_g = velocity_7gamma(T, p)

