gmsh - "domain/domain.geo"
ElmerGrid 14 2 "domain/domain.msh" -autoclean -merge 1.0e-05 -out "domain"
ElmerSolver > log.solver
