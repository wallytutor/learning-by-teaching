# Lessons learned

## Resources

- [Dynamic meshes tutorials](http://www.wolfdynamics.com/tutorials.html?id=142)

- [CAD meshing](http://www.wolfdynamics.com/tutorials.html?id=184)

- [OpenFOAM 2112 guide](https://www.openfoam.com/documentation/guides/latest/doc/guide-meshing-snappyhexmesh.html)

## Meshing

- Empty mesh quality dictionary: although we might expect that #OpenFOAM will adopt default values with a non-mandatory key is omitted from a dictionary, that may not always be the case or default values may not correspond to customary values (what is probably the explanation here). During development a bug introduced empty mesh quality dictionaries, leading to completely unresolved surfaces (castellated only).

## PyVista visualization

#PyVista

- [How to compute the length of an extracted edge?](https://github.com/pyvista/pyvista-support/issues/360) This was required when trying to get the characteristic mesh size for automation of background mesh generated with #OpenFOAM/blockMesh.

- [How to get the index of patches from an #format/STL file?](https://github.com/pyvista/pyvista/discussions/5042) This did not actually solve the problem because I was looking for getting the names directly, but it might be useful.



