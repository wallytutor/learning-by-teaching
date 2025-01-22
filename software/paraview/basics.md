# ParaView

- [Video tutorial by Cyprien Rusu](https://www.youtube.com/playlist?list=PLvkU6i2iQ2fpcVsqaKXJT5Wjb9_ttRLK-)
- [Video tutorial at TuxRiders](https://www.youtube.com/playlist?list=PL6fjYEpJFi7W6ayU8zKi7G0-EZmkjtbPo)

## For OpenFOAM

#OpenFOAM/snappyHexMesh #OpenFOAM/snappyHexMesh/resolveFeatureAngle 

An alternative way of extracting feature edges from a geometry for use with `OpenFOAM/snappyHexMesh` is to use filter `Feature Edges` (take care because the feature angle here is the complement, *i.e.* 180-angle, of `resolveFeatureAngle` then convert them to surfaces with filter `Extract Surface` and save results to ASCII #format/VTK format. The conversion to `eMesh` format is done as follows:

```bash
surfaceFeatureConvert constant/geometry/edges.obj constant/geometry/edges.eMesh
```

- #TODO I could not perform the above conversion with the #format/VTK file, but it worked smoothly with an #format/OBJ file (as documented.)

- When creating a clip-plane (or slice) in #ParaView, use option *Crinkle clip* (or *Crinkle slice*) to display cells without actually cutting them (otherwise unreadable).