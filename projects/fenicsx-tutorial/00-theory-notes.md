# Notes on finite element method


- [Resources on FEM](https://jsdokken.com/dolfinx-tutorial/fem.html#introduction-to-the-finite-element-method)


## Integration by parts


Standard form based on product rule

$$
\int_{\Omega}u\cdotp{}(\nabla{v})\,dV =
\int_{\Omega}\nabla{(ab)}\,dV -
\int_{\Omega}v\cdotp(\nabla{u})\,dV
$$

or making use of Gauss theorem:

$$
\int_{\Omega}u\cdotp{}(\nabla{v})\,dV =
\int_{\partial\Omega}{ab}\cdot\vec{n}\,dA -
\int_{\Omega}v\cdotp(\nabla{u})\,dV
$$


## Abstract variational notation


An arbitrary linear finite element variation problem is stated as

$$
a(u,v) = L(v)\qquad\forall{v}\in\hat{V}
$$

where: 
- $a(u,v)$ is called the bilinear form
- $L(v)$ is the linear form
