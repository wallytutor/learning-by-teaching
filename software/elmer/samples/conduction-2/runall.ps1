$name = "domain"
$var_geo = "$name/$name.geo"
$var_msh = "$name/$name.msh"

gmsh - $var_geo

ElmerGrid 14 2 $var_msh -autoclean -merge 1.0e-05 -out $name

# ElmerSolver