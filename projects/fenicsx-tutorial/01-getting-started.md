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
from pathlib import Path
from mpi4py import MPI
from dolfinx import io
from dolfinx import mesh
from dolfinx import fem
from dolfinx import plot
from dolfinx import default_scalar_type
from dolfinx.fem.petsc import LinearProblem
import pyvista as pv
import numpy as np
import ufl
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
uD = fem.Function(V)
uD.interpolate(lambda x: 1 + x[0]**2 + 2 * x[1]**2)
```

```python
# Create facet to cell connectivity required to determine boundary facets
tdim = domain.topology.dim
fdim = tdim - 1

domain.topology.create_connectivity(fdim, tdim)
boundary_facets = mesh.exterior_facet_indices(domain.topology)
```

```python
boundary_dofs = fem.locate_dofs_topological(V, fdim, boundary_facets)
bc = fem.dirichletbc(uD, boundary_dofs)
```

```python
u = ufl.TrialFunction(V)
v = ufl.TestFunction(V)
```

```python
f = fem.Constant(domain, default_scalar_type(-6))
```

```python
a = ufl.dot(ufl.grad(u), ufl.grad(v)) * ufl.dx
L = f * v * ufl.dx
```

```python
problem = LinearProblem(a, L, bcs=[bc], petsc_options={"ksp_type": "preonly", "pc_type": "lu"})
uh = problem.solve()
```

```python
V2 = fem.functionspace(domain, ("Lagrange", 2))
uex = fem.Function(V2)
uex.interpolate(lambda x: 1 + x[0]**2 + 2 * x[1]**2)
```

```python
L2_error = fem.form(ufl.inner(uh - uex, uh - uex) * ufl.dx)
error_local = fem.assemble_scalar(L2_error)
error_L2 = np.sqrt(domain.comm.allreduce(error_local, op=MPI.SUM))
```

```python
error_max = np.max(np.abs(uD.x.array-uh.x.array))

# Only print the error on one process
if domain.comm.rank == 0:
    print(f"Error_L2 : {error_L2:.2e}")
    print(f"Error_max : {error_max:.2e}")
```

```python
print(pv.global_theme.jupyter_backend)
```

```python
pv.start_xvfb()
domain.topology.create_connectivity(tdim, tdim)
topology, cell_types, geometry = plot.vtk_mesh(domain, tdim)
grid = pv.UnstructuredGrid(topology, cell_types, geometry)
```

```python
plotter = pv.Plotter()
plotter.add_mesh(grid, show_edges=True)
plotter.view_xy()

if not pv.OFF_SCREEN:
    plotter.show()
else:
    figure = plotter.screenshot("fundamentals_mesh.png")
```

```python
u_topology, u_cell_types, u_geometry = plot.vtk_mesh(V)
```

```python
u_grid = pv.UnstructuredGrid(u_topology, u_cell_types, u_geometry)
u_grid.point_data["u"] = uh.x.array.real
u_grid.set_active_scalars("u")

u_plotter = pv.Plotter()
u_plotter.add_mesh(u_grid, show_edges=True)
u_plotter.view_xy()

if not pv.OFF_SCREEN:
    u_plotter.show()
```

```python
warped = u_grid.warp_by_scalar()

plotter2 = pv.Plotter()
plotter2.add_mesh(warped, show_edges=True, show_scalar_bar=True)
if not pv.OFF_SCREEN:
    plotter2.show()
```

```python
results_folder = Path("results")
results_folder.mkdir(exist_ok=True, parents=True)
filename = results_folder / "fundamentals"

with io.VTXWriter(domain.comm, filename.with_suffix(".bp"), [uh]) as vtx:
    vtx.write(0.0)

with io.XDMFFile(domain.comm, filename.with_suffix(".xdmf"), "w") as xdmf:
    xdmf.write_mesh(domain)
    xdmf.write_function(uh)
```

```python

```
