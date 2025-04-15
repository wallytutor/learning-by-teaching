---
title: Packed bed heat storage
author: Walter Dal'Maz Silva
date: April 15th 2025
bibliography: ../references/references.bib
---

# Introduction

This note compiles a few elements on the modeling of heat transfer in packed beds. It focuses on classical implementations that can be simultaneously used in systems design that are also available in typical CFD software packages. Most of the elements compiled here are also discussed by [@Gidaspow1994] and [@Bird2001].

**Important:** this is a work in progress and might change as review goes on.

# Pressure drop

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

# Heat transfer coefficient

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

# References
