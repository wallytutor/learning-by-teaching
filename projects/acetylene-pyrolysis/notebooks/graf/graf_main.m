% Below we define an integration manager. As we need to integrate the same problem
% under several conditions it is also interesting to provide such a function with
% the initialization and output provided in a standard way. Here we make use of
% [LSODE](https://computing.llnl.gov/casc/nsde/pubs/u113855.pdf) to perform system
% integration. Notice that several options were set with `lsode_options` and you
% might want to tweak them in other scenarios.

%graphics_toolkit("fltk");
%graphics_toolkit("gnuplot");
graphics_toolkit("qt");

h = graf_integrate(5.0e+03, 1073.0, 0.36, 1.4, 100);
%h = graf_integrate(5.0e+03, 1173.0, 0.36, 1.4, 100);
%h = graf_integrate(5.0e+03, 1273.0, 0.36, 1.4, 100);
%h = graf_integrate(1.0e+04, 1173.0, 0.36, 2.5, 100);
