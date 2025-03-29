function [h, sol] = graf_integrate(T, P, Y, tout, nsteps, saveas)
    % Integrate kinetics over time and display results.

    % Create anonymous function.
    f =  @(Y, t) graf_kinetics(Y, t, T, P);

    t = linspace(0, tout, nsteps);
    lsode_options('integration method', 'stiff');
    lsode_options('absolute tolerance', 1.0e-15);
    lsode_options('relative tolerance', 1.0e-06);
    lsode_options('minimum step size', 1.0e-12);
    lsode_options('maximum step size', 1.0e-01);
    lsode_options('initial step size', 1.0e-12);
    lsode_options('maximum order', 5);

    [sol, istate, msg] = lsode(f, Y, t);

    h = graf_plot(t, sol, saveas);
endfunction
