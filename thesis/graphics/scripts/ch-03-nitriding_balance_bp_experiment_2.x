#!/bin/bash

gnuplot <<- EOF
set loadpath "${HOME}/root/cfg/gnuplot"
load "pgfmt12x12y.cfg"
load "xyborder.cfg"
load "fontfmtphv30.cfg"
set output "$(pwd)/fig.tex"
set decimalsign ','
set xlabel "Temps (s)"
set ylabel "Fraction molaire -- x / Taux de conversion -- \$\\\alpha\$"
set format '$%g$'
set xrange [0.0:10000.0]
set yrange [0.2:0.45]
set format y "{%.2f}"
set format x "{%.0f}"
set ytics offset -1.5,0.2
unset y2tic
unset x2tic
set style line 100 lc rgb '#000000' dashtype 1 lw 1.0 pt 4
set style line 200 lc rgb '#000000' dashtype 2 lw 1.0 pt 5
set style line 300 lc rgb '#000000' dashtype 3 lw 1.0 pt 6
set style line 400 lc rgb '#000000' dashtype 3 lw 1.0 pt 7
set style line 110 lc rgb '#000000' dashtype 1 lw 4.0 pt 4
set style data points

PLOT="../../../experimental/balance_experiment_2.dat"
MODL="../../../balances/experiment2.dat"

set label "\\\Large{}x(\\\ch{NH3})" at 6200,0.410  rotate by 0
set label "\\\Large{}x(\\\ch{N2})"  at 2100,0.392 rotate by -2
set label "\\\Large{}x(\\\ch{H2})"  at 2400,0.260  rotate by -28
set label "\\\LARGE{}\$\\\alpha\$"  at 2400,0.320  rotate by -28

plot PLOT using 1:4 ls 100 notitle,\
     PLOT using 1:6 ls 200 notitle,\
     PLOT using 1:5 ls 300 notitle,\
     PLOT using 1:3 ls 400 notitle,\
     MODL using 6:3 w lines ls 110 notitle,\
     MODL using 6:2 w lines ls 110 notitle,\
     MODL using 6:1 w lines ls 110 notitle,\
     MODL using 6:4 w lines ls 110 notitle
EOF

compile_figure.sh
