exec("src/basis.sci", -1)

REAC7_g = Reaction(  %nan,  %nan, 6.40e+10, 281000, 7.90e-02, 178000)
REAC7_f = Reaction(12.392, -5886, 7.90e+11, 227000,      %nan,  %nan)

function [v] = velocity_7furnace(T, p)
    kf = forward_rate(T, REAC7_f)
    Kp = equilibrium_constant(T, REAC7_f)
    v = kf * (p(7)^2 / p(2)^3 - p(1) / Kp)
end

function [v] = velocity_7gamma(T, p)
    kf = forward_rate(T, REAC7_g)
    kb = backward_rate(T, REAC7_g)

    a = p(2)^(1.5)
    v = kf * p(7) / a - kb * p(1) * a / p(7)
endfunction

function validate_table_iv()
    disp("Verification of Table IV")

    T = 870 + 273.15
    p_nh3 = [50, 100, 500, 1000, 1500, 2000]

    for pk = p_nh3
        p = zeros(7)
        p(2) = 0.33
        p(7) = pk * 1.0e-06
        p(1) = 1 - sum(p(2:$))

        validate_slycke_composition(p)

        v7_f = velocity_7furnace(T, p)
        v7_g = velocity_7gamma(T, p)

        printf("%8.1e %8.1e %6.2f\n", v7_f, v7_g, v7_f/v7_g)
    end
end