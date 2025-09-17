# OpenFOAM

OpenFOAM is an open source computational fluid dynamics (CFD) toolbox; as a matter of fact, its breadth of use go far way CFD, including some uses in other fields of computational mechanics and even economics. It comes in two main flavors, [OpenFOAM *ESI*](https://www.openfoam.com/) and [OpenFOAM *CFD Direct*](https://openfoam.org/). The core libraries of these were at some moment common, but now they seem to have diverged and conciliation of use will soon no longer be possible.

For container usage guide please check the dedicated section.

## Glossary

- *Non-manifold edges*: edges with more than two connected faces; used in #OpenFOAM/snappyHexMesh/surfaceFeatures dictionary.

- *Open edges*: edges with a single connected face; used in #OpenFOAM/snappyHexMesh/surfaceFeatures dictionary.

## Main documentation *CFD Direct*

<table>
  <tr>
    <td width="64px" height="64px" style="vertical-align: middle;">
        <img src="https://cdn.openfoam.org/wp-content/uploads/2016/05/CFDfoundationLogoDark-600x600.png" alt="logo" />
    </td>
    <td>
      <a href="https://cpp.openfoam.org/v11/" target="_blank">
          Source Guide
      </a>
    </td>
  </tr>
  <tr>
    <td width="64px" height="64px" style="vertical-align: middle;">
        <img src="https://doc.cfd.direct/assets/img/CFDdirectLogoSq800080-85x85.png" alt="logo" />
    </td>
    <td>
      <a href="https://doc.cfd.direct/openfoam/user-guide-v11/contents" target="_blank">
          User Guide
      </a>
    </td>
  </tr>
  <tr>
    <td width="64px" height="64px" style="vertical-align: middle;">
        <img src="https://doc.cfd.direct/assets/img/CFDdirectLogoSq800080-85x85.png" alt="logo" />
    </td>
    <td>
      <a href="https://doc.cfd.direct/notes/cfd-general-principles/" target="_blank">
          CFD Book
      </a>
    </td>
  </tr>
  <tr>
    <td width="64px" height="64px" style="vertical-align: middle;">
        <img src="https://doc.cfd.direct/assets/img/CFDdirectLogoSq800080-85x85.png" alt="logo" />
    </td>
    <td>
      <a href="https://doc.cfd.direct/openfoam/user-guide-v11/standard-utilities" target="_blank">
          Standard Utilities
      </a>
    </td>
  </tr>
  <tr>
    <td width="64px" height="64px" style="vertical-align: middle;">
        <img src="https://doc.cfd.direct/assets/img/CFDdirectLogoSq800080-85x85.png" alt="logo" />
    </td>
    <td>
      <a href="https://doc.cfd.direct/openfoam/user-guide-v11/solvers-modules" target="_blank">
          Solver Modules
      </a>
    </td>
  </tr>
</table>

## Main documentation *ESI*

<table>
  <tr>
    <td width="64px" height="64px" style="vertical-align: middle;">
        <img src="https://develop.openfoam.com/uploads/-/system/appearance/header_logo/1/nabla7272.png" alt="logo" />
    </td>
    <td>
      <a href="https://www.openfoam.com/documentation/overview" target="_blank">
          Documentation Overview
      </a>
    </td>
  </tr>
  <tr>
    <td width="64px" height="64px" style="vertical-align: middle;">
        <img src="https://develop.openfoam.com/uploads/-/system/appearance/header_logo/1/nabla7272.png" alt="logo" />
    </td>
    <td>
      <a href="https://www.openfoam.com/documentation/user-guide" target="_blank">
          User Guide
      </a>
    </td>
  </tr>
  <tr>
    <td width="64px" height="64px" style="vertical-align: middle;">
        <img src="https://develop.openfoam.com/uploads/-/system/appearance/header_logo/1/nabla7272.png" alt="logo" />
    </td>
    <td>
      <a href="https://doc.openfoam.com/2312/" target="_blank">
          Documentation
      </a>
    </td>
  </tr>
  <tr>
    <td width="64px" height="64px" style="vertical-align: middle;">
        <img src="https://develop.openfoam.com/uploads/-/system/appearance/header_logo/1/nabla7272.png" alt="logo" />
    </td>
    <td>
      <a href="https://www.openfoam.com/documentation/guides/latest/doc/guide-function-objects.html" target="_blank">
          Function objects
      </a>
    </td>
  </tr>
  <tr>
    <td width="64px" height="64px" style="vertical-align: middle;">
        <img src="https://develop.openfoam.com/uploads/-/system/appearance/header_logo/1/nabla7272.png" alt="logo" />
    </td>
    <td>
      <a href="https://www.openfoam.com/documentation/guides/v2112/doc/index.html" target="_blank">
          Source Guide 2112 (Docs)
      </a>
    </td>
  </tr>
  <tr>
    <td width="64px" height="64px" style="vertical-align: middle;">
        <img src="https://develop.openfoam.com/uploads/-/system/appearance/header_logo/1/nabla7272.png" alt="logo" />
    </td>
    <td>
      <a href="https://www.openfoam.com/documentation/guides/v2112/api/index.html" target="_blank">
          Source Guide 2112 (API)
      </a>
    </td>
  </tr>
</table>

## Other links

<table>
  <tr>
    <td width="64px" height="64px" style="vertical-align: middle;">
        <img src="https://holzmann-cfd.com/templates/holzmanncfd/images/logo.png" alt="logo" />
    </td>
    <td>
      <a href="https://holzmann-cfd.com/" target="_blank">
        Holzmann CFD
      </a>
    </td>
  </tr>
  <tr>
    <td width="64px" height="64px" style="vertical-align: middle;">
        <img src="https://www.cfdyna.com/Logo.png" alt="logo" />
    </td>
    <td>
      <a href="https://www.cfdyna.com/Home/OF_Combustion.html" target="_blank">
          Combustion Simulation (CFDDyna)
      </a>
    </td>
  </tr>
</table>

## Resources

- [Dynamic meshes tutorials](http://www.wolfdynamics.com/tutorials.html?id=142)

- [CAD meshing](http://www.wolfdynamics.com/tutorials.html?id=184)

- [OpenFOAM 2112 guide](https://www.openfoam.com/documentation/guides/latest/doc/guide-meshing-snappyhexmesh.html)

## Lessons learned

### Meshing

- Empty mesh quality dictionary: although we might expect that #OpenFOAM will adopt default values with a non-mandatory key is omitted from a dictionary, that may not always be the case or default values may not correspond to customary values (what is probably the explanation here). During development a bug introduced empty mesh quality dictionaries, leading to completely unresolved surfaces (castellated only).

### PyVista visualization

#PyVista

- [How to compute the length of an extracted edge?](https://github.com/pyvista/pyvista-support/issues/360) This was required when trying to get the characteristic mesh size for automation of background mesh generated with #OpenFOAM/blockMesh.

- [How to get the index of patches from an #format/STL file?](https://github.com/pyvista/pyvista/discussions/5042) This did not actually solve the problem because I was looking for getting the names directly, but it might be useful.

## BlockMesh

Although #OpenFOAM/snappyHexMesh  is a pretty powerful tool, it relies on the simpler #OpenFOAM/blockMesh utility for background meshing generation. By itself, `blockMesh` is not very useful for other things than conceiving simple domains for conceptual applications mainly in academic research.

In its simplest use, `blockMesh` can be used to create a simple bounding box around the geometry to be castellated and snapped; there might be other cases where *intelligent* grading of bounding box meshes can be useful and this document seeks to document the use of the tool to cover those ends in a better way than its official documentation does.

By the end the reader should be able to check the following boxes:

- [ ] Declaring vertices
- [ ] Creating blocks
- [ ] Simple grading of blocks
- [ ] Multiple grading of blocks
- [ ] Edges
- [ ] Named boundary
- [ ] Merging patch pairs

### Simple bounding box

...

### Including simple grading

...

### More complex grading

...

### Merging blocks

...

### Creating edges

...

## SnappyHexMesh

### Creating a geometry

There are a few considerations to make when creating a geometry for meshing with #OpenFOAM/snappyHexMesh ; although both OBJ and STL formats are supported, here we stick with STL only for being a popular format compatible with many CAD tools. Whether you are handling an internal or external flow, consider the following steps:

- Create a STL file from the whole geometry (if exporting from a CAD software, consider exporting all parts to a single STL file). Keep this file for reworking or modifications that might be required later on.

- For fine control of refinement, it is easier to work with separate STL files *per patch*; this is sort of inconvenient but is the way to go for now. So before proceeding *explode* your parent STL file in as many files as patches you need to create. If you modify the parent file, keep in mind you might need to export again the separate patches (at least those that were impacted by the editions).  If for some reason you need to add the patches together (*parent corrupted?*), triangulations in STL format can be simply joined with `cat`:

```bash
cat input-1.stl input-2.stl > merged.stl
```

- #TODO in the above joining idea, one could conceive an automated patch splitting if STL generation software kept right names in different regions!

- Files must be exported in raw text format STL; if you are working with a file *per patch*, this impacts all patch files and the parent file can be kept in binary format. Otherwise (working with a single STL file) the parent file needs to be saved in ASCII format.

 - Edit the patch name in the first/last line of all STL files. The first line must read `solid <patch-name>` and the last `endsolid <patch-name>`. By default STL editing software places a random string there (sometimes related to the file name) or something else. #TODO: check if this is still a requirement, some of the tutorials we have do not respect this.

- In the the `OpenFOAM` case, save generated files to `constant/geometry/`; if the case will have many variants, the recommended practice is to keep the parent and exported files in the reference setup case and clone the generated mesh to the variant cases (except in case of mesh resolution studies, when you might need the STL files back again for reworking the mesh).

- Keep note of the unit system used for STL conception. By default `OpenFOAM` will require SI units, so stick to meters and preferably convert units before exporting the STL file/patches if possible. Otherwise one can carry unit transformations with #OpenFOAM/surfaceTransformPoints. Convert a triangulation from millimeters to meters as follows:

```bash
surfaceTransformPoints           \
    -scale '(0.001 0.001 0.001)' \
    <input.stl>                  \
    <output.stl>
```

### Adding geometry to mesh

The STL files that you can add to the mesh are found under `constant/geometry/` as discussed in the previous section. To add one of these files for meshing one needs to create an entry under `geometry` sub-dictionary of type `triSurfaceMesh`. A minimal example would be for adding file `cylinder.stl` referring to patch name `cylinder` is:

```C
geometry
{
    // This is how it will be called in OpenFOAM.
    cylinder
    {
        // Type specification for STL files.
        type triSurfaceMesh;

        // Just the name of the STL file.
        file "cylinder.stl";
    }
}
```

#OpenFOAM/snappyHexMesh/refinementSurfaces #OpenFOAM/blockMesh #OpenFOAM/snappyHexMesh/castellatedMeshControls 

Notice that this is probably not enough for *really* detecting the surface in `snappyHexMesh` because in the absence of an entry under `refinementSurfaces` it will be meshing the inside and outside of the geometry, what most probably is not what you are looking for. Furthermore, you will be starting from a background mesh generated by `blockMesh` which might be coarse. If the features of the added geometry are much smaller than the background mesh, it will simply produce an almost random-looking grid inside the background mesh. This is why you *mandatorily* need to add an entry to sub-dictionary `refinementSurfaces` under `castellatedMeshControls` so that the surface is properly resolved. For the present case that is:

```C
refinementSurfaces
{
    // Patch name as defined under `geometry`.
    cylinder
    {
        // Global and curvature refinement levels
        // (according to `resolveFeatureAngle`).
        level (2  4);
    }
}
```
