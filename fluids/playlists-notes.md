# Fluids notes

## Reynolds-Averaged Navier-Stokes (RANS)

Based on [playlist by Fluid Mechanics 101](https://www.youtube.com/playlist?list=PLnJ8lIgfDbkrNyps1_36tNRRQ7hLzPFhV)

![Eddy Viscosity Models for RANS and LES](https://www.youtube.com/watch?v=SVYXNICeNWA&list=PLnJ8lIgfDbkrNyps1_36tNRRQ7hLzPFhV&index=1)


![The k - epsilon Turbulence Model](https://www.youtube.com/watch?v=fOB91zQ7HJU&list=PLnJ8lIgfDbkrNyps1_36tNRRQ7hLzPFhV&index=2)


![The k - omega SST Turbulence Model](https://www.youtube.com/watch?v=myv-ityFnS4&list=PLnJ8lIgfDbkrNyps1_36tNRRQ7hLzPFhV&index=3)


![The k-omega Turbulence Model](https://www.youtube.com/watch?v=26QaCK6wDp8&list=PLnJ8lIgfDbkrNyps1_36tNRRQ7hLzPFhV&index=4)


![The Spalart-Allmaras Turbulence Model](https://www.youtube.com/watch?v=Xivc0EIGFQw&list=PLnJ8lIgfDbkrNyps1_36tNRRQ7hLzPFhV&index=5)


![The Transition SST (gamma - Re_theta) model](https://www.youtube.com/watch?v=5htknS9uVEk&list=PLnJ8lIgfDbkrNyps1_36tNRRQ7hLzPFhV&index=6)


![Turbulence Intensity for RANS](https://www.youtube.com/watch?v=Xr7BzHImL68&list=PLnJ8lIgfDbkrNyps1_36tNRRQ7hLzPFhV&index=7)


## Large Eddy Simulation (LES)

Based on [playlist by Fluid Mechanics 101](https://www.youtube.com/playlist?list=PLnJ8lIgfDbkoPrNWatlYdROiPrRU4XeUA). The goal of this series is to provide a rather practical set of considerations about LES practical, theoretical aspects being discussed elsewhere.

![Large Eddy Simulation (LES): An Introduction](https://www.youtube.com/watch?v=r5vP45_6fB4&list=PLnJ8lIgfDbkoPrNWatlYdROiPrRU4XeUA&index=1)

- A minimum of 4 neighbor cells is required to roughly resolve an eddy.

- Large eddies are resolved through fine meshing; smaller ones use sub-grid models.

- Consider resolving at least 80% of local turbulent (eddy) energy in LES.

- Always run a RANS version of the case before converting it into LES.

- Using $k-\epsilon$ or $k-\omega$ values one can estimate the integral length scale $l_0$ (in the following equation $k$ is the wavenumber, not turbulent kinetic energy!)

$$
l_0 = \dfrac{\displaystyle\int_0^\infty k^{-1}E(k)dk}{\displaystyle\int_0^\infty E(k)dk}
$$

- In terms of $k$, $\epsilon$, or $\omega$ this can be estimated as:

$$
l_0 = \dfrac{k^{3/2}}{\epsilon} = \dfrac{k^{1/2}}{C_\mu\omega}
$$

- The cell length can then be set locally to $d=l_0/5$ to resolve ~80% of the eddies.

- In postprocessing RANS preliminary results one can compute the following quantity in terms of cell volume $V$ to identify regions where cells are too big for proper resolution of large eddies:

$$
f = \dfrac{l_0}{V^{1/3}} (\ge 5)
$$

![Large Eddy Simulation (LES) 2: Turbulent Kinetic Energy](https://www.youtube.com/watch?v=QKDFTCUh7zU&list=PLnJ8lIgfDbkoPrNWatlYdROiPrRU4XeUA&index=2)


![Large Eddy Simulation (LES) 3: Sub-Grid Modelling](https://www.youtube.com/watch?v=N81Io_yrOQU&list=PLnJ8lIgfDbkoPrNWatlYdROiPrRU4XeUA&index=3)


![Eddy Viscosity Models for RANS and LES](https://www.youtube.com/watch?v=SVYXNICeNWA&list=PLnJ8lIgfDbkoPrNWatlYdROiPrRU4XeUA&index=4)


![The Smagorinsky Turbulence Model (Part 1)](https://www.youtube.com/watch?v=V8ydRrdCzl0&list=PLnJ8lIgfDbkoPrNWatlYdROiPrRU4XeUA&index=5)


![The Smagorinsky Turbulence Model (Part 2)](https://www.youtube.com/watch?v=GdXLyfRK188&list=PLnJ8lIgfDbkoPrNWatlYdROiPrRU4XeUA&index=6)
