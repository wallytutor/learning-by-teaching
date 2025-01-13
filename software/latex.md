# $\LaTeX$

## Math typesetting with $\LaTeX$

- For integrals to display the same size as fractions expanded with `\dfrac`, place a `\displaystyle` in front of the `\int` command.

## Code typesetting with $\LaTeX$

- For some reason `minted` blocks `\begin{minted}...\end{minted}` have problems to render in Beamer (something related to multilevel macros). I managed to insert code blocks with `\inputminted` as reported [here](https://tex.stackexchange.com/questions/159667/including-python-code-in-beamer).

- Beamer have some issues with footnotes, especially when use `column` environments; a quick fix for this is through `\footnotemark` and `\footnotetext[<number>]{<text>}` as described [here](https://tex.stackexchange.com/questions/86650/how-to-display-the-footnote-in-the-bottom-of-the-slide-while-using-columns). Notice that `\footnotemark` automatically generates the counter for use as `<number>` in `\footnotetext`.

- For setting a background watermark in Beamer one can use package `background` and display it using a Beamer template as described [here](https://tex.stackexchange.com/questions/244091/watermark-using-background-package-in-beamer).

## MiKTeX

- [mathkerncmssi source file could not be found](https://tex.stackexchange.com/questions/553716/mathkerncmssi-source-file-could-not-be-found)

- [Installing user packages and classes](https://docs.miktex.org/manual/localadditions.html)

## LaTeX Workshop

- [Configuring builds in VS Code with LaTeX Workshop](https://tex.stackexchange.com/questions/478865/vs-code-latex-workshop-custom-recipes-file-location) for building with `pdflatex`. Finally I ended creating my own workflows in this [file](https://github.com/wallytutor/WallyToolbox.jl/blob/main/tools/vscode/user-data/User/settings.json).
