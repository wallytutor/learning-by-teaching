function h = graf_integrate(P, T, C2H2, tout, nsteps)
    % Integrate kinetics over time and display results.
    R = 8.314472;              % Gas constant (J/mol/K)
    Y = zeros(8, 1);           % Array of species.
    Y(1) = 0.980 * C2H2;       % C2H2
    Y(4) = 0.002 * C2H2;       % CH4 (Acetylene always has some!)
    Y(8) = 1.0 - sum(Y(1:7));  % N2

    % Create anonymous function.
    f =  @(Y, t) graf_kinetics(Y, t, P, R * T);

    t = linspace(0, tout, nsteps);
    lsode_options('integration method', 'stiff');
    lsode_options('absolute tolerance', 1.0e-15);
    lsode_options('relative tolerance', 1.0e-06);
    lsode_options('minimum step size', 1.0e-12);
    lsode_options('maximum step size', 1.0e-01);
    lsode_options('initial step size', 1.0e-12);
    lsode_options('maximum order', 5);

    [Y, istate, msg] = lsode(f, Y, t);

    h = graf_plot(t, Y);
endfunction
