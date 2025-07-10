# Classical Mechanics

The following notes are taken during study sessions of Goldstein's [@Goldstein2001] Classical Mechanics book. Unless stated otherwise, all concepts are summarized from that source.

## Cheat-sheet

In what follows, $\mathbf{r}$ represents a position vector and dot-notation is employed for time derivatives. For conciseness, only the more general expressions are provided (especial cases such as constant mass expansions are omitted as they can be derived).

| Concept             | Expression                                                      |
| :------------------ | :-------------------------------------------------------------- |
| Velocity            | $\mathbf{v}=\dot{\mathbf{r}}$                                   |
| Acceleration        | $\mathbf{a}=\dot{\mathbf{v}}=\ddot{\mathbf{r}}$                 |
| Linear momentum     | $\mathbf{p}=m\mathbf{v}$                                        |
| Force               | $\mathbf{F}=\dot{\mathbf{p}}$                                   |
| Angular momentum    | $\mathbf{L}=\mathbf{r}\times\mathbf{p}$                         |
| Torque              | $\mathbf{N}=\mathbf{r}\times\mathbf{F}$                         |
| External force work | $W_{12}=\displaystyle\int_{1}^{2}\mathbf{F}\cdotp{}d\mathbf{s}$ |
| Kinetic energy      | $T=\dfrac{1}{2}mv^2=\dfrac{p^2}{2m}$                            |
| Potential energy    | $-\nabla{}V(\mathbf{r})$                                        |

## Theorems and concepts

- Conservation theorem for the linear momentum of a particle: if the total force, $\mathbf{F}$, is zero, then $\dot{\mathbf{p}}=0$ and the linear momentum, $\mathbf{p}$, is conserved.

- Conservation theorem for the angular momentum of a particle: if the total torque, $\mathbf{N}$, is zero, then $\dot{\mathbf{L}}=0$, and the angular momentum, $\mathbf{L}$, is conserved.

- A system for which the work $W_{12}$ is the same for any physically possible path is said to be conservative; in such system the work performed over a loop vanishes; from vector analysis, this requires $\mathbf{F}$ to be the gradient of some scalar field $V$, the potential energy.

$$
\oint\mathbf{F}\cdotp{}d\mathbf{s}=0\implies{}\mathbf{F}=-\nabla{}V(\mathbf{r})
$$

- Energy conservation theorem for a particle: if the forces acting on a particle are conservative, then the total energy of the particle, $T+V$, is conserved.
