% Below we define an integration manager. As we need to integrate the same problem
% under several conditions it is also interesting to provide such a function with
% the initialization and output provided in a standard way. Here we make use of
% [LSODE](https://computing.llnl.gov/casc/nsde/pubs/u113855.pdf) to perform system
% integration. Notice that several options were set with `lsode_options` and you
% might want to tweak them in other scenarios.

graphics_toolkit("qt");

Y = [3.36389444e-01, 0.00000000e+00, 0.00000000e+00, 4.22984293e-04,...
     0.00000000e+00, 0.00000000e+00, 0.00000000e+00, 6.63187571e-01];

[h, sol] = graf_integrate(1173.0, 5000.0, Y, 1.4, 100, "graf_plot_octave");

% Mass conservation check: sum(sol')
