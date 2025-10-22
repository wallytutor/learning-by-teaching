# Diffusion equation in 1D

Assume a simple concentration-dependent diffusion in the absence of external driving forces; the time derivative of concentration $c$ at one location is given by the divergence - which collapses to the spatial derivative - of the negative of mass flux given by Fick's law. Diffusion coefficient $D$ being possibly dependent of coordinate $x$ or composition $c$, the derivative is not expanded. This form of the diffusion equation is discussed in what follows.

$$
\dfrac{\partial{}c}{\partial{}t}=
\dfrac{\partial{}}{\partial{}x}
\left(
    D
    \dfrac{\partial{}c}{\partial{}x}
\right)
$$

## Finite volume formulation

$$
\int_{w}^{e}
\int_{0}^{\tau}
\dfrac{\partial{}c}{\partial{}t}dt\:dx
=
\int_{0}^{\tau}
\int_{w}^{e}
\dfrac{\partial{}}{\partial{}x}
\left(D\dfrac{\partial{}c}{\partial{}x}\right)dx\:dt
$$

$$
\int_{w}^{e}
\left(c_{P}^{\tau}-c_{P}^{0}\right)\:dx
=
\int_{0}^{\tau}
\left[
    \left(D\dfrac{\partial{}c}{\partial{}x}\right)_{e}-
    \left(D\dfrac{\partial{}c}{\partial{}x}\right)_{w}
\right]
\:dt
$$

$$
\left(c_{P}^{\tau}-c_{P}^{0}\right)
\dfrac{\delta}{\tau}
=
\left(D\dfrac{\partial{}c}{\partial{}x}\right)_{e}-
\left(D\dfrac{\partial{}c}{\partial{}x}\right)_{w}
$$

## Discretization of gradients

$$
\left(c_{P}^{\tau}-c_{P}^{0}\right)
\dfrac{\delta}{\tau}
=
D_{e}\dfrac{c_{E}-c_{P}}{\delta}-
D_{w}\dfrac{c_{P}-c_{W}}{\delta}
$$

$$
\left(c_{P}^{\tau}-c_{P}^{0}\right)
\dfrac{\delta^2}{\tau}
=
D_{e}c_{E}-(D_{e}+D_{w})c_{P}+D_{w}c_{W}
$$

$$
c_{P}^{\tau}-c_{P}^{0}
=
\alpha_{e}c_{E}-(\alpha_{e}+\alpha_{w})c_{P}+\alpha_{w}c_{W}
$$

$$
D_{k}=2\frac{D_{i}D_{j}}{D_{i}+D_{j}}
\quad
\alpha_{k}=\dfrac{\tau{}D_{k}}{\delta^2}
$$

## Boundary conditions

<!-- $$
\left(c_{P}^{\tau}-c_{P}^{0}\right)
\dfrac{\delta}{\tau}
=
D_{e}\dfrac{c_{E}-c_{P}}{\delta}-
h(c_{s}-c_{P})
$$ -->

<!-- $$
\left(c_{P}^{\tau}-c_{P}^{0}\right)
\dfrac{\delta}{\tau}
=
D_{e}\dfrac{c_{W}-c_{P}}{\delta}-
D_{w}\dfrac{c_{P}-c_{W}}{\delta}
$$ -->