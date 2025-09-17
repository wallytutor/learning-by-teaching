# Software

## LaTeX

### Math typesetting with LaTeX

- For integrals to display the same size as fractions expanded with `\dfrac`, place a `\displaystyle` in front of the `\int` command.

### Code typesetting with LaTeX

- For some reason `minted` blocks `\begin{minted}...\end{minted}` have problems to render in Beamer (something related to multilevel macros). I managed to insert code blocks with `\inputminted` as reported [here](https://tex.stackexchange.com/questions/159667/including-python-code-in-beamer).

- Beamer have some issues with footnotes, especially when use `column` environments; a quick fix for this is through `\footnotemark` and `\footnotetext[<number>]{<text>}` as described [here](https://tex.stackexchange.com/questions/86650/how-to-display-the-footnote-in-the-bottom-of-the-slide-while-using-columns). Notice that `\footnotemark` automatically generates the counter for use as `<number>` in `\footnotetext`.

- For setting a background watermark in Beamer one can use package `background` and display it using a Beamer template as described [here](https://tex.stackexchange.com/questions/244091/watermark-using-background-package-in-beamer).

### MiKTeX

- [mathkerncmssi source file could not be found](https://tex.stackexchange.com/questions/553716/mathkerncmssi-source-file-could-not-be-found)

- [Installing user packages and classes](https://docs.miktex.org/manual/localadditions.html)

### LaTeX Workshop

- [Configuring builds in VS Code with LaTeX Workshop](https://tex.stackexchange.com/questions/478865/vs-code-latex-workshop-custom-recipes-file-location) for building with `pdflatex`. Finally I ended creating my own workflows in this [file](https://github.com/wallytutor/WallyToolbox.jl/blob/main/tools/vscode/user-data/User/settings.json).

## Visual Studio Code

### Basics

If you are reading this, you are probably using [VS Code](https://code.visualstudio.com/) for the first time or need a refresher! VS Code is Microsoft's open source text editor that has become the most popular editor in the past decade. It is portable (meaning it works in Windows, Linux, and Mac) and relatively light-weight (it won't use all you RAM as some proprietary tools would do). There are a few shortcuts you might want to keep in mind for using this tool in an efficient manner:

- `Ctrl+J`: show/hide the terminal
- `Ctrl+B`: show/hide the project tree
- `Ctrl+Shift+V`: display this file in rendered mode
- `Ctrl+Shift+P`: access the command pallet
- `Ctrl+K Ctrl+T`: change color theme
- `Alt+Z`: toggle column wrapping

A few more tips concerning the terminal:

- `Ctrl+L` gives you a clean terminal (also works inside Julia prompt)
- `Ctrl+D` breaks a program execution (*i.e.* use to quit Julia prompt)

If you copied a command from a tutorial, you **CANNOT** use `Ctrl+V` to paste it into the terminal; in Windows simply right-click the command prompt and it will paste the copied contents. Linux users can `Ctrl+Shift+V` instead.

Notice that `Ctrl+M` will toggle the visibility of the integrated terminal; if you accidentally press it, autocompletion will stop working in terminal. Just press it again and normal behavior will be recovered.

### Extensions

VS Code supports a number of extensions to facilitate coding and data analysis, among other tasks. Local (user-created) extensions can be manually installed by placing their folder under `%USERPROFILE%/.vscode/extensions` or in the equivalent directory documented [here](https://code.visualstudio.com/docs/editor/extension-marketplace#_where-are-extensions-installed). Below you find my recommended extensions for different purposes and languages.

#### Julia

- [Julia](https://github.com/julia-vscode/julia-vscode)
- [Julia Color Themes](https://github.com/CameronBieganek/julia-color-themes)

#### Personal

I have also developed a few (drag-and-drop) extensions; in the future I plan to provided them through the extension manager.

- [wallytutor/elmer-sif-vscode: VS Code extension for Elmer Multiphysics SIF](https://github.com/wallytutor/elmer-sif-vscode)

## Git

### Version control in Windows

- [TortoiseGIT](https://tortoisegit.org/): for Windows users, this applications add the possibility of managing version control and other features directly from the file explorer.

### Creating gh-pages branch

To create a GitHub pages branch with no history do the following

```bash
git checkout --orphan gh-pages
git reset --hard
git commit --allow-empty -m "fresh and empty gh-pages branch"
git push origin gh-pages
```

### Adding submodules

Generally speaking adding a submodule to a repository should be a simple matter of

```bash
git submodule add https://<path>/<to>/<repository>
```

Nonetheless this might fail, especially for large sized repositories; I faced [this issue](https://stackoverflow.com/questions/66366582) which I tried to fix by increasing buffer size as reported in the link. This solved the issue but led me to [another problem](https://stackoverflow.com/questions/59282476) which could be solved by degrading HTTP protocol.

The reverse operation cannot be fully automated as discussed [here](https://stackoverflow.com/questions/1260748). In general you start with

```bash
git rm <path-to-submodule>
```

and then manually remove the history with

```bash
rm -rf .git/modules/<path-to-submodule>

git config remove-section submodule.<path-to-submodule>
```

### Line ending normalization

Instructions provided in [this thread](https://stackoverflow.com/questions/2517190); do not forget to add a `.gitattributes` file to the project with `* text=auto` for checking-in files as normalized. Then run the following:

```bash
git add --update --renormalize
```

## ParaView

- [Getting Started](https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v5.13&type=data&os=Sources&downloadFile=ParaViewGettingStarted-5.13.2.pdf)
- [Video tutorial by Cyprien Rusu](https://www.youtube.com/playlist?list=PLvkU6i2iQ2fpcVsqaKXJT5Wjb9_ttRLK-)
- [Video tutorial at TuxRiders](https://www.youtube.com/playlist?list=PL6fjYEpJFi7W6ayU8zKi7G0-EZmkjtbPo)

### For OpenFOAM

#OpenFOAM/snappyHexMesh #OpenFOAM/snappyHexMesh/resolveFeatureAngle 

An alternative way of extracting feature edges from a geometry for use with `OpenFOAM/snappyHexMesh` is to use filter `Feature Edges` (take care because the feature angle here is the complement, *i.e.* 180-angle, of `resolveFeatureAngle` then convert them to surfaces with filter `Extract Surface` and save results to ASCII #format/VTK format. The conversion to `eMesh` format is done as follows:

```bash
surfaceFeatureConvert constant/geometry/edges.obj constant/geometry/edges.eMesh
```

- #TODO I could not perform the above conversion with the #format/VTK file, but it worked smoothly with an #format/OBJ file (as documented.)

- When creating a clip-plane (or slice) in #ParaView, use option *Crinkle clip* (or *Crinkle slice*) to display cells without actually cutting them (otherwise unreadable).

## FEniCSx

- [FEniCS Project](https://fenicsproject.org/)
- [FEniCSx Documentation](https://docs.fenicsproject.org/)
- [The FEniCSx tutorial](https://jsdokken.com/dolfinx-tutorial/index.html)

## FreeCAD

[FreeCAD](https://www.freecad.org/index.php) is an open source design tool that with its 1.0 release confirmed itself as the leading in the domain. This document aim at maintaining a tutorial of its use for computational mechanics engineers and those in related fields.

### Installation

Go to the [download page](https://www.freecad.org/downloads.php) and get the version for your operating system. For Windows users it is simpler to get the portable version (7z) as it requires no administration rights. Under Linux only [AppImage](https://appimage.org/) bundles are available. More about installation in the [FreeCAD Wiki](https://wiki.freecad.org/Installing_additional_components).

Upon first launch the application will ask for some trivial user preferences setup.

### General usage

- Pressing *Esc* or *right-click* exits a selected tool. Do not press several times to stay in the environment; if accidentally left, click the element on tree and *Edit sketch* if you want to get back to that mode (or any other applicable tool).

- To be able to generate meshes make sure the *Mesh*  workbench is loaded; go to `Edit > Preferences` then enter the `Workbenches > Available workbenches` and load (or even *auto load*) the referred workbench. Note about version *1.0*: the option to export grids in ASCII format is no longer under `Import-Export > Mesh Formats`, see below how to export STL and other file formats.

- The first method to export #format/STL files requires one to activate the *Draft* workbench; select the surface set (holding `Ctrl` for multiple sections); create a named group with the `Facebinder` tool; edit the `Label` in the properties editor; and finally go to `File > Export` and enter the file name with the `.ast` extension. The extension name is what will ensure ASCII format for further use with #OpenFOAM/snappyHexMesh, for instance. This would also work with #format/OBJ by using the proper file extension. In the case of STL files, the contents will start with `solid Mesh`, so it is up to the user to add the region name in the file.

- The [alternative method](https://wiki.freecad.org/Export_to_STL_or_OBJ) to export an #format/STL file starts from the above; instead of exporting the surfaces, activate the *Mesh* workbench; select the surfaces created with `Facebinder` in the tree and use `Create mesh from shape...` tool (notice that you can select everything at once and it will generate a mesh on a surface basis). This will append a *(Meshed)* to the region names, so you will need to edit the labels (keep in mind duplicates are not allowed at project level). Now use `Export mesh...` to write the STL files; in the window you have the `Save as type:` option to select the ASCII format. In this case, surface *inlet* will be exported with `solid inlet`, as required by some tools.

- In all cases, after exporting it is **strongly** recommended to inspect generated grids with a tool such as #MeshLab; in many cases duplicate nodes are generated and can be cleaned there.

### Tutorials

The supported tutorials are provided in [this wiki](https://wiki.freecad.org/Tutorials). It must be noted that not all of them are conceived with a recent version of FreeCAD and *none* (Dec 20th 2024) with the first major release. In what follows we try to focus in part conception for mechanical design, what may include sketching, part conception, and detailed drawings.

### FreeCAD notes

<!-- [FreeCAD 1.0 Tutorial for beginners 2025](https://www.youtube.com/watch?v=jULWgMV9_TM) -->

- Before starting it is recommended to change navigation mode to *Blender* as that is more natural for CAD systems; if you hover the mouse over the selector it will provide tips on buttons.

- One body means one single solid and sketches must be fully constrained.

- Construction geometry is auxiliary to the sketch process only (no 3D participation); first select the geometry to be used as construction only and then switch mode.

- You can click on a face and select to create a sketch on its plane (do not use options, simply click the sketch button and it will do it automatically).

- Create *external geometry* can be used to link sketches/solids of different stages of the model.

- Prefer STEP or STL format for exporting and use models in other 3D CAD systems.

## gmsh

Ongoing...
