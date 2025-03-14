# Visual Studio Code

## Basics

If you are reading this, you are probably using [VS Code](https://code.visualstudio.com/) for the first time or need a refresher! VS Code is Microsoft's open source text editor that has become the most popular editor in the past decade. It is portable (meaning it works in Windows, Linux, and Mac) and relatively light-weight (it won't use all you RAM as some proprietary tools would do). There are a few shortcuts you might want to keep in mind for using this tool in an efficient manner:

- `Ctrl+J`: show/hide the [terminal](cli.md)
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

## Extensions

VS Code supports a number of extensions to facilitate coding and data analysis, among other tasks. Local (user-created) extensions can be manually installed by placing their folder under `%USERPROFILE%/.vscode/extensions` or in the equivalent directory documented [here](https://code.visualstudio.com/docs/editor/extension-marketplace#_where-are-extensions-installed). Below you find my recommended extensions for different purposes and languages.

### Julia

- [Julia](https://github.com/julia-vscode/julia-vscode)
- [Julia Color Themes](https://github.com/CameronBieganek/julia-color-themes)

### Personal

I have also developed a few (drag-and-drop) extensions; in the future I plan to provided them through the extension manager.

- [wallytutor/elmer-sif-vscode: VS Code extension for Elmer Multiphysics SIF](https://github.com/wallytutor/elmer-sif-vscode)
