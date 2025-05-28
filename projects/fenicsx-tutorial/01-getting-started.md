---
jupyter:
  jupytext:
    cell_metadata_filter: -all
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.17.1
  kernelspec:
    display_name: Python 3 (ipykernel)
    language: python
    name: python3
---

# Getting started with FEM and FEniCSx


- [Resources on FEM](https://jsdokken.com/dolfinx-tutorial/fem.html#introduction-to-the-finite-element-method)

```python
from mpi4py import MPI
from dolfinx import mesh
from dolfinx import fem
```

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


## [Poisson equation](https://jsdokken.com/dolfinx-tutorial/chapter1/fundamentals.html#solving-the-poisson-equation)


Poisson equation with Dirichlet boundary condition $u_D$ is stated as:

$$
\begin{align}
-\nabla^2u &=f    &\mathbf{x}&\in\Omega \\
         u &=u_D  &\mathbf{x}&\in\partial\Omega
\end{align}
$$

Multiplying the problem by a test function $v$ and integrating over the domain to get the variational form leads to:

$$
-\int_{\Omega}(\nabla^2u)v\,dx=\int_{\Omega}fv\,dx
$$

Applying integration by parts and Gauss theorem leads to the expanded form:

$$
\int_{\Omega}\nabla{u}\cdotp{}\nabla{v}\,d\Omega
-\int_{\partial\Omega}(\nabla{u})\cdotp{}v\cdotp{}\vec{n}\,ds=
\int_{\Omega}fv\,dx
$$

Because variational principle requires $v$ to vanish where trial function $u$ is knonw, *i.e.* a Dirichlet boundary:

$$
\int_{\Omega}\nabla{u}\cdotp{}\nabla{v}\,d\Omega=
\int_{\Omega}fv\,dx\qquad\forall{v}\in\hat{V}
$$

Passing this variational problem into discrete trial and test functional spaces writes:

$$
\int_{\Omega}\nabla{u_h}\cdotp{}\nabla{v}\,d\Omega=
\int_{\Omega}fv\,dx\qquad\forall{v}\in\hat{V}_h, u_h\in{}V_h
$$

```python
nx = ny = 8
cell_type = mesh.CellType.quadrilateral

import numpy as np
dtype = np.float64
domain = mesh.create_unit_square(MPI.COMM_WORLD, nx, ny, cell_type=cell_type, dtype=dtype)
```

```python
V = fem.functionspace(domain, ("Lagrange", 1))
```

```python
# uD = fem.Function(V)
# uD.interpolate(lambda x: 1 + x[0]**2 + 2 * x[1]**2)
```

```python
import dolfinx
```

```python

```
