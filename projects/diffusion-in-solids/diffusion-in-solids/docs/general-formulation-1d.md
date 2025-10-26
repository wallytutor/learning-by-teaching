# Diffusion equation in 1D

Assume a simple concentration-dependent diffusion in the absence of external driving forces; the time derivative of concentration $c$ at one location is given by the divergence - which collapses to the spatial derivative - of the negative of mass flux given by Fick's law. Diffusion coefficient $D$ being possibly dependent of coordinate $x$ or composition $c$, the derivative is not expanded. This form of the diffusion equation is discussed in what follows.

The governing diffusion equation in one dimension is:

$$
\dfrac{\partial{}c}{\partial{}t}=
\dfrac{\partial{}}{\partial{}x}
\left(
    D
    \dfrac{\partial{}c}{\partial{}x}
\right)
$$

This equation states that the rate of change of concentration $c$ with time $t$ at any point equals the spatial derivative of the diffusive flux. The flux is given by Fick's first law: $J = -D \frac{\partial c}{\partial x}$, where $D$ is the diffusion coefficient that may depend on position or concentration. The negative sign indicates that diffusion occurs from high to low concentration regions.

## Finite volume formulation

To solve the diffusion equation numerically, we employ the finite volume method. We integrate the governing equation over a control volume from $w$ (west face) to $e$ (east face) and over a time interval from $0$ to $\tau$:

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

This double integration allows us to convert the partial differential equation into a form suitable for numerical discretization. The order of integration can be exchanged due to the smoothness assumptions.

Evaluating the integrals, we get:

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

Here, $c_P^0$ and $c_P^\tau$ represent the concentration at the center of the control volume (point P) at times $0$ and $\tau$, respectively. The right-hand side represents the net flux into the control volume through its east and west faces.

Assuming the concentration is uniform within each control volume and the fluxes are constant over the time interval, we obtain:

$$
\left(c_{P}^{\tau}-c_{P}^{0}\right)
\dfrac{\delta}{\tau}
=
\left(D\dfrac{\partial{}c}{\partial{}x}\right)_{e}-
\left(D\dfrac{\partial{}c}{\partial{}x}\right)_{w}
$$

where $\delta$ is the width of the control volume. This equation represents the discrete form of the diffusion equation for a single control volume.

## Discretization of gradients

To implement the finite volume method numerically, we need to discretize the concentration gradients at the control volume faces. Using central differences, the gradients are approximated as:

$$
\left(c_{P}^{\tau}-c_{P}^{0}\right)
\dfrac{\delta}{\tau}
=
D_{e}\dfrac{c_{E}-c_{P}}{\delta}-
D_{w}\dfrac{c_{P}-c_{W}}{\delta}
$$

Here, $c_E$ and $c_W$ are the concentrations at the eastern and western neighboring control volumes, respectively. $D_e$ and $D_w$ are the effective diffusion coefficients at the east and west faces of the control volume.

Multiplying through by $\delta$ and rearranging terms:

$$
\left(c_{P}^{\tau}-c_{P}^{0}\right)
\dfrac{\delta^2}{\tau}
=
D_{e}c_{E}-(D_{e}+D_{w})c_{P}+D_{w}c_{W}
$$

This form clearly shows the contribution of each neighboring concentration to the rate of change at point P. The coefficient of $c_P$ is negative, representing the outflow from the central node, while the coefficients of $c_E$ and $c_W$ are positive, representing inflow from the neighboring nodes.

Introducing dimensionless coefficients $\alpha$, we obtain the final discretized form:

$$
c_{P}^{\tau}-c_{P}^{0}
=
\alpha_{e}c_{E}-(\alpha_{e}+\alpha_{w})c_{P}+\alpha_{w}c_{W}
$$

The coefficients are defined as:

$$
D_{k}=2\frac{D_{i}D_{j}}{D_{i}+D_{j}}
\quad
\alpha_{k}=\dfrac{\tau{}D_{k}}{\delta^2}
$$

