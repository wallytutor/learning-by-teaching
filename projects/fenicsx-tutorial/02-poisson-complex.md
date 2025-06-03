# [Poisson equation in complex mode](https://jsdokken.com/dolfinx-tutorial/chapter1/complex_mode.html)

```python
from textwrap import dedent
from mpi4py import MPI
from petsc4py import PETSc

from dolfinx.fem import Function
from dolfinx.fem import Constant
from dolfinx.fem import functionspace
from dolfinx.fem import dirichletbc
from dolfinx.fem import locate_dofs_topological
from dolfinx.fem import form
from dolfinx.fem import assemble_scalar
from dolfinx.fem.petsc import LinearProblem

from dolfinx.mesh import exterior_facet_indices
from dolfinx.mesh import create_unit_square

from dolfinx.plot import vtk_mesh

from ufl import SpatialCoordinate
from ufl import TrialFunction
from ufl import TestFunction
from ufl import dot
from ufl import inner
from ufl import grad
from ufl import dx

import pyvista as pv
import numpy as np
```

```python
print(pv.global_theme.jupyter_backend)
pv.start_xvfb()
```

- Make sure environment is running with complex support:

```python
assert np.dtype(PETSc.ScalarType).kind == "c"
```

Let's again use the method of manufacture solutions; assume a low order complex polynomial $u_e=0.5x^2+1j\cdotp{}y^2$ for which $\Delta{}u_e=1+2j$, thus Poisson equation can be stated as:

$$
\begin{align}
-\Delta{}u &=-(1+2j)    &\mathbf{x}&\in\Omega \\
         u &=u_e  &\mathbf{x}&\in\partial\Omega
\end{align}
$$


The discrete function space $V_h$ here is defined for $u_h\in{}V_h$ such that $u_h=\sum{}c_i\phi_i(x,y)$ where the global basis functions $\phi_i$ are real value and $c_i\in\mathcal{C}$ are complex valued *DoFs*. Inner product space is now defined over $L^2$ (which is a sequilinear 2-form) so that

$$
\int_\Omega{}\nabla{}u_h\cdotp\nabla\overline{v}\,dx=
\int_\Omega{}f\cdotp\overline{v}\,dx\quad\forall{}v\in\hat{V}_h
$$

- Define the exact solution function for projection:

```python
def exact_solution(x):
    return 0.5 * x[0]**2 + 1j * x[1]**2
```

- Create the mesh for the domain:

```python
domain = create_unit_square(MPI.COMM_WORLD, 10, 10)

tdim = domain.topology.dim
fdim = tdim - 1
```

- Declare the function space for solution:

```python
V1 = functionspace(domain, ("Lagrange", 1))
V2 = functionspace(domain, ("Lagrange", 2))

# Select which one to use:
V = V1
```

- State variational problem on function space:

**Note:** `ufl.inner` already handles taking the complex conjugate of second argument. If trying to perform inner-products or derivatives manually, keep in mind that calling `ufl.conj` where appropriate is required. For more, check the original tutorial.

```python
u = TrialFunction(V)
v = TestFunction(V)
f = Constant(domain, PETSc.ScalarType(-1 - 2j))
a = inner(grad(u), grad(v)) * dx
L = inner(f, v) * dx
```

- Project the exact solution for use as boundary condition:

```python
u_c = Function(V, dtype=np.complex128)
u_c.interpolate(exact_solution)
```

- Identify external facets and apply boundary condition:

```python
domain.topology.create_connectivity(fdim, tdim)
boundary_facets = exterior_facet_indices(domain.topology)
boundary_dofs = locate_dofs_topological(V1, fdim, boundary_facets)
bc = dirichletbc(u_c, boundary_dofs)
```

- Build and solve linear problem:

```python
problem = LinearProblem(a, L, bcs=[bc])
u_h = problem.solve()
```

- Compute exact solution on grid coordinates:

```python
x = SpatialCoordinate(domain)
u_e = exact_solution(x)
```

- Evaluate errors against analytical and projected solution:

**Note:** why does the original tutorial use the normal `ufl.dot` product instead of `ufl.inner` here? Also see the previous tutorial recommending against the use of `ufl.dot` with complex valued vectors.

```python
def compute_error(inner_product, uh, ue, uc):
    # DoFs vs analytical:
    error = uh - ue
    error = inner_product(error, error)

    l2_error = form(error * dx(metadata={"quadrature_degree": 5}))
    local_error = assemble_scalar(l2_error)
    global_error = np.sqrt(domain.comm.allreduce(local_error, op=MPI.SUM))

    # DoFs vs projected on V:
    error = uc.x.array - uh.x.array
    error = np.max(np.abs(error))
    max_error = domain.comm.allreduce(error)

    print(dedent(f"""\
    Global error  {global_error}
    Maximum error {max_error}
    """))
```

```python
compute_error(dot, u_h, u_e, u_c)
```

```python
compute_error(inner, u_h, u_e, u_c)
```

```python
p_grid = pv.UnstructuredGrid(*vtk_mesh(domain, tdim))
p_grid = pv.UnstructuredGrid(*vtk_mesh(V))
p_grid.point_data["u_real"] = u_h.x.array.real
p_grid.point_data["u_imag"] = u_h.x.array.imag
```

```python
p_grid.set_active_scalars("u_real")

p_real = pv.Plotter()
p_real.add_text("Real part of u", position="upper_edge", font_size=14, color="black")
p_real.add_mesh(p_grid, show_edges=True)
p_real.view_xy()
p_real.show()
```

```python
p_grid.set_active_scalars("u_imag")

p_real = pv.Plotter()
p_real.add_text("Imaginary part of u", position="upper_edge", font_size=14, color="black")
p_real.add_mesh(p_grid, show_edges=True)
p_real.view_xy()
p_real.show()
```
