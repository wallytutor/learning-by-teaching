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
