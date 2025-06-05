# [Poisson equation with Nitsche's method](https://jsdokken.com/dolfinx-tutorial/chapter1/nitsche.html)

```python
from mpi4py import MPI

from dolfinx import default_scalar_type
from dolfinx.fem import Constant
from dolfinx.fem import Expression
from dolfinx.fem import Function
from dolfinx.fem import functionspace
from dolfinx.fem import form
from dolfinx.fem import assemble_scalar
from dolfinx.fem.petsc import LinearProblem
from dolfinx.mesh import create_unit_square
from dolfinx.plot import vtk_mesh

from ufl import Circumradius
from ufl import FacetNormal
from ufl import SpatialCoordinate
from ufl import TrialFunction
from ufl import TestFunction
from ufl import inner
from ufl import div
from ufl import grad
from ufl import dx
from ufl import ds

import pyvista as pv
import numpy as np
```

```python
print(pv.global_theme.jupyter_backend)
pv.start_xvfb()
```

- Define the exact solution function for projection:

```python
def exact_solution(x):
    return 1.0 + x[0]**2 + 2 * x[1]**2
```

- Create domain and retrieve its spatial coordinates:

```python
domain = create_unit_square(MPI.COMM_WORLD, 8, 8)
x = SpatialCoordinate(domain)
```

- Create functional space for solution:

```python
V = functionspace(domain, ("Lagrange", 1))
```

- Create boundary condition function and project exact solution over it and compute $f$ that is compatible with analytical solution:

```python
u_d = Function(V)
u_e = exact_solution(x)

# As proposed in tutorial:
# u_d.interpolate(Expression(u_e, V.element.interpolation_points()))

# Why was it proposed as given above in this tutorial?
# In a past one the following *simpler* solution was used.
u_d.interpolate(exact_solution)

f = -div(grad(u_e))
```

- Formulate FEM problem with included boundary conditions:

```python
u = TrialFunction(V)
v = TestFunction(V)
n = FacetNormal(domain)
h = 2 * Circumradius(domain)
alpha = Constant(domain, default_scalar_type(10))

R = alpha / h

# a = inner(grad(u), grad(v)) * dx - \
#     inner(n, grad(u)) * v * ds -   \
#     inner(n, grad(v)) * u * ds +   \
#     R * inner(u, v) * ds

# XXX: does this work? Yes. Always? Need to think a bit...
a = inner(grad(u), grad(v)) * dx - \
    inner(n, grad(u * v)) * ds +   \
    R * inner(u, v) * ds

L = inner(f, v) * dx - \
    inner(n, grad(v)) * u_d * ds + \
    R * inner(u_d, v) * ds
```

- Solve linear problem:

```python
problem = LinearProblem(a, L)
u_h = problem.solve()
```

- Compute solution error against analytical solution:

```python
def l2_norm_error(u_h, u_e):
    E = inner(u_h - u_e, u_h - u_e) * dx
    error_local = assemble_scalar(form(E))

    # XXX: assemble_scalar works in a single process, use MPI reduction
    # to compute over all the processes for parallel problems!
    return np.sqrt(domain.comm.allreduce(error_local, op=MPI.SUM))
```

```python
error_l2 = l2_norm_error(u_h, u_d)
error_lm = np.max(np.abs(u_d.x.array - u_h.x.array))

# Only print the error on one process
if domain.comm.rank == 0:
    print(f"Error L2  : {error_l2:.2e}")
    print(f"Error max : {error_lm:.2e}")
```

- Create grid for postprocessing with PyVista:

```python
grid = pv.UnstructuredGrid(*vtk_mesh(V))
grid.point_data["u"] = u_h.x.array.real
grid.point_data["e"] = np.abs(u_h.x.array.real - u_d.x.array.real)
grid.point_data["r"] = np.abs(u_h.x.array.real - u_d.x.array.real) / np.abs(u_d.x.array.real)
```

- Display solution:

```python
grid.set_active_scalars("u")
opts = dict(show_edges=True, show_scalar_bar=True, cmap="jet")

plotter = pv.Plotter()
plotter.add_mesh(grid, **opts)
plotter.view_xy()
plotter.show()
```

- Display absolute error against analytical solution

```python
grid.set_active_scalars("e")
opts = dict(show_edges=True, show_scalar_bar=True, cmap="jet")

plotter = pv.Plotter()
plotter.add_mesh(grid, **opts)
plotter.view_xy()
plotter.show()
```

- Display absolute relative error against analytical solution:

```python
grid.set_active_scalars("r")
opts = dict(show_edges=True, show_scalar_bar=True, cmap="jet")

plotter = pv.Plotter()
plotter.add_mesh(grid, **opts)
plotter.view_xy()
plotter.show()
```
