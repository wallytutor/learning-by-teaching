# FreeCAD

[FreeCAD](https://www.freecad.org/index.php) is an open source design tool that with its 1.0 release confirmed itself as the leading in the domain. This document aim at maintaining a tutorial of its use for computational mechanics engineers and those in related fields.

## Installation

Go to the [download page](https://www.freecad.org/downloads.php) and get the version for your operating system. For Windows users it is simpler to get the portable version (7z) as it requires no administration rights. Under Linux only [AppImage](https://appimage.org/) bundles are available. More about installation in the [FreeCAD Wiki](https://wiki.freecad.org/Installing_additional_components).

Upon first launch the application will ask for some trivial user preferences setup.

## General usage

- Pressing *Esc* or *right-click* exits a selected tool. Do not press several times to stay in the environment; if accidentally left, click the element on tree and *Edit sketch* if you want to get back to that mode (or any other applicable tool).

- To be able to generate meshes make sure the *Mesh*  workbench is loaded; go to `Edit > Preferences` then enter the `Workbenches > Available workbenches` and load (or even *auto load*) the referred workbench. Note about version *1.0*: the option to export grids in ASCII format is no longer under `Import-Export > Mesh Formats`, see below how to export STL and other file formats.

- The first method to export #format/STL files requires one to activate the *Draft* workbench; select the surface set (holding `Ctrl` for multiple sections); create a named group with the `Facebinder` tool; edit the `Label` in the properties editor; and finally go to `File > Export` and enter the file name with the `.ast` extension. The extension name is what will ensure ASCII format for further use with #OpenFOAM/snappyHexMesh, for instance. This would also work with #format/OBJ by using the proper file extension. In the case of STL files, the contents will start with `solid Mesh`, so it is up to the user to add the region name in the file.

- The [alternative method](https://wiki.freecad.org/Export_to_STL_or_OBJ) to export an #format/STL file starts from the above; instead of exporting the surfaces, activate the *Mesh* workbench; select the surfaces created with `Facebinder` in the tree and use `Create mesh from shape...` tool (notice that you can select everything at once and it will generate a mesh on a surface basis). This will append a *(Meshed)* to the region names, so you will need to edit the labels (keep in mind duplicates are not allowed at project level). Now use `Export mesh...` to write the STL files; in the window you have the `Save as type:` option to select the ASCII format. In this case, surface *inlet* will be exported with `solid inlet`, as required by some tools.

- In all cases, after exporting it is **strongly** recommended to inspect generated grids with a tool such as #MeshLab; in many cases duplicate nodes are generated and can be cleaned there.

## Tutorials

The supported tutorials are provided in [this wiki](https://wiki.freecad.org/Tutorials). It must be noted that not all of them are conceived with a recent version of FreeCAD and *none* (Dec 20th 2024) with the first major release. In what follows we try to focus in part conception for mechanical design, what may include sketching, part conception, and detailed drawings.
