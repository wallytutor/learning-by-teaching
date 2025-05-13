gmsh - "domain/domain.geo"

ElmerGrid 14 2 "domain/domain.msh" -autoclean -merge 1.0e-05 -out "domain"

ElmerGrid 2 2 domain/ -partdual -metiskway 4

# mpiexec -n 4 ElmerSolver_mpi > log.solver
# ElmerSolver > log.solver
