# Notes on finite element method


- [Resources on FEM](https://jsdokken.com/dolfinx-tutorial/fem.html#introduction-to-the-finite-element-method)


## Integration by parts


Standard form based on product rule

$$
\int_{\Omega}u\cdotp{}\nabla{v}\,dV =
\int_{\Omega}\nabla{(uv)}\,dV -
\int_{\Omega}v\cdotp\nabla{u}\,dV
$$

or making use of Gauss theorem:

$$
\int_{\Omega}u\cdotp{}\nabla{v}\,dV =
\int_{\partial\Omega}{uv}\cdot\vec{n}\,dA -
\int_{\Omega}v\cdotp\nabla{u}\,dV
$$


## Abstract variational notation


An arbitrary linear finite element variation problem is stated as

$$
a(u,v) = L(v)\qquad\forall{v}\in\hat{V}
$$

where: 
- $a(u,v)$ is called the bilinear form
- $L(v)$ is the linear form


## Important concepts


- [Bilinear form](https://en.wikipedia.org/wiki/Bilinear_form)

- [Sesquilinear form](https://en.wikipedia.org/wiki/Sesquilinear_form)

$$
\begin{align}
\langle{}u,v\rangle{}&=\int_\Omega{}u\cdotp{}\overline{v}\,dx
\\[12pt]
\langle{}u,v\rangle{}&=\overline{\langle{}v,u\rangle{}}
\\[12pt]
\langle{}u,u\rangle{}&\ge{}0
\end{align}
$$


## Weak Dirichlet boundary conditions


It is possible to introduce Dirichlet boundary conditions directly in the problem weak formulation using [Nitsche's](https://jsdokken.com/dolfinx-tutorial/chapter1/nitsche.html#) method. After integration by parts one does not enforce the trace of the test function to zero so that

$$
\int_{\Omega}\nabla{}u\cdotp{}\nabla{v}\,dx -
\int_{\partial\Omega}\nabla{}u\cdotp{nv}\,ds =
\int_{\Omega}fv\,dx
$$

Before evaluation we add two terms to this function

$$
-\int_{\partial\Omega}(\nabla{}v)\cdotp{n(u-u_D)}\,ds +
\frac{\alpha}{h}\int_{\partial\Omega}{(u-u_D)v}\,ds
$$

where the first term enforces symmetry of bilinear form, and the later promotes [coercivity](https://en.wikipedia.org/wiki/Coercive_function) to approach boundary condition. With these modifications we get the required forms:

$$
\begin{align}
a(u,v) &=
    \int_{\Omega}\nabla{}u\cdotp{}\nabla{v}\,dx -
    \int_{\partial\Omega}
        \nabla{}u\cdotp{nv} +
        \nabla{}v\cdotp{nu} -
        \frac{\alpha}{h}{uv}\,ds
\\[12pt]
L(v)   &=
    \int_{\Omega}fv\,dx -
    \int_{\partial\Omega}
        \nabla{}v\cdotp{nu_D} -
        \frac{\alpha}{h}{u_Dv}\,ds
\end{align}
$$

It must be emphasized that given the relaxation of boundary being coerced in weak form, its error no longer approaches machine epsilon, but remains in the order of magnitude of overall solution (if calculation succeeds).
