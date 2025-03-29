function Ydot = graf_kinetics(Y, t, T, P)
    % Compute mass fraction rates of production species.
    % Molar masses C2H2, H2, C2H4, CH4, C4H4, C6H6, Cs, N2.
    W = [26; 2; 28; 16; 52; 78; 12; 28];

    % Matrix of stoichiometric coefficients for the reactions above.
    nu = [
        -1, +1, -1, +1, -2, +2, -1, -1, +0; % 1 C2H2
        -1, +1, -3, +3, +0, +0, +0, +1, +3; % 2 H2
        +1, -1, +0, +0, +0, +0, +0, +0, +0; % 3 C2H4
        +0, +0, +2, -2, +0, +0, +0, +0, +0; % 4 CH4
        +0, +0, +0, +0, +1, -1, -1, +0, +0; % 5 C4H4
        +0, +0, +0, +0, +0, +0, +1, +0, -1; % 6 C6H6
        +0, +0, +0, +0, +0, +0, +0, +2, +6; % 7 Cs
        +0, +0, +0, +0, +0, +0, +0, +0, +0; % 8 N2
    ];

    % Compute gas density.
    rho = 1000.0 * ideal_gas_density(T, P, Y, W);

    % Convert mass fractions to concentrations.
    X = ideal_gas_concentration(rho, Y, W);

    % Reaction rates in molar units.
    rates = [
        arrhenius_rate(T, 4.4e+03, 1.030e+05) * X(1) * X(2)^0.36;
        arrhenius_rate(T, 3.8e+07, 2.000e+05) * X(3)^0.50;
        arrhenius_rate(T, 1.4e+05, 1.500e+05) * X(1)^0.35 * X(2)^0.22;
        arrhenius_rate(T, 8.6e+06, 1.950e+05) * X(4)^0.21;
        arrhenius_rate(T, 1.2e+05, 1.207e+05) * X(1)^1.60;
        arrhenius_rate(T, 1.0e+15, 3.352e+05) * X(5)^0.75;
        arrhenius_rate(T, 1.8e+03, 6.450e+04) * X(1)^1.30 * X(5)^0.60;
        arrhenius_rate(T, 5.5e+06, 1.650e+05) * X(1)^1.90 / (1.0 + 18.0 * X(2));
        arrhenius_rate(T, 1.0e+03, 7.500e+04) * X(6)^0.75 / (1.0 + 22.0 * X(2));
    ];

    % Rate of molar production of species.
    omega = nu * rates;

    % Get rate in mass fraction units.
    Wdot = omega .* W / rho;

    % Solving all species at once.
    Ydot = Wdot;
endfunction
