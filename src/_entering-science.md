
# Science

## Optimisation

Based on [Bierlaire (2015) Optimization: principles and algorithms](https://transp-or.epfl.ch/books/optimization/html/about.html) and the professors channel [Michel Bierlaire - YouTube](https://www.youtube.com/@MichelBierlaire/videos).

## Linear algebra

- [Advanced LAFF - YouTube](https://www.youtube.com/@advancedlaff6453/playlists)

### Condition number

General definition:

$$
\kappa(A)=\lVert{A}\rVert\cdotp\lVert{A}\rVert^{-1}
$$

Symmetric positive definite:

$$
\kappa(A)=\frac{\max\lambda}{\min\lambda}
$$

## Controls

### Concepts

- Lyapunov method
- Stability
- Passivity
- Observers
- Perturbation theory
- Gain scheduling
- Integral control
- Feedback linearization
- Sliding model control
- Backstepping
- State variable: the *memory* a dynamical system has from its past.
- State equation $\dot{x}=f(t, x, u)$
- Output equation $y=h(t, x, u)$
- State equation and output equation form the space-state model.

## Mechanics

### Goldstein Chapter 1

#### Derivations

- Proof 1:

**Part 1** For a fixed mass particle, show that:

$$
\dfrac{dT}{dt}=\mathbf{F}\cdotp\mathbf{v}
$$

By expanding the derivative in terms of the definition of $T$ and rearranging:

$$
\dfrac{1}{2}m\dfrac{d(\mathbf{v}\cdotp\mathbf{v})}{dt}=%
\dfrac{1}{2}m\left(2\mathbf{v}\dfrac{d\mathbf{v}}{dt}\right)=%
m\dfrac{d\mathbf{v}}{dt}\cdotp{}\mathbf{v}=\mathbf{F}\cdotp\mathbf{v}
$$

**Part 2** Assuming a variable mass particle, show that:

$$
\dfrac{d(mT)}{dt}=\mathbf{F}\cdotp\mathbf{p}
$$

Expressing $T$ in terms of linear momentum $\mathbf{p}$ and expanding leads to the result:

$$
\dfrac{d}{dt}\left(m\dfrac{\mathbf{p}\cdotp\mathbf{p}}{2m}\right)=%
\mathbf{p}\cdotp\dot{\mathbf{p}}=\mathbf{F}\cdotp\mathbf{p}
$$

## Thermodynamics

*Upcoming...*

## Kinetics

*Upcoming...*

## Turbulence

In the 1970's [Launder and Spalding](https://doi.org/10.1016/0045-7825\(74\)90029-2) [@Launder1974] questioned the reason why at their time computer programs available for fluid dynamics did not *do full justice* to it, although numerical methods were already advanced enough; with the computing limitations at the time, resolving eddies of the order of a millimeter in flows that easily make a few meters could be a first explanation. Turbulence models completed Navier-Stokes equations to approximate the behavior of real fluids, but an universal (*solve a broad range of turbulent flows*) and low complexity (*a few differential equations, limited need of empirical data and closure functions*) turbulence model was not readily available; choices needed to be done regarding th chose of equations, and difficulties regarding the identification of experimental parameters needed to be overcome. Under this context they [@Launder1974] proposed $k-\epsilon$ model for solving the turbulent kinetic energy $k$ and its dissipation rate $\epsilon$ with emphasis on near-wall phenomena.

$$
k = \dfrac{1}{2}\overline{u_iu_i}
\qquad
\epsilon = \nu\overline{
	\dfrac{\partial{}u_i}{\partial{}x_k}
	\dfrac{\partial{}u_i}{\partial{}x_k}}
\qquad
l = C_D\dfrac{k^{3/2}}{\epsilon}
$$

Effective turbulent viscosity:

$$
\mu_t = C_\mu\rho{}k^{1/2}l =
        C_\mu\rho{}\dfrac{k^2}{\epsilon}
$$

### Reynolds-Averaged Navier-Stokes (RANS)

Based on [playlist by Fluid Mechanics 101](https://www.youtube.com/playlist?list=PLnJ8lIgfDbkrNyps1_36tNRRQ7hLzPFhV)

<!-- ![Eddy Viscosity Models for RANS and LES](https://www.youtube.com/watch?v=SVYXNICeNWA&list=PLnJ8lIgfDbkrNyps1_36tNRRQ7hLzPFhV&index=1) -->


<!-- ![The k - epsilon Turbulence Model](https://www.youtube.com/watch?v=fOB91zQ7HJU&list=PLnJ8lIgfDbkrNyps1_36tNRRQ7hLzPFhV&index=2) -->


<!-- ![The k - omega SST Turbulence Model](https://www.youtube.com/watch?v=myv-ityFnS4&list=PLnJ8lIgfDbkrNyps1_36tNRRQ7hLzPFhV&index=3) -->


<!-- ![The k-omega Turbulence Model](https://www.youtube.com/watch?v=26QaCK6wDp8&list=PLnJ8lIgfDbkrNyps1_36tNRRQ7hLzPFhV&index=4) -->


<!-- ![The Spalart-Allmaras Turbulence Model](https://www.youtube.com/watch?v=Xivc0EIGFQw&list=PLnJ8lIgfDbkrNyps1_36tNRRQ7hLzPFhV&index=5) -->


<!-- ![The Transition SST (gamma - Re_theta) model](https://www.youtube.com/watch?v=5htknS9uVEk&list=PLnJ8lIgfDbkrNyps1_36tNRRQ7hLzPFhV&index=6) -->


<!-- ![Turbulence Intensity for RANS](https://www.youtube.com/watch?v=Xr7BzHImL68&list=PLnJ8lIgfDbkrNyps1_36tNRRQ7hLzPFhV&index=7) -->


### Large Eddy Simulation (LES)

Based on [playlist by Fluid Mechanics 101](https://www.youtube.com/playlist?list=PLnJ8lIgfDbkoPrNWatlYdROiPrRU4XeUA). The goal of this series is to provide a rather practical set of considerations about LES practical, theoretical aspects being discussed elsewhere.

<!-- ![Large Eddy Simulation (LES): An Introduction](https://www.youtube.com/watch?v=r5vP45_6fB4&list=PLnJ8lIgfDbkoPrNWatlYdROiPrRU4XeUA&index=1) -->

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

<!-- ![Large Eddy Simulation (LES) 2: Turbulent Kinetic Energy](https://www.youtube.com/watch?v=QKDFTCUh7zU&list=PLnJ8lIgfDbkoPrNWatlYdROiPrRU4XeUA&index=2) -->

- Time average point probes in regions where a statistical steady state is achieved.

- Compute mean flow field $\bar{U}$ from instantaneous data then use its value over the domain to evaluate the fluctuating velocity $u^\prime=U-\bar{U}$ to later compute $k$ (turbulent kinetic energy).

- The normal components of Reynolds-stress tensor (its trace) adds up to form $k$.

- In OpenFOAM the Reynolds stress tensor is computed as `uPrime2Mean` in units of $m^2/s^2$ while Ansys Fluent will compute RMSE velocities to give units of $m/s$, so values need to be squared to compute $k$!


<!-- ![Large Eddy Simulation (LES) 3: Sub-Grid Modelling](https://www.youtube.com/watch?v=N81Io_yrOQU&list=PLnJ8lIgfDbkoPrNWatlYdROiPrRU4XeUA&index=3) -->


<!-- ![Eddy Viscosity Models for RANS and LES](https://www.youtube.com/watch?v=SVYXNICeNWA&list=PLnJ8lIgfDbkoPrNWatlYdROiPrRU4XeUA&index=4) -->


<!-- ![The Smagorinsky Turbulence Model (Part 1)](https://www.youtube.com/watch?v=V8ydRrdCzl0&list=PLnJ8lIgfDbkoPrNWatlYdROiPrRU4XeUA&index=5) -->


<!-- ![The Smagorinsky Turbulence Model (Part 2)](https://www.youtube.com/watch?v=GdXLyfRK188&list=PLnJ8lIgfDbkoPrNWatlYdROiPrRU4XeUA&index=6) -->

## Combustion

### Fundamentals

The science of combustion is complex by its intrinsic nature; it requires (at least) elements from fluid dynamics, thermodynamics, chemical kinetics, and radiation. An overview on how these fields of knowledge intertwine is presented in the work by Warnatz [@Warnatz2006].

Different approaches are possible depending on the level of description required for a given process; the chemist might be interested in detailed kinetics [@Kee2017] to be able to describe the spatial distribution of species and pathways, which might be sensitive to the operating conditions and initial compositions; to achieve that level of description, an important experimental and *ab initio* calculations workload is often required [@Henriksen2008] and has been carried over many years for systems of practical interest. These efforts led to the conception of detailed mechanisms such as GRI-Mech [@Smith1999] and many others of higher level of complexity.

On the other hand, the process engineer often might find a global approach to respond to their needs knowing that probably only energy output will be right in the calculations. Some workers [@Westbrook1981] have studied means of keeping the released energy consistent while also representing flame-speeds in relative agreement with those predicted by detailed kinetics. We will come back to that point in practical scenarios. To that end, one might rely in the empirical fuel approaches introduced in Chapter 31 by Gyftopoulos [@Gyftopoulos2005], which ensures at least thermodynamic consistency; this allows for further simplifications as *practical* species may be used to represent the fuel composition, reducing the number of equations to be solved in simulations.

In a complex flow scenario, chemical kinetics might alone not be enough to describe combustion; in some cases the rate of turbulent mixing might block the fuel from reaching the oxidizer and thus finite-rate laws can non-longer be followed. To overcome this difficulty in RANS simulations, approaches such as the eddy-dissipation model [@Magnussen1977] were proposed and later improved to better represent the scales of combustion. When time resolution of scales is important as in LES simulations, other measures might be required when tuning the mechanism, as discussed by Franzelli [@Franzelli2012].

Finally, one must keep in mind that in most cases combustion flue gases behave as participating media and strongly influence the results; omitting their contribution (and that of soot) is a serious mistake that is commonplace in CFD practice. This is thoroughly discussed in the work by Modest [@Modest2016]. Again, different levels of representation are possible; not to be exhaustive, one might evaluate fluid properties with a narrow band model such as Radcal [@Grosshandler1993] or apply global approaches as the weighted-sum-of-gray-gases (WSGG) [@Hottel1967] or some of its later improvements not treated here.

### Energy sources

#### Natural gas

#### Hydrogen

#### Bio-matter

### Environmental aspects

#### NOx formation

These notes are mostly based on Warnatz [@Warnatz2006], except where mentioned otherwise.

Four different possible routes:

1. Thermal route (Zeldovich mechanism) at high temperatures; assumes steady state concentration of atomic nitrogen to simplify the rate law of NO formation. The required atomic oxygen concentration can be estimated from *partial-equilibrium* evaluated from $H_2$,, $O_2$, and $H_2O$ in the flame front. This is valid only above 1700 K, but this is no problem because the limiting rate constant in Zeldovich mechanism is very low at this level of temperatures.

2. Prompt route (Fenimore mechanism), accounts for the role of $CH$ radicals in downstream side of flame front; it is favored in rich flames which accumulate acetylene due to $CH_3$ recombination, a precursor for $CH$ radicals. Its production can be important at temperatures as low as 1000 K.

3. Nitrous oxide route

4. Conversion of fuel nitrogen

### Theoretical and Numerical Combustion

Study notes from the book by [@Poinsot2022TNC] and complementary information from their [web page](https://elearning.cerfacs.fr/combustion/index.php). The main motivations for studying combustion is that it is and will still be the main source of energy for humankind. Given its complexity, we cannot tackle all of its intricacies without recurring to simulation. Nevertheless, simulation alone without the minimal theory background is dangerous. With the current available computing power, a transition towards more compute-intensive _LES_ approaches is replacing classical _RANS_, even in situations where steady treatment has been long the standard. It is thus necessary to understand the numerical aspects of the more powerful and detailed transient models, a matter that will progressively be treated here. A foreword and motivation for delving into the subject is provided [in this video](https://elearning.cerfacs.fr/combustion/n7masterCourses/introduction/index.php).

Resources:

- [Full playlist by Professor T. Poinsot available](https://www.youtube.com/playlist?list=PLbInEHTmP9VYr0vcMrXm93vs9uj5BZ5Es).
- [Cerfacs eLearning - Portal](https://cerfacs.fr/elearning/)
- [Cerfacs eLearning - Combustion index](https://elearning.cerfacs.fr/combustion/index.php)
- [Cerfacs eLearning - Fail CFD](https://elearning.cerfacs.fr/advices/poinsot/cfd/index.php)

<!-- ![Theoretical And Numerical Combustion, Poinsot, Day 1](https://www.youtube.com/watch?v=RzfWLuyOBkg&list=PLbInEHTmP9VYr0vcMrXm93vs9uj5BZ5Es&index=1) -->

*Add notes for following videos...*

#### Chapter 1

Combustion science adds a set of conservation equations for species (and the implications they introduce) in non-isothermal flows, as these must be solved for individually. Thermodynamic data also becomes considerably more complex as specific heat of mixtures often change importantly across the flow. Because it is simpler to think about mass fractions $Y_k$ when coupling species to energy and momentum equations, it is the variable of choice for species equations; these are associated to partial pressures $p_k$ and the ideal gas state equation writes

$$
\rho_k = \frac{p_kW_k}{RT}
\:,
\quad%
\sum{}p_k=p
\quad\text{and}\quad%
W = \left(\sum\frac{Y_k}{W_k}\right)^{-1}
\implies
\rho = \frac{pW}{RT}
$$

Because specific heat varies, it is often th case that combustion codes treat the effect of this *sensible* enthalpy or energy (the contribution of temperature change) together with the effects of reaction, introducing a *chemical* enthalpy. Since we adopt a mass fraction basis, these properties are *mass enthalpies* and care must be taken when retrieving data from the literature. The formation enthalpy of species $\Delta{}h_{f,k}^\circ$ is often reported at $T_\circ=298\:K$ because of how experiments are carried, rather than the more logical absolute zero reference frame. The total *enthalpy* writes

$$
h_k = \Delta{}h_{f,k}^\circ + \displaystyle\int_{T_\circ}^{T}C_{p,k}dT
\quad\text{and}\quad
h = \displaystyle\sum_{k}^{N_{spec}}Y_kh_k
\implies
C_{p} = \sum_{k}^{N_{spec}}C_{p,k}Y_{k}
$$

where by definition the sensible contribution at $T=T_\circ$ is zero. The table below summarizes the forms of energy representation; it must be emphasized that most compressible codes use $E$ and $H$ definitions for non-reacting flows.

| Quantity             | Energy                                               | Enthalpy                              |
| -------------------- | ---------------------------------------------------- | ------------------------------------- |
| Sensible (species)   | $e_{s,k}=\int_{T_\circ}^{T}C_{v,k}dT - RT_\circ/W_s$ | $h_{s,k}=\int_{T_\circ}^{T}C_{p,k}dT$ |
| Total (species)      | $e_k=e_{s,k}+\Delta{}h_{f,k}^\circ$                  | $h_k=h_{s,k}+\Delta{}h_{f,k}^\circ$   |
| Sensible (mixture)   | $e_s=\int_{T_\circ}^{T}C_{v}dT - RT_\circ/W$         | $h_{s}=\int_{T_\circ}^{T}C_{p}dT$     |
| Total (mixture)      | $e = \sum_{k}^{N_{spec}}e_{k}Y_{k}$                  | $h = \sum_{k}^{N_{spec}}h_{k}Y_{k}$   |
| Total (non-chemical) | $E = e_{s} + \frac{1}{2}u_iu_i$                      | $H = h_{s} + \frac{1}{2}u_iu_i$       |
The viscous and pressure tensors are given by

$$
\tau_{ij} =
-2\mu\frac{\partial{}u_k}{\partial{}x_k}\delta_{ij}
+\mu\left(
    \frac{\partial{}u_i}{\partial{}x_j}
    +\frac{\partial{}u_j}{\partial{}x_i}
\right)
\quad{},\quad
p_{ij}=-p\delta_{ij}
\quad\text{and}\quad
\sigma_{ij}=\tau_{ij}+p_{ij}
$$

Important dimensionless numbers in combustion include [Lewis](https://en.wikipedia.org/wiki/Lewis_number) and [Prandtl](https://en.wikipedia.org/wiki/Prandtl_number) numbers. They are often related through the [Schmidt](https://en.wikipedia.org/wiki/Schmidt_number) number.

$$
\mathcal{Le}_k=\frac{\alpha}{D_k}=\frac{\lambda}{\rho{}C_pD_k}
\quad\text{and}\quad
\mathcal{Pr}=\frac{\nu}{\alpha}=\frac{\mu{}C_p}{\lambda}
\quad\text{and}\quad
\mathcal{Sc}_k=\frac{\nu}{D_k}=\mathcal{Pr}\mathcal{Le}_k
$$

Notice that the above definition of Lewis number is already simplified, as one takes the mixture averaged diffusion coefficient $D_k$ of a species; this is done by most diffusion codes as solving full-multicomponent diffusion is a problem in itself. This fallback to Fick's law will be further discussed in what follows. This number is important in laminar flames, as it compares the diffusion speeds of heat and species. It can be shown to be roughly constant through kinetic theory analysis.

For the chemical source terms, often one adopts a mass action kinetics approach; through elemental mass balance in individual equations and different formalisms for representation of reaction rates the rates of progress of a given species can be computed. The most popular kinetics rate representation formalism is expressed as Arrhenius rate laws; among the formats, kinetic mechanisms are often stored in CHEMKIN format. Because of the broad range of activation energies appearing in Arrhenius expressions, kinetic mechanisms are often stiff, what imply time-steps and meshes in reacting flows that are much smaller/finer than the pure fluid dynamics counterparts.

| Quantity             | Domain           | Definition                                                                    |
| -------------------- | ---------------- | ----------------------------------------------------------------------------- |
| Stoichiometric ratio | Any              | $s = \left(\dfrac{Y_O}{Y_F}\right)_{st}=\dfrac{v^\prime_OW_O}{v^\prime_FW_F}$ |
| Equivalence ratio    | Premixed flames  | $\phi=s\dfrac{Y_F}{Y_O}=s\dfrac{\dot{m}_F}{\dot{m}_O}$                        |
| Equivalence ratio    | Diffusion flames | $\phi=s\dfrac{Y_F^1}{Y_O^2}$                                                  |
| Equivalence ratio    | Diffusion flames | $\phi_g=s\dfrac{\dot{m}_F^1}{\dot{m}_O^2}=\phi\dfrac{\dot{m}^1}{\dot{m}^2}$   |

Topics to finish:

- Conservation of momentum
- Conservation of mass and species
- Hirschfelder and Curtiss approximation
- Conservation of energy

Exercises:

- [ ] Derive viscous stress tensor.
- [ ] Explain the concept of *bulk viscosity*.
- [ ] Program a full multicomponent diffusion program.
- [ ] Review Soret and Dufour effects.

Additional materials for following this chapter:

- [Adiabatic flame temperature](https://elearning.cerfacs.fr/combustion/n7masterCourses/adiabaticflametemperature/index.php)
- [Conservation equations - part 1](https://elearning.cerfacs.fr/combustion/n7masterCourses/conservationequations/index.php)
- [Conservation equations - part 2](https://elearning.cerfacs.fr/combustion/n7masterCourses/conservationequationsP2/index.php)
- Appendices of [@Williams1985]

#### Chapter 2

#### Chapter 3

#### Chapter 4

#### Chapter 5

#### Chapter 6

#### Chapter 7

#### Chapter 8

#### Chapter 9

#### Chapter 10

#### Going further

- [@Hirschfelder1969]

## Research

### Calcite particles decomposition

- According to [@Scaltsoyiannes2020], calcium-looping (CaL) can also be used for energy storage in concentrated solar power plants.

- Types of models listed by [@Scaltsoyiannes2020]:

    - Shrinking core model (SCM), only external surface participates at mass exchange.
    - Random pore model (RPM), randomly distributed cylindrical pores for exchange.
    - Grain model (GM), pores are voids in between solid grains.
    - Uniform conversion model (UCM).

- [Tammann](https://en.wikipedia.org/wiki/Tammann_and_H%C3%BCttig_temperatures) temperature of $CaCO_3$ is low, so sintering phenomena cannot be neglected.

- Flow rate and $CO_2$ partial pressure do not affect the $CaCO_3$ decomposition kinetics in the range of conditions studied by [@Scaltsoyiannes2020]; on the other hand, decreasing particle size from 500 to 100 $\mu{}m$ increases reaction rate, while below this value the internal resistance of mass transfer is negligible and rates no longer increase.

### Thermocline

This note compiles a few elements on the modeling of heat transfer in packed beds. It focuses on classical implementations that can be simultaneously used in systems design that are also available in typical CFD software packages. Most of the elements compiled here are also discussed by [@Gidaspow1994] and [@Bird2001].

**Important:** this is a work in progress and might change as review goes on.

#### Pressure drop

Early studies on pressure drop across packed columns have been performed by [@Ergun1952]; the final form equation is presented below, where the first term represents the viscous losses while the second includes kinetic energy (turbulence) effects.

$$
\dfrac{\Delta{}P}{L}g_c=%
150\dfrac{(1-\epsilon)^2}{\epsilon^3}\dfrac{\mu{}U_m}{D_p^2}+%
1.75\dfrac{(1-\epsilon)}{\epsilon^3}\dfrac{G{}U_m}{D_p}
$$

For ease of numerical implementation the following format is more convenient:

$$
\dfrac{\Delta{}P}{L}g_c=%
\dfrac{U_m}{D_p}\dfrac{(1-\epsilon)}{\epsilon^3}
\left[\dfrac{150\mu(1-\epsilon)}{D_p}+1.75G\right]
$$

where $G=\rho{}U_m$ represents the mass flow rate, $D_p$ the characteristic dimension (which can be estimated from the specific surface $S_v$ for spheres as $D_p=6S_v^{-1}$), $\epsilon$ is the fractional void volume (porosity) of the bed, $\mu$ is the fluid absolute viscosity, and $U_m$ the superficial fluid velocity measured at average pressure. This equation is interesting because it covers both the Blake-Kozeny and Burke-Plummer validity ranges.

Although the author rigorously treats the empirical data, he leaves little explanation regarding its practical use; hopefully [@Gidaspow1994] (section 2.3) reintroduces the above formulation complemented by later advances leading to

$$
\dfrac{\Delta{}P}{L}=%
150\dfrac{(1-\epsilon)^2}{\epsilon^3}\dfrac{\mu_g{}U_0}{(\phi_s{}d_p)^2}+%
1.75\dfrac{(1-\epsilon)}{\epsilon^3}\dfrac{\rho_g{}U_0^2}{\phi_s{}d_p}
$$

where the surface velocity is computed from the mean relative velocity as $U_0=\epsilon{}U$ and $\phi_s$ is the sphericity of the solid particles. Further clarifications can be found in [@Bird2001] (section 6.4).

Naturally, for non isotherm systems it is necessary to treat the problem numerically as the velocity will rely on the state-equation chosen to represent the gas phase.

#### Heat transfer coefficient

In the case of on convective heat transfer coefficient determination, the classical work by [@Gunn1978] is often used as a starting point for both packed and fluidized beds. It deals mostly with the dependency of Nusselt group on Reynolds group for granular media. The recommended relationship covering a broad range of conditions is:

$$
\mathcal{Nu}=\dfrac{hd}{\lambda}=%
(7-10e+5e^2)(1+0.7\mathcal{Re}^{0.2}\mathcal{Pr}^{1/3}) +%
(1.33-2.4e+1.2e^2)\mathcal{Re}^{0.7}\mathcal{Pr}^{1/3}
$$

where $e$ denotes the porosity of the bed and the characteristic length used in Reynolds group $\mathcal{Re}$ is also particle diameter $d$, similarly to Nusselt group definition. For calculation of the heat transfer coefficient the following set of expressions is simpler to implement:

$$
\begin{aligned}
h &= \dfrac{\lambda}{d}\left[
p_1+(0.7p_1\mathcal{Re}^{-0.5}+p_2)\mathcal{Re}^{0.7}\mathcal{Pr}^{1/3}
\right]\\[6pt]
%
p_1 &= 7-10e+5e^2\\[6pt]
p_2 &= 1.33-2.4e+1.2e^2
\end{aligned}
$$

Alternatively, [@Bird2001] (section 14.5) provides

$$
\begin{aligned}
h &= c_pG_0\left(\dfrac{c_p\mu}{k}\right)^{-2/3}\left[
    2.19\mathcal{Re}^{-2/3}+0.78\mathcal{Re}^{-0.381}
    \right]\\[6pt]
\mathcal{Re} &= \dfrac{D_pG_0}{(1-\epsilon)\mu\psi}=\dfrac{6G_0}{d_p\mu\psi}
\end{aligned}
$$

where properties are evaluated at film temperature, $G_0=wS^{-1}$ is the superficial mass flux (with $w$ the mass flow rate and $S$ the column empty cross-section); $\psi$ is a particle-shape factor with defined value 1 for spheres and fitted to 0.92 for cylindrical pellets.

## List of goals

### Courses

- [Thermodynamics & Kinetics](https://ocw.mit.edu/courses/5-60-thermodynamics-kinetics-spring-2008/)
- [Thermodynamics and Kinetics of Materials](https://ocw.mit.edu/courses/3-205-thermodynamics-and-kinetics-of-materials-fall-2006/)
- [Chemical Engineering Thermodynamics](https://ocw.mit.edu/courses/10-40-chemical-engineering-thermodynamics-fall-2003/)
- [Statistical Thermodynamics of Complex Liquids](https://ocw.mit.edu/courses/22-52j-statistical-thermodynamics-of-complex-liquids-spring-2004/)
- [Atmospheric Radiation](https://ocw.mit.edu/courses/12-815-atmospheric-radiation-fall-2008/)
- [Atomistic Computer Modeling of Materials (SMA 5107)](https://ocw.mit.edu/courses/3-320-atomistic-computer-modeling-of-materials-sma-5107-spring-2005/)
- [Advanced Thermodynamics](https://ocw.mit.edu/courses/2-43-advanced-thermodynamics-spring-2024/)

### YouTube

- [Física Teórica 1: Práctica 03 - Repaso de magnetostática y superposición](https://www.youtube.com/playlist?list=PLNbPNPgqTfs775EqwHWuCxGrhtBXcgeDZ)
- [Física Teórica 2: Clase 1a: Formalismo matemático de la Mecánica Cuántica](https://www.youtube.com/playlist?list=PLNbPNPgqTfs6xC_UJkGbHI3slKMtDxoY7)
- [Física Teórica 3: Guía 1, clase 1](https://www.youtube.com/playlist?list=PLNbPNPgqTfs7ze8rT3kMZcHM9ZyehbB-4)

### Software

- [trame](https://kitware.github.io/trame/)

### Tutorials

- Create an OpenFOAM case illustrating [this](https://innovationspace.ansys.com/knowledge/forums/topic/in-ansys-fluent-when-the-energy-equation-is-enabled-and-viscous-heating-is-enabled-must-pressure-work-also-be-turned-on/) effect.
- Get inspiration [here](https://cooperrc.github.io/computational-mechanics/README.html) for some Julia tutorials.
- [Molecular dynamics — Molecular Dynamics Simulations](https://mejk.github.io/moldy/intro.html)
- Review turbulence models: [Use of k-epsilon and k-omega Models](https://www.cfd-online.com/Forums/main/75554-use-k-epsilon-k-omega-models.html)

## Course *Thermodynamics and Phase Equilibria*

Notes taken while following this [course](https://learning.edx.org/course/course-v1:StanfordOnline+SOE.XMATSCI0001+1T2020/home) by [Alberto Salleo](https://profiles.stanford.edu/alberto-salleo).

1. Foundations
    - [Thermodynamics and Phase Equilibria: Introduction](https://www.youtube.com/watch?v=bEUiUfunnvI)
    - [Historical overview](https://www.youtube.com/watch?v=GKO3MXExI2s)
    - [Definitions of Fundamental Concepts](https://www.youtube.com/watch?v=INwjv9HDCt0)
    - [Foundations](https://www.youtube.com/watch?v=s4UAlDe9-l8)
    - [Heat and Work](https://www.youtube.com/watch?v=4on5epShTrU)
    - [James Joule](https://www.youtube.com/watch?v=id8kgbaYpKM)
    - [Definition and Sign Convention for Work](https://www.youtube.com/watch?v=7nWm_KXV8Mo)
    - [First Law of Thermodynamics](https://www.youtube.com/watch?v=XTx-su6s_sA)
    - [Caloric Equation of State](https://www.youtube.com/watch?v=K90C6w-FP8I)
    - [Generalized Form of the First Law](https://www.youtube.com/watch?v=7h2tcB9fxN0)
    - [Internal Energy of an Ideal Gas](https://www.youtube.com/watch?v=vVySRn5vpHY)
    - [Need for Entropy](https://www.youtube.com/watch?v=tz0mm8zwj9k)
    - [Inaccessibility and Empirical Entropy](https://www.youtube.com/watch?v=AN2ndlPuOiE)
    - [Metrical Entropy](https://www.youtube.com/watch?v=2Kd0eJFO3U4)
    - [Adiabatic Processes](https://www.youtube.com/watch?v=G27IGHhMhQE)
    - [Carnot Inequality](https://www.youtube.com/watch?v=Tso3_y8gKIM)
    - [Isothermal Processes](https://www.youtube.com/watch?v=rN9RDoCThIk)
    - [Sadi Carnot](https://www.youtube.com/watch?v=CJM-hHHG28Q)
    - [Second Law of Thermodynamics](https://www.youtube.com/watch?v=AQ8SMZdoRFY)
    - [Equilibrium](https://www.youtube.com/watch?v=rVK77TYw1hE)
    - [3rd Law Measurability of Entropy](https://www.youtube.com/watch?v=tNekt9tBbwY)
    - [Combined Statement](https://www.youtube.com/watch?v=Ocm_rrOU-Oc)
    - [Statistical Definition of Entropy](https://www.youtube.com/watch?v=vl_UGp6-Tkc) [^1]
    - [Equations That Are Always True](https://www.youtube.com/watch?v=THrqc0HixDA)
    - [Real World Example: Thermal Cooling](https://www.youtube.com/watch?v=9bGOoqDSe_o)
    - [Worked Problem 1](https://www.youtube.com/watch?v=EVjKHlC_4Zg)
    - [Worked Problem 2](https://www.youtube.com/watch?v=6RqWIyNoTBs)
    
2. Tools for materials equilibria
    - [Preview](https://www.youtube.com/watch?v=Es359Hz6OSE)
    - [Thermodynamics and Classical Mechanics: A Comparison](https://www.youtube.com/watch?v=-XQTGnHjCm8)
    - [Dependent and Independent Variables](https://www.youtube.com/watch?v=op4HE1Gg9VQ)
    - [Pressure Cooker](https://www.youtube.com/watch?v=ZUFvVYa9RME)
    - [Isothermal and Isobaric Systems](https://www.youtube.com/watch?v=LtpFxW3i9d4)
    - [Summary](https://www.youtube.com/watch?v=1Np320noryw)
    - [A Concrete Example: Graphite and Diamond](https://www.youtube.com/watch?v=owpB7UAjz18)
    - [Maximum Work Available](https://www.youtube.com/watch?v=lto9YeC5w8s)
    - [Basis Set of Properties: Coeff of Thermal Expansion, Isothermal Compressibility, Specific Heat](https://www.youtube.com/watch?v=HqNzqe9DfOc)
    - [Maxwell Relations](https://www.youtube.com/watch?v=ss0NO1ApVec)
    - [Famous People: James Maxwell](https://www.youtube.com/watch?v=jtlLPQSwyl4)
    - [Calculating All Material Properties from the Basis Set](https://www.youtube.com/watch?v=zFC8UQ-ziEE)
    - [Two Examples](https://www.youtube.com/watch?v=KVb7gWMcr1g)
    - [Real World Example: The Joule-Thomson Coefficient](https://www.youtube.com/watch?v=osvlq3NsMN0)

3. Unary systems
    - [Preview](https://www.youtube.com/watch?v=o3z7K-OJ__k)
    - [A simple example to build intuition](https://www.youtube.com/watch?v=832EVrYb3gI)
    - [Chemical Potential Mathematical Definition](https://www.youtube.com/watch?v=PKZDdWkX_CY)
    - [Chemical Potential and Gibbs Free Energy](https://www.youtube.com/watch?v=YXqYUrJN1AE)
    - [Integral Form of Thermodynamic Potentials](https://www.youtube.com/watch?v=gE5OY5VT3XM)
    - [Summary: Chemical Potential and Material Exchange](https://www.youtube.com/watch?v=w_d0T09mvGo)
    - [Internal Equilibrium Condition Between Multiple Phases](https://www.youtube.com/watch?v=20xp-uVry4s)
    - [Unary Systems where P and T are Controlled](https://www.youtube.com/watch?v=VpyMYfFmKgs)
    - [Coexistence](https://www.youtube.com/watch?v=L7YzF1JI6TY)
    - [Equilibrium Transformations](https://www.youtube.com/watch?v=im5WTNrWhAs)
    - [Transformations away from Equilibrium and Metastability](https://www.youtube.com/watch?v=Rcd6XYDFErQ)
    - [Heat of Transformation Depends on T](https://www.youtube.com/watch?v=Oqc3YS6FQwY)
    - [First Order and Higher Order Transformations](https://www.youtube.com/watch?v=i3jTogHBjTw)
    - [General Shape of Phase Diagrams](https://www.youtube.com/watch?v=fi76c56yyFQ)
    - [Liquid/Solid Boundary: Clausius Equation](https://www.youtube.com/watch?v=GunM_Yo_Pb8)
    - [Liquid (Solid)/Vapor Boundary: Clausius/Clapeyron Equation](https://www.youtube.com/watch?v=bXRDIj6XvsU)
    - [The Critical State](https://www.youtube.com/watch?v=Qr8TIeS7AeY)
    - [Real World Example: The Amorphous Phases of Liquid Water](https://www.youtube.com/watch?v=BNyQNfqOREE)

4. Solution thermodynamics
    - [Preview](https://www.youtube.com/watch?v=IqYJWsZp2DI)
    - [Why Solutions and What Does Mixing Mean?](https://www.youtube.com/watch?v=NvAC6KCKXwg)
    - [A Simple Example to Build Intuition](https://www.youtube.com/watch?v=eVaJKkxq09s)
    - [Mathematical Definition](https://www.youtube.com/watch?v=LugbSLl96x4)
    - [Physical Meaning](https://www.youtube.com/watch?v=Dn5JWh3rEXw)
    - [Definition of Partial Molar Quantities and Relevant Relationships](https://www.youtube.com/watch?v=CXkJncDEd0w)
    - [Chemical Potential of Single Components: Activity](https://www.youtube.com/watch?v=stKB8AJkyTc)
    - [Gibbs-Duhem Equation](https://www.youtube.com/watch?v=PNog9EhxeR4)
    - [Introduction to Solution Models](https://www.youtube.com/watch?v=fUfDTUZbhOg)
    - [Ideal Solutions](https://www.youtube.com/watch?v=YjW83o72lcM)
    - [Ideal Solutions: The Math](https://www.youtube.com/watch?v=XF3gtxvlMEM)
    - [Definitions](https://www.youtube.com/watch?v=aNtmFDQnb-k)
    - [Models: Regular Solution](https://www.youtube.com/watch?v=6VZTF17Bn7o)
    - [Models: Quasi-Chemical Solution](https://www.youtube.com/watch?v=roSqWJwxMtA)
    - [Models: Dilute Solutions](https://www.youtube.com/watch?v=npU2Zrgq8ZU)
    - [Summary and Outlook](https://www.youtube.com/watch?v=XFaNZyvQELo)
    - [Real World Example: Brief History of Alloys](https://www.youtube.com/watch?v=XIWwe8KyB0s)
    - [Worked Problem 3-1](https://www.youtube.com/watch?v=5bV7wiCx2LU)

5. Phase diagrams
    - [Preview](https://www.youtube.com/watch?v=LhtFzJti3F0)
    - [Equilibrium Condition](https://www.youtube.com/watch?v=QcsPjoxVZCE)
    - [Gibbs' Phase Rule](https://www.youtube.com/watch?v=LDeZZrYQg6g)
    - [Graphical Construction: Common Tangent Construction](https://www.youtube.com/watch?v=FAk0wPwX05U)
    - [Application: A Simple Binary Diagram](https://www.youtube.com/watch?v=QHxlkCjSU9I)
    - [Mathematical derivation & Dependence of chemical potential on composition - Part 1](https://www.youtube.com/watch?v=OOj8833IiNM)
    - [Mathematical derivation & Dependence of chemical potential on composition - Part 2](https://www.youtube.com/watch?v=iHazpZjIgG8)
    - [Building Blocks](https://www.youtube.com/watch?v=1lumRiy6hS0)
    - [Miscibility Gap & Instability and Metastability](https://www.youtube.com/watch?v=UvghevMHKG8)
    - [Instability and Metastability](https://www.youtube.com/watch?v=ImzQYzHUMig)
    - [Lens Phase Diagram](https://www.youtube.com/watch?v=Y585Igyp0ws)
    - [Azeotropes](https://www.youtube.com/watch?v=SJhqr87gsLc)
    - [Eutectics](https://www.youtube.com/watch?v=t7fDAWS51bY)
    - [Peritectics](https://www.youtube.com/watch?v=Q9V6vDa7T8w)
    - [Eutectoids and Peritectoids](https://www.youtube.com/watch?v=rVKXA0UnIUE)
    - [Intermediate Phases](https://www.youtube.com/watch?v=BnKYxC3fJpo)
    - [Line Compounds](https://www.youtube.com/watch?v=c9_dHpC8kVo)
    - [A Few Handy Tricks](https://www.youtube.com/watch?v=N1Wt9RRzzUY)
    - [Real World Example: Organic Bulk Heterojunction Solar Cells](https://www.youtube.com/watch?v=fkQTQ94Rlik)
    - [Worked Problem 4](https://www.youtube.com/watch?v=qlE264v_lxc)
    
6. Equilibrium thermodynamics
    - [Basics of Thermodynamics of Chemical Reactions](https://www.youtube.com/watch?v=00nq7Sc5PeU)
    - [Equilibrium Constant](https://www.youtube.com/watch?v=kyNAbpUOz9Y)
    - [Reaction Quotient](https://www.youtube.com/watch?v=G2b7_7RGuJE)
    - [Calculating the Equilibrium Constant](https://www.youtube.com/watch?v=d0kR3KXdWPA)
    - [Dependence on P: Le Chatelier Principle](https://www.youtube.com/watch?v=f0YBuB8nKOA)
    - [Dependence on T: van't Hoff Equation](https://www.youtube.com/watch?v=6K1QA2w3NE8)
    - [An Example: Oxidation](https://www.youtube.com/watch?v=sl6tDlkwl1k)
    - [Thermodynamic Activity of Pure and Alloyed Solids](https://www.youtube.com/watch?v=jF370vhEDEo)
    - [Equilibrium Constant](https://www.youtube.com/watch?v=3o9Q5uaWghk)
    - [Stability of Solids in Oxygen](https://www.youtube.com/watch?v=OCX2YywbKik)
    - [Ellingham Diagrams](https://www.youtube.com/watch?v=ojaZVt5ljQY)
    - [Real World Example: Getting Oxygen from Moon Rocks](https://www.youtube.com/watch?v=s216tqslFEc)

[^1]: **Correction:** At 4:55 in the video below, Prof. Salleo mentions that the two configurations with W = 210 have the highest entropy. However, the single configuration to their right, with W = 840 has the highest entropy.

### Chapter 1 - Foundations

#### Introduction

Thermodynamics is not good at predicting what will happen - that is generally governed by kinetics - but can tell you what cannot happen. All observable processes have to be allowed by thermodynamics. Our goal in what follows is to understand which properties of materials must be measured so that predictions can be made regarding their phase transformations and how to assemble the equations to perform such predictions.

Historically, thermodynamics is a science born from practical engineering needs. In fact, it arose as England needed to develop the steam engine to be able to mine coal. At the same time, in France, its political rival at the time, Sadi Carnot developed further the science introducing the concept of entropy and maximum efficiency of an engine. Later on, in Austria, Boltzmann highly theoretical work linked entropy to atomistic behavior, what became fundamental in many fields. Currently the concept of entropy is used in cosmology, information science, linguistics, and so on, revealing the importance of thermodynamics as a general framework for describing the macroscopic world.

A large part of thermodynamics relies on the classification of systems, their boundaries, and the constitutive laws closing the description of the physics governing the system. That said, thermodynamics is an intrinsically semi-empirical science. The most basic type of system is the isolated system, for which no form of energy (heat, work, etc.) or mass exchanges is allowed. On the other hand, a system can be adiabatic, so that heat exchanges are not possible but work can be exerted by/upon the system. Adiabatic systems cannot exchange matter with their surroundings.

#### System classification

#system/isolated #system/adiabatic

To go further in the classification, it is clear by now that classification of system boundaries is an important matter. Regarding heat transfer, a system can be classified as diathermal, allowing heat exchanges with the environment, or adiabatic, as described above.

#### Boundary classification

#boundary/diathermal #boundary/adiabatic

In terms of mechanical work, a moving boundary allows work to be performed by the system upon its surroundings or vice-versa. On the other hand, a rigid boundary disallows mechanical work interactions.

#boundary/moving #boundary/rigid

Finally, regarding matter transport the boundaries can be permeable or impermeable; as discussed before, a permeable boundary cannot be classified as adiabatic, as matter transports energy.

#boundary/permeable #boundary/impermeable

#### Constitutive laws

In order to provide the closure of a system's description, in thermodynamics we use *constitutive laws*. These are provided by constitutive coordinates (physical quantities) that uniquely define the state of a system. The relationships between constitutive coordinates make up the constitutive equations of a system.

#constitutive/coordinates #constitutive/equations

A class of materials is a group that share the same constitutive coordinates. For instance, in thermodynamics a fluid is described by a pressure $p$, temperature $T$, number of moles $n$ and volume $V$; an example of constitutive law linking these measurables is the *ideal gas law*. A *solid* material being described by this same set of coordinates can also be classified as a fluid, what can be counterintuitive. In fact, real world solids can also present anisotropic stress dependences, leading to their own class of materials, but that will not be treated in this course.

#material/class/fluid #mateiral/class/solid

> [!IMPORTANT]
> It must be emphasized that in most practical applications an additional set of constitutive coordinates need to be added to a fluid description, the mass fractions $Y_k$ of its various components.

To wrap up this section, we can also provide a type to a material of a given class. All materials of the same class described by the same specific constitutive equation are said to be of the same type. In a complex model, different materials of the same class composing a system may eventually be described as being of different types (models), for instance, as an *ideal gas* or obeying *Van der Waals* equation.

#material/type 

#### Heat and work

The expression of the laws of thermodynamics is built upon relationships between heat and work and how they change the internal state of the system. Although all of them are expressed in units of energy, they are fundamentally different. Work is provided by *organized* motion of particles with net displacement, while heat is related to *random fluctuations* with zero displacement. Everything else is accounted for the *internal energy*, which is linked to the microscopic scales (essentially atomic motion) not described in thermodynamics. Joule demonstrated the equivalence between heat and work, disproving the belief that, at his time, heat was intrinsically contained in the material being submitted to work.

#energy/heat #energy/work #energy/internal

It is important to keep a consistent sign convention for work and heat in thermodynamics; here we adopt a system-centric approach where work *performed on* the system, *e.g.* by reducing its volume, is positive, while work *performed by* the system - consequently reducing its internal energy - is negative. By the definition of pressure $p$, for a piston, we have

$$
W = \int_{1}^{2}p_{ext}Adx = -p_{ext}\Delta{}V
$$

where the external pressure $p_{ext}$ is used because it is the value that performs work or upon which work is performed against, until equilibrium is reached. The sign convention displays the above definitions, meaning that a reduction of volume $\Delta{}V<0$ would imply work performed on the system. Following the same logic, heat $Q$ provided to the system has a positive sign, while heat transferred from the system to its surroundings has a negative sign.

In the previous expression we have work defined as the product of a field $p$ multiplied by an *extensive* quantity $V$. Fields is what in thermodynamics we call *intensive* variables, those defined as a distribution in space; their *extensive* counterpart hold the property of being additive and can only be defined for the system as a whole. There are always pairs of *conjugate* intensive and extensive variables as we will show later. Work will always be represented by an intensive quantity multiplied by a change in an extensive quantity.

#quantity/extensive #quantity/intensive

#### First law of thermodynamics

#variable/state #variable/path


#process/reversible #process/irreversible

#process/isothermal

#### Entropy and second law

#entropy/empirical #entropy/metrical

#### Equations summary

$$
\begin{aligned}
dU &= \delta{}Q + \delta{}W \qquad \delta{}W=-p_{ext}dV
\\[12pt]
dU &= TdS - pdV
\end{aligned}
$$

$$
dS = \frac{\delta{}Q_{rev}}{T}
\qquad
dS \ge \frac{\delta{}Q}{T}
$$

$$
S = k\log(w)
$$

#### Knowledge check

- A permeable membrane cannot be adiabatic: *true*.

- The chemical identity of the atoms is a constitutive coordinate of an ideal gas: *false*.

- The internal energy of all materials is 0J at T=0K: *false*. Internal energy is not an absolute number.

- If a system completes a cycle, $\Delta{}U_{sys}=0$ and $\Delta{}U_{surroundings}=0$ no matter what: *true*. Internal energy $U$ is a state function.

- The internal energy of a system is always conserved: *false*. The energy of the Universe is conserved, but individually, the energy of the system or surrounding are not always.

- What is the force pertaining to expansion work? $-p$.

- In what scenario does the temperature of an ideal gas decrease upon adiabatic expansion?
    - [ ] Work is performed on the system
    - [x] Work is performed by the system; Work performed *by* the system is negative under the defined sign convention. Since $\delta{}Q = 0$ for adiabatic systems, the first law simplifies to $dU = \delta{}W$. A decrease in temperature corresponds to a decrease in internal energy of the system, so $\delta{}W$ must be negative as well.
    - [ ] Heat is provided to the system
    - [ ] Heat is removed from the system

- Any spontaneous adiabatic transformation of a material increases its entropy: *true*.

- In going from a state A to a state B, an adiabatic system can either take a reversible path or an irreversible path: *false*. Entropy $S$ is a state function. Along the irreversible path $\Delta{}S>0$ while along the other $\Delta{}S=0$, this is a contradiction.

- Why can't adiabatic lines ever cross?
    - [ ] Higher energy states would be accessible
    - [ ] Lower energy states would be accessible
    - [ ] Higher entropy states would be accessible
    - [x] Lower entropy states would be accessible

- It is possible to have an adiabatic cycle with an irreversible leg: *false*.

- In going from a state A to a state B, an isothermal system can either take a reversible path or an irreversible path: *true*.

- What is the entropy change of a system undergoing an irreversible isothermal cycle? *0*. Even though the cycle is irreversible, the system is able to return to its original state.

- What about the surroundings? *>0*. The surroundings will gain more heat after the cycle completes. Therefore, $S_{surr}>0$.

- The entropy of the Universe always increases when a system spontaneously evolves towards equilibrium: *true*.

- If a system completes a cycle, $\Delta{}S_{sys}=0$ and $\Delta{}S_{surr}=0$ no matter what: *false*. If the cycle contains an irreversible leg $\Delta{}S_{surr}>0$.

- The combined statement only applies to reversible processes: *false*.

- Consider the system below with 3 atoms and E = 4 J. Three configurations are possible.

![](media/statistical-entropy.png)

1. What is W for configuration 1? 3
2. Which configuration has the highest entropy? 2

### Chapter 2 - Tools for materials equilibria

### Chapter 3 - Unary systems

### Chapter 4 - Solution Thermodynamics

#### Solution thermodynamics tools

#### Solution models

### Chapter 5 - Phase diagrams

#### Constructing phase diagrams

#### Types of phase diagrams

### Chapter 6 - Equilibrium thermodynamics

#### Chemical equilibria between gaseous species

#### Solid-gas reactions

## Course *Thermodynamics of Materials*

Notes taken while following this [course](https://courses.mitxonline.mit.edu/learn/course/course-v1:MITxt+3.012Tx+2T2023/home) by [Rafael Jaramillo](https://dmse.mit.edu/faculty/rafael-jaramillo/). It is also available at [MIT OCW](https://ocw.mit.edu/courses/3-020-thermodynamics-of-materials-spring-2021/) and in an [older version](https://ocw.mit.edu/courses/3-00-thermodynamics-of-materials-fall-2002/) by [Craig Carter](https://dmse.mit.edu/faculty/w-craig-carter/).
