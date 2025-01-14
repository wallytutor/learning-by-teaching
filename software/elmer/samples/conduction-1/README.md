# How to interpret symmetries in Elmer?

## Setup case in Elmer GUI

The `concept` case is created with Elmer GUI to get the base operating version of SIF file. This is essentially the 2D case since it is conceived with its mesh.

- File > Open > *select 2D mesh file*
- File > Definitions > Append > *fluxsolver.xml*
- File > Definitions > Append > *saveline.xml*
- File > Save Project > *navigate to concept directory*

Now on the object tree:

- Expand `Body`:
    - Open `Body Property 1`, rename it `Hollow Cylinder`

- Equation > [Add...]:
    - Rename it `Model`
    - Apply to bodies: check `Hollow Cylinder`
    - Check `Active` in tabs:
        - `Heat equation`
        - `Flux and Gradient`
        - `SaveLine`

- Edit Solver Settings in `Model` tab `Flux and Gradient`:
    - Tab `Solver specific options`:
        - Target Variable `Temperature`
        - Flux Coefficient `Heat Conductivity`
        - Check `Calculate Flux`
    - Tab `General`:
        - Execute solver `After timestep`

- Edit Solver Settings in `Model` tab `SaveLine`:
    - Tab `Solver specific options`:
        - Polyline Coordinates `Size(2, 2);  0.005 0.025  0.100 0.025`
        - Polyline Divisions `25`
    - Tab `General`:
        - Execute solver `After simulation`

- Material > [Add...]:
    - Rename it `Solid`
    - Apply to bodies: check `Hollow Cylinder`
    - Density `3000`
    - Heat Capacity `1000`
    - Tab `Heat equation`:
        - Heat Conductivity `10`

- Initial condition > [Add...]:
    - Rename it `Initial Temperature`
    - Apply to bodies: check `Hollow Cylinder`
    - Tab `Heat equation`:
        - Temperature `1000`

- Boundary condition > [Add...]:
    - Rename it `Hole`
    - Apply to boundaries: check `Boundary 1`
    - Tab `Heat equation`:
        - Heat Flux `0`

- Boundary condition > [Add...]:
    - Rename it `Ends`
    - Apply to boundaries: check `Boundary 3`
    - Tab `Heat equation`:
        - Heat Flux `0`

- Boundary condition > [Add...]:
    - Rename it `Environment`
    - Apply to boundaries: check `Boundary 2`
    - Tab `Heat equation`:
        - Heat Transfer Coeff. `10`
        - External Temperature `300`

Now save, generate, and run for testing. Back to menu `Model > Setup...`:

- Results directory `results`
- Coordinate system `Axi Symmetric`
- Simulation type `Transient`
- Output intervals `10`
- Timestep intervals `120`
- Timestep sizes `10`

Now save, generate, and run, it should be up and running!

## Preparation of other cases

As stated before, the case set up through the GUI is essentially the 2D case we wish to prepare. Input (SIF) file generated during concept was moved to the root of [2d/](2d/) directory and a script was added for automation.

For setting up 3D case we first load the new mesh in a new session of Elmer GUI with the purpose of verifying the mapping of boundary conditions. Next the SIF file is copied to the [3d/](3d/) directory and a new zero flux `Symmetry` condition is added for the wedge sides - since they were not present in axisymmetric case. Also notice that coordinate system is now cartesian because the geometry is resolved in 3D.

## Post-processing

## Conclusions
