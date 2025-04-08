---
title: "Theoretical and Numerical Combustion"
tags: combustion, transport
bibliography: ../../references/references.bib
reference-section-title: References
---

# Theoretical and Numerical Combustion

Study notes from the book by [@Poinsot2022TNC] and complementary information from their [web page](https://elearning.cerfacs.fr/combustion/index.php). The main motivations for studying combustion is that it is and will still be the main source of energy for humankind. Given its complexity, we cannot tackle all of its intricacies without recurring to simulation. Nevertheless, simulation alone without the minimal theory background is dangerous. With the current available computing power, a transition towards more compute-intensive _LES_ approaches is replacing classical _RANS_, even in situations where steady treatment has been long the standard. It is thus necessary to understand the numerical aspects of the more powerful and detailed transient models, a matter that will progressively be treated here. A foreword and motivation for delving into the subject is provided [in this video](https://elearning.cerfacs.fr/combustion/n7masterCourses/introduction/index.php).

## Resources

- [Cerfacs eLearning - Portal](https://cerfacs.fr/elearning/)
- [Cerfacs eLearning - Combustion index](https://elearning.cerfacs.fr/combustion/index.php)
- [Cerfacs eLearning - Fail CFD](https://elearning.cerfacs.fr/advices/poinsot/cfd/index.php)

## Chapter 1

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

### Exercises

- [ ] Derive viscous stress tensor.
- [ ] Explain the concept of *bulk viscosity*.
- [ ] Program a full multicomponent diffusion program.
- [ ] Review Soret and Dufour effects.

### Additional materials for following this chapter:

- [Adiabatic flame temperature](https://elearning.cerfacs.fr/combustion/n7masterCourses/adiabaticflametemperature/index.php)
- [Conservation equations - part 1](https://elearning.cerfacs.fr/combustion/n7masterCourses/conservationequations/index.php)
- [Conservation equations - part 2](https://elearning.cerfacs.fr/combustion/n7masterCourses/conservationequationsP2/index.php)
- Appendices of [@Williams1985]

## Chapter 2

## Chapter 3

## Chapter 4

## Chapter 5

## Chapter 6

## Chapter 7

## Chapter 8

## Chapter 9

## Chapter 10

## Going further

- [@Hirschfelder1969]
