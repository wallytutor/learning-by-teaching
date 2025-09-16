# Knowledge

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

![Eddy Viscosity Models for RANS and LES](https://www.youtube.com/watch?v=SVYXNICeNWA&list=PLnJ8lIgfDbkrNyps1_36tNRRQ7hLzPFhV&index=1)


![The k - epsilon Turbulence Model](https://www.youtube.com/watch?v=fOB91zQ7HJU&list=PLnJ8lIgfDbkrNyps1_36tNRRQ7hLzPFhV&index=2)


![The k - omega SST Turbulence Model](https://www.youtube.com/watch?v=myv-ityFnS4&list=PLnJ8lIgfDbkrNyps1_36tNRRQ7hLzPFhV&index=3)


![The k-omega Turbulence Model](https://www.youtube.com/watch?v=26QaCK6wDp8&list=PLnJ8lIgfDbkrNyps1_36tNRRQ7hLzPFhV&index=4)


![The Spalart-Allmaras Turbulence Model](https://www.youtube.com/watch?v=Xivc0EIGFQw&list=PLnJ8lIgfDbkrNyps1_36tNRRQ7hLzPFhV&index=5)


![The Transition SST (gamma - Re_theta) model](https://www.youtube.com/watch?v=5htknS9uVEk&list=PLnJ8lIgfDbkrNyps1_36tNRRQ7hLzPFhV&index=6)


![Turbulence Intensity for RANS](https://www.youtube.com/watch?v=Xr7BzHImL68&list=PLnJ8lIgfDbkrNyps1_36tNRRQ7hLzPFhV&index=7)


### Large Eddy Simulation (LES)

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

- Time average point probes in regions where a statistical steady state is achieved.

- Compute mean flow field $\bar{U}$ from instantaneous data then use its value over the domain to evaluate the fluctuating velocity $u^\prime=U-\bar{U}$ to later compute $k$ (turbulent kinetic energy).

- The normal components of Reynolds-stress tensor (its trace) adds up to form $k$.

- In OpenFOAM the Reynolds stress tensor is computed as `uPrime2Mean` in units of $m^2/s^2$ while Ansys Fluent will compute RMSE velocities to give units of $m/s$, so values need to be squared to compute $k$!


![Large Eddy Simulation (LES) 3: Sub-Grid Modelling](https://www.youtube.com/watch?v=N81Io_yrOQU&list=PLnJ8lIgfDbkoPrNWatlYdROiPrRU4XeUA&index=3)


![Eddy Viscosity Models for RANS and LES](https://www.youtube.com/watch?v=SVYXNICeNWA&list=PLnJ8lIgfDbkoPrNWatlYdROiPrRU4XeUA&index=4)


![The Smagorinsky Turbulence Model (Part 1)](https://www.youtube.com/watch?v=V8ydRrdCzl0&list=PLnJ8lIgfDbkoPrNWatlYdROiPrRU4XeUA&index=5)


![The Smagorinsky Turbulence Model (Part 2)](https://www.youtube.com/watch?v=GdXLyfRK188&list=PLnJ8lIgfDbkoPrNWatlYdROiPrRU4XeUA&index=6)

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

![Theoretical And Numerical Combustion, Poinsot, Day 1](https://www.youtube.com/watch?v=RzfWLuyOBkg&list=PLbInEHTmP9VYr0vcMrXm93vs9uj5BZ5Es&index=1)

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
