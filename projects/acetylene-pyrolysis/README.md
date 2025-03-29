# Acetylene pyrolysis


This project provides and analysis of acetylene kinetics and its simulation under conditions relevant to gas carburizing of steel. This is treated with both a detailed kinetic mechanism by [@Norinaga2009] and its directed relational graph (DRG) simplification proposed in my [PhD thesis](http://docnum.univ-lorraine.fr/public/DDOC_T_2017_0158_DAL_MAZ_SILVA.pdf) (Chapter 5). Simulations are carried both under plug-flow conditions (1-D) and under real reactor (3-D axisymmetric) geometry. All cases are validated experimentally and data is made available for verification.

The kinetics mechanisms used in this study are provided in different formats at:

- [DRG skeletal mechanism tested in this work](https://github.com/wallytutor/learning-by-teaching/tree/main/references/kinetics/dalmazsi_2017_sk41)
- [Norinaga's reference detailed mechanism](https://github.com/wallytutor/learning-by-teaching/tree/main/references/kinetics/norinaga_2009)


## Global environment setup

- Launch `julia`, activate and instantiate the project available in this repository.

- From Julia's REPL run `using IJulia; IJulia.jupyterlab()` to launch Jupyterlab for the first time

- In Jupyterlab, activate the extensions and install Jupytext (required to edit plain-text notebooks).

- You will be prompted to restart Jupyterlab, so back to REPL, kill the server with `Ctrl+C` and run it again.

Everything should be fine by here to manage the project through the notebook.

```julia
using CairoMakie
```
