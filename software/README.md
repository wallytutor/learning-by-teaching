# Software

## Scientific Computing

Notes related to my learning and teaching interests in several fields related to scientific computing (mostly applied mathematics and machine learning) and related applications. This home page is the entry point and those interested in more content and interesting links navigate below between the multiple pages. It can also be used as a general guide for introducing scientific computing as it tries to introduce the minimal skill set any scientific computing engineer or scientist should have:

- Version control comes first, everything else is worthless without it, currently that means Git.
- Next comes software documentation with Doxygen, Sphinx, and/or Documenter.jl.
- A low(er) level programming language among C, C++, and Fortran, preferably all of them.
- Scripting languages, as of 2024, Python is mandatory, Julia highly recommended.
- Basic machine learning in one of the above scripts, everything is ML these days.
- Shell automation, basis of both Bash/other UNIX shell and PowerShell are required.
- Typesetting equations reports and presentations (beamer) in LaTeX.
- Domain specific skills related to the field of study (CFD, DFT, MD, ML, ...).

Some technologies have been mainstream or important in the past, but nowadays some of them have already died or are becoming too niche to be put in such a list. That is the case of SVN for version control. As for programming languages in science, that is the case of *matlabish* (MATLAB, Octave, Scilab) environments, which are still used by *controls and automation* people, but are mostly incompatible with good software practices and should be discouraged.

It is also worth getting familiar with high-performance computing (HPC); in the [Top 500](https://top500.org/) page you can get to know the most powerful computers on Earth.  The [specification benchmarking](https://spec.org/) page allows for the check of hardware specification, what is interesting when preparing investment in a computing structure. Lastly, when working in multi-user systems it is worth knowing about job management systems such as [Slurm](https://www.schedmd.com/).

As a last word, I would like to remember that it is humanly impossible to master everything at once; even after more than 10 years in the field as of today I only have a grasp in the tools I do not use everyday. Software and methods evolve, and unless you keep using a specific tool you simply cannot afford to keep up to date with it. That should not be a roadblock for a scientist in the long term. As you get used to scientific software, getting back to a good level of some tool you used in the past is quick (but not extremely fast in some cases) and learning new tools for which you already know the science behind is trivial. Even exploring new fields become easy in some cases.

## General purpose

1. [General tips](general.md)
2. [Git version control](git.md)
3. [Work on Windows](windows.md)
4. [Work on Linux](linux.md)
5. [LaTeX typesetting](latex.md)
6. [Regex tips](regex.md)
7. [VS Code](vscode.md)
8. [Command line](cli.md) 

## Scientific software

### Geometry

- [blender](https://www.blender.org/): the most powerful 3D (in the general sense) open source modeling tool; allows geometries to be exported to STL, which is compatible with most meshing software.

- [FreeCAD](freecad/basics.md): contrarily to [blender](https://www.blender.org/), this is the most mature open source modeling tool in the technical sense. It supports both 3D conception and detailed drawing, among other features.

- [cadquery](https://github.com/CadQuery/cadquery?tab=readme-ov-file): a simple parametric geometry tool.

### Meshing

-  [gmsh](gmsh/basics.md): the *to-go* meshing tool for 2D geometries and visualization of many formats of 3D meshes; before trying to produce reliable structured meshes and geometry in 3D some ninja skills need to be developed. Its own scripting language makes parametric meshing easy.

- [MeshLab](https://github.com/cnr-isti-vclab/meshlab): allows to manipulate triangulated grids generated in CAD; helpful for preparing patches for use with #OpenFOAM/snappyHexMesh .

### Rendering

- [ParaView](paraview/basics.md): the *de facto* post-processing tool for many fields of application. 
 
- [trame](https://kitware.github.io/trame/): rendering results in web-applications.

### Simulation

- [Elmer](elmer/README.md): multiphysics FEM toolkit.

- [OpenFOAM](openfoam/README.md): general purpose FVM CFD toolkit.

- [TRUST Platform](https://cea-trust-platform.github.io/):  the basis for [TrioCFD](https://github.com/cea-trust-platform/TrioCFD-code) code by CEA.

### Productivity

- [logseq/logseq](https://github.com/logseq/logseq): A privacy-first, open-source platform for knowledge management and collaboration.

- [standardnotes/app](https://github.com/standardnotes/app): Think fearlessly with end-to-end encrypted notes and files.

- [laurent22/joplin](https://github.com/laurent22/joplin/): Joplin - the privacy-focused note taking app with sync capabilities for Windows, macOS, Linux, Android and iOS.

- [Zettlr/Zettlr](https://github.com/Zettlr/Zettlr): Your One-Stop Publication Workbench

### Other

- [protobuf](https://protobuf.dev/getting-started/pythontutorial/): for parsing #OpenFOAM dictionaries from Python.