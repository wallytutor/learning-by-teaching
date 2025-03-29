function Ydot = graf_kinetics(Y, t, P, RT)
    % Compute mass fraction rates of production species.
    % Molar masses C2H2, H2, C2H4, CH4, C4H4, C6H6, Cs, N2.
    W = [26; 2; 28; 16; 52; 78; 12; 28] ./ 1000;

    % Compute gas density.
    rho = (P / RT) * sum(1.0 / (Y ./ W));

    % Convert mass fractions to concentrations.
    X = rho * Y ./ W;

    % Reaction rates in molar units.
    rates = [
        4.4e+03 * exp(-1.0300e+05 / RT) * X(1) * X(2)^0.36;
        3.8e+07 * exp(-2.0000e+05 / RT) * X(3)^0.50;
        1.4e+05 * exp(-1.5000e+05 / RT) * X(1)^0.35 * X(2)^0.22;
        8.6e+06 * exp(-1.9500e+05 / RT) * X(4)^0.21;
        1.2e+05 * exp(-1.2070e+05 / RT) * X(1)^1.60;
        1.0e+15 * exp(-3.3520e+05 / RT) * X(5)^0.75;
        1.8e+03 * exp(-6.4500e+04 / RT) * X(1)^1.30 * X(5)^0.60;
        5.5e+06 * exp(-1.6500e+05 / RT) * X(1)^1.90 / (1.0 + 18.0 * X(2));
        1.0e+03 * exp(-7.5000e+04 / RT) * X(6)^0.75 / (1.0 + 22.0 * X(2));
    ];

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

    % Get rate in mass fraction units.
    Wdot = (nu * rates) .* W ./ rho;

    % Concatenate arrays for balance over porter N2.
    %Ydot = cat(1, Wdot(1:7), 1.0 - sum(Wdot(1:7)));

    % Solving all species at once.
    Ydot = Wdot;
endfunction
