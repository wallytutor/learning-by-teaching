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

from dolfinx import default_scalar_type

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
from dolfinx.mesh import CellType

from dolfinx.plot import vtk_mesh
from dolfinx.io import VTXWriter
from dolfinx.io import XDMFFile

from ufl import TrialFunction
from ufl import TestFunction
from ufl import inner
from ufl import grad
from ufl import dx

import pyvista as pv
import numpy as np
import ufl
```

```python
print(pv.global_theme.jupyter_backend)
pv.start_xvfb()
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
\int_{\Omega}\nabla{u}\cdotp{}\nabla{v}\,dx
-\int_{\partial\Omega}(\nabla{u})\cdotp{}v\cdotp{}\vec{n}\,ds=
\int_{\Omega}fv\,dx
$$

Because variational principle requires $v$ to vanish where trial function $u$ is knonw, *i.e.* a Dirichlet boundary:

$$
\int_{\Omega}\nabla{u}\cdotp{}\nabla{v}\,dx=
\int_{\Omega}fv\,dx\qquad\forall{v}\in\hat{V}
$$

Passing this variational problem into discrete trial and test functional spaces writes:

$$
\int_{\Omega}\nabla{u_h}\cdotp{}\nabla{v}\,dx=
\int_{\Omega}fv\,dx\qquad\forall{v}\in\hat{V}_h, u_h\in{}V_h
$$


In what follows we make use of $u_e=1+x^2+2y^2$ so that $-\nabla^2u_e=f=-6$ so that we can check the numerical results against this exact solution; domain will be a unit square $\Omega=[0,1]\times[0,1]$.

- Define the exact solution function for projection:

```python
def exact_solution(x):
    return 1 + x[0]**2 + 2 * x[1]**2
```

- Create an $n_x\times{}n_y$ quadrilateral mesh for the domain:

```python
nx = ny = 8
domain = create_unit_square(MPI.COMM_WORLD, nx, ny, 
                            cell_type=CellType.quadrilateral, 
                            dtype=np.float64)

tdim = domain.topology.dim
fdim = tdim - 1
```

- Create an unstructured grid that can be used by `pyvista`:

```python
domain.topology.create_connectivity(tdim, tdim)
topology, cell_types, geometry = vtk_mesh(domain, tdim)
grid = pv.UnstructuredGrid(topology, cell_types, geometry)
```

- Display the 2D mesh for verification:

```python
plotter = pv.Plotter()
plotter.add_mesh(grid, show_edges=True)
plotter.view_xy()
plotter.show()
```

- Define the finite element function space $V$:

```python
V1 = functionspace(domain, ("Lagrange", 1))
V2 = functionspace(domain, ("Lagrange", 2))
```

- Project *known* boundary condition on function space $V$ for B.C. (`uD`) and exact solution (`uE`):

```python
uD = Function(V1)
uD.interpolate(exact_solution)

uE = Function(V2)
uE.interpolate(exact_solution)
```

- Create facet to cell connectivity, then determine boundary facets with `dolfinx.mesh.exterior_facet_indices`:

```python
domain.topology.create_connectivity(fdim, tdim)
boundary_facets = exterior_facet_indices(domain.topology)
```

- Retrieve indices of *DoFs* with `dolfinx.fem.locate_dofs_topological` and apply boundary condition:

```python
boundary_dofs = locate_dofs_topological(V1, fdim, boundary_facets)

bc = dirichletbc(uD, boundary_dofs)
```

- Defining the trial and test function on space $V$ using `ufl` types:

```python
u = TrialFunction(V1)
v = TestFunction(V1)
```

- Use `dolfinx.fem.Constant` to declare $f$ so that its value can be changed without recompilation later:

```python
f = Constant(domain, default_scalar_type(-6))
```

- Define the variational problem using `ufl` operators with a Python syntax closely related to its mathematical formulation:

```python
a = inner(grad(u), grad(v)) * dx
L = f * v * dx
```

- Use PETSc to solve the linear problem through LU factorization:

```python
petsc_options = {"ksp_type": "preonly", "pc_type": "lu"}
problem = LinearProblem(a, L, bcs=[bc], petsc_options=petsc_options)
uh = problem.solve()
```

- Compute the error of numerical solution against exact solution (interpolated in space $P_2$):

```python
def l2_norm_error(u_h, u_e):
    E = inner(u_h - u_e, u_h - u_e) * dx
    error_local = assemble_scalar(form(E))

    # XXX: assemble_scalar works in a single process, use MPI reduction
    # to compute over all the processes for parallel problems!
    return np.sqrt(domain.comm.allreduce(error_local, op=MPI.SUM))
```

```python
error_l2 = l2_norm_error(uh, uE)
error_lm = np.max(np.abs(uD.x.array - uh.x.array))

# Only print the error on one process
if domain.comm.rank == 0:
    print(f"Error L2  : {error_l2:.2e}")
    print(f"Error max : {error_lm:.2e}")
```

- Create a mesh based on the function space *DoFs* as it is disconnected from base mesh:

```python
u_topology, u_cell_types, u_geometry = vtk_mesh(V1)
u_grid = pv.UnstructuredGrid(u_topology, u_cell_types, u_geometry)

u_grid.point_data["u"] = uh.x.array.real
_ = u_grid.set_active_scalars("u")
```

- Plot solution projection in 2D:

```python
u_plotter = pv.Plotter()
u_plotter.add_mesh(u_grid, show_edges=True, cmap="jet")
u_plotter.view_xy()
u_plotter.show()
```

- We can also warp the mesh by scalar to make use of the 3D plotting:

```python
warped = u_grid.warp_by_scalar()

plotter2 = pv.Plotter()
plotter2.add_mesh(warped, show_edges=True, show_scalar_bar=True, cmap="jet")
plotter2.show()
```

- Results can also be dumped for post-processing with Paraview:

```python
results_folder = Path("results")
results_folder.mkdir(exist_ok=True, parents=True)
filename = results_folder / "fundamentals"

with VTXWriter(domain.comm, filename.with_suffix(".bp"), [uh]) as vtx:
    vtx.write(0.0)

with XDMFFile(domain.comm, filename.with_suffix(".xdmf"), "w") as xdmf:
    xdmf.write_mesh(domain)
    xdmf.write_function(uh)
```
