# Turbulence

In the 1970's [Launder and Spalding](https://doi.org/10.1016/0045-7825\(74\)90029-2) [@Launder1974]questioned the reason why at their time computer programs available for fluid dynamics did not *do full justice* to it, although numerical methods were already advanced enough; with the computing limitations at the time, resolving eddies of the order of a millimeter in flows that easily make a few meters could be a first explanation. Turbulence models completed Navier-Stokes equations to approximate the behavior of real fluids, but an universal (*solve a broad range of turbulent flows*) and low complexity (*a few differential equations, limited need of empirical data and closure functions*) turbulence model was not readily available; choices needed to be done regarding th chose of equations, and difficulties regarding the identification of experimental parameters needed to be overcome. Under this context they [@Launder1974] proposed $k-\epsilon$ model for solving the turbulent kinetic energy $k$ and its dissipation rate $\epsilon$ with emphasis on near-wall phenomena.

$$
k = \dfrac{1}{2}\overline{u_iu_i}
\qquad
\epsilon = \nu\overline{%
	\dfrac{\partial{}u_i}{\partial{}x_k}%
	\dfrac{\partial{}u_i}{\partial{}x_k}}
\qquad%
l = C_D\dfrac{k^{3/2}}{\epsilon}
$$

Effective turbulent viscosity:

$$
\mu_t = C_\mu\rho{}k^{1/2}l =
        C_\mu\rho{}\dfrac{k^2}{\epsilon}
$$
