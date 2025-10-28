# Scientific computing

Notes related to my learning and teaching interests in several fields related to scientific computing (mostly applied mathematics and machine learning) and related applications. This home page is the entry point and those interested in more content and interesting links navigate below between the multiple pages. It can also be used as a general guide for introducing scientific computing as it tries to introduce the minimal skill set any scientific computing engineer or scientist should have:

- Version control comes first, everything else is worthless without it, currently that means Git.
- Next comes software documentation with Doxygen, Sphinx, and/or Documenter.jl.
- A low(er) level programming language among C, C++, and Fortran, preferably all of them.
- Scripting languages, as of 2024, Python is mandatory, Julia highly recommended.
- Basic machine learning in one of the above scripts, everything is ML these days.
- Shell automation, basis of both Bash/other UNIX shell and PowerShell are required.
- Typesetting equations reports and presentations (beamer) in LaTeX.
- Domain specific skills related to the field of study (CFD, DFT, MD, ML, ...).

A sample setup of an operating system for scientific computing and practicing the above skills is provided in a section dedicated to Ubuntu.

Some technologies have been mainstream or important in the past, but nowadays some of them have already died or are becoming too niche to be put in such a list. That is the case of SVN for version control. As for programming languages in science, that is the case of *matlabish* (MATLAB, Octave, Scilab) environments, which are still used by *controls and automation* people, but are mostly incompatible with good software practices and should be discouraged.

It is also worth getting familiar with high-performance computing (HPC); in the [Top 500](https://top500.org/) page you can get to know the most powerful computers on Earth.  The [specification benchmarking](https://spec.org/) page allows for the check of hardware specification, what is interesting when preparing investment in a computing structure. Lastly, when working in multi-user systems it is worth knowing about job management systems such as [Slurm](https://www.schedmd.com/).

As a last word, I would like to remember that it is humanly impossible to master everything at once; even after more than 10 years in the field as of today I only have a grasp in the tools I do not use everyday. Software and methods evolve, and unless you keep using a specific tool you simply cannot afford to keep up to date with it. That should not be a roadblock for a scientist in the long term. As you get used to scientific software, getting back to a good level of some tool you used in the past is quick (but not extremely fast in some cases) and learning new tools for which you already know the science behind is trivial. Even exploring new fields become easy in some cases.

## Command line basics

If this is you first time using the command prompt you might be interested by this section. The command prompt (often referred to as *terminal* in Linux world) is your interface to interact with the operating system and many available tools. To learn any useful scientific computing skills it is useful to get a grasp of its use because it is there that we will launch most applications. The illustrations below assume you are working under Windows, but the introductory commands are common to most operating systems.

Now let's launch a terminal. If you are working under VS Code you can use the shortcut to display the terminal `Ctrl+J`; the bottom of your window should display something as

```console
PS D:\Kompanion>
```

The start of this line displays you *path* in the system; depending on your configuration that could not be the case and you can ask the OS to give you that with `pwd` (print working directory)

```console
PS D:\Kompanion> pwd

Path
----
D:\Kompanion
```

If you are invited to move to directory `src` you may which to use command *change directory*, or `cd` in the system's language

```console
PS D:\Kompanion> cd .\bin\
PS D:\Kompanion\bin>
```

Now that you reached your destination, you might be interested at inspecting the contents of this directory, *i.e.* listing its contents; that is done with `ls` as follows

```console
PS D:\Kompanion\bin> ls


    Directory: D:\Kompanion\bin


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----         1/31/2025  11:11 AM                apps
d-----          2/3/2025   9:19 AM                data
d-----         1/30/2025   2:34 PM                downloads
d-----          2/3/2025  11:50 AM                pkgs
d-----         1/31/2025   9:33 AM                scripts
d-----         1/30/2025   9:58 AM                tests
-a----         1/31/2025   9:33 AM           2697 activate.bat
-a----         1/30/2025   9:58 AM            161 code.bat
-a----         1/30/2025   9:58 AM            132 kode.bat
-a----         1/30/2025   9:58 AM            131 kpip.bat
```

Oops! It was not the directory you wanted to go to! No problems, you can navigate *one-level-upwards* using the special symbol `..` (two dots) and change directory again

```console
PS D:\Kompanion\bin> cd ..\docs\
PS D:\Kompanion\docs>
```

This is the minimum you need to know: navigate, know your address, inspect contents.