where $D_k$ is the harmonic mean of the diffusion coefficients at adjacent nodes $i$ and $j$, ensuring continuity of flux across the interface. The parameter $\alpha_k$ represents the dimensionless diffusion number, which determines the stability and accuracy of the numerical scheme. The subscript $k$ refers to either the east ($e$) or west ($w$) face.

## Boundary conditions

The implementation of boundary conditions requires special treatment of the control volumes at the domain boundaries. The general form for a boundary control volume is:

$$
\left(c_{P}^{\tau}-c_{P}^{0}\right)
\dfrac{\delta}{\tau}
= \text{flux}_{\text{interior}} - \text{flux}_{\text{boundary}}
$$

### Dirichlet boundary condition (Type 1)

For a fixed concentration boundary condition, the concentration at the boundary face is prescribed:

$$c_{\text{boundary}} = c_{\text{prescribed}}$$

At the **west boundary**, this becomes:

$$
\left(c_{P}^{\tau}-c_{P}^{0}\right)
\dfrac{\delta}{\tau}
=
D_{e}\dfrac{c_{E}-c_{P}}{\delta}-
D_{w}\dfrac{c_{P}-c_{\text{prescribed}}}{\delta}
$$

At the **east boundary**:

$$
\left(c_{P}^{\tau}-c_{P}^{0}\right)
\dfrac{\delta}{\tau}
=
D_{e}\dfrac{c_{\text{prescribed}}-c_{P}}{\delta}-
D_{w}\dfrac{c_{P}-c_{W}}{\delta}
$$

### Neumann boundary condition (Type 2)

For a fixed flux boundary condition, the flux at the boundary is prescribed:

$$-D\dfrac{\partial c}{\partial x}\bigg|_{\text{boundary}} = q_{\text{prescribed}}$$

At the **west boundary** (flux into domain is positive):

$$
\left(c_{P}^{\tau}-c_{P}^{0}\right)
\dfrac{\delta}{\tau}
=
D_{e}\dfrac{c_{E}-c_{P}}{\delta} + q_{\text{prescribed}}
$$

At the **east boundary** (flux out of domain is positive):

$$
\left(c_{P}^{\tau}-c_{P}^{0}\right)
\dfrac{\delta}{\tau}
=
-q_{\text{prescribed}} - D_{w}\dfrac{c_{P}-c_{W}}{\delta}
$$

Special case: **Zero flux** (impermeable boundary) where $q_{\text{prescribed}} = 0$.

### Robin boundary condition (Type 3)

For a convective or mixed boundary condition, the flux is proportional to the concentration difference:

$$-D\dfrac{\partial c}{\partial x}\bigg|_{\text{boundary}} = h(c_{\text{boundary}} - c_{\infty})$$

where $h$ is the mass transfer coefficient and $c_{\infty}$ is the ambient concentration.

At the **west boundary**:

$$
\left(c_{P}^{\tau}-c_{P}^{0}\right)
\dfrac{\delta}{\tau}
=
D_{e}\dfrac{c_{E}-c_{P}}{\delta} + h(c_{P} - c_{\infty})
$$

At the **east boundary**:

$$
\left(c_{P}^{\tau}-c_{P}^{0}\right)
\dfrac{\delta}{\tau}
=
-h(c_{P} - c_{\infty}) - D_{w}\dfrac{c_{P}-c_{W}}{\delta}
$$

### Implementation considerations

For numerical stability and accuracy:

1. **Dirichlet BC**: The prescribed concentration can be directly substituted, reducing the system size
2. **Neumann BC**: Care must be taken with sign conventions for flux direction
3. **Robin BC**: The convective term $h(c_P - c_{\infty})$ appears on the right-hand side and may require implicit treatment for stability

The choice of boundary condition significantly affects the solution behavior and should reflect the physical situation being modeled.