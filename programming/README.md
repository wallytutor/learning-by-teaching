# Programming

This page provides access to programming learning materials and related links. If this subject is new to you, to be able to successfully follow the contents you might learn a bit about the environment we will use, [VS Code](../software/vscode.md) and the minimum about [command prompt](../software/cli.md). If you are planning to start a career in scientific computing, there is also a short [article](../software/scientific.md) that might help you find your way through this broad field.

## Coding practices

It is not worth learning any programming before being introduced to the good practices. Many programmers I know write *garbage that works for them only*. It is impossible to have a healthy collaboration if code is not standardized, reason why I place this highly biased introduction here.

One of the reasons [Guido van Rossum](https://en.wikipedia.org/wiki/Guido_van_Rossum) created Python is because he wanted code to be readable. You should be able to guess what some code is doing even without specific technical knowledge about the language. This is probably the mean feature that made its creation so popular in the scientific world.

Although they are applicable to Python, the practices recommended in the famous [PEP8](https://peps.python.org/pep-0008/) can be extended to other languages, including Julia. You should **read PEP8 religiously**. That document describes how to write clean and maintainable Python code. When transposing that to Julia, the minimum you are expected to do is:

- lines are limited to 79 characters
- use spaces around all operators
- consistent indentation with spaces
- blank lines around structural blocks
- lower case variable names
- Pascal-case structure names
- use underscore to separate words
- document functions properly

When you code, remember that most of the time what you are doing will be reviewed/used by somebody else and that person might not be in the mood to decipher the cryptic code you wrote; it that person is myself, **I will promptly refuse to help you** with badly written code. For newcomers, it is always better to talk about this before you write your first lines because once you stick to bad practices you will hardly ever leave them. Before you write something new, check if your ideas are also consistent with [PEP20](https://peps.python.org/pep-0020/).

Julia has its own [stylistic conventions](https://docs.julialang.org/en/v1/manual/variables/#Stylistic-Conventions) that are simpler than PEP8; the main differences are the way to name functions (it recommends to *glue* words and use no underscore) and the *exclamation mark !* indicating a function modifies it(s) argument(s). For function naming you may chose to stick to PEP8 recommendation, what is my personal choice. The detailed document is found [here](https://docs.julialang.org/en/v1/manual/style-guide/).

Python code documentation is generally done with [Sphinx](https://www.sphinx-doc.org/en/master/). For [documenting code](https://docs.julialang.org/en/v1/manual/documentation/#Syntax-Guide) Julia has its own syntax which can be used to generate package documentation with help of [Documenter.jl](https://documenter.juliadocs.org/stable/). 

**Important:** Julia supports [Unicode input](https://docs.julialang.org/en/v1/manual/unicode-input/), but its use is highly discouraged in modules. Unicode characters are better suited to write application scripts such as notebooks (in Pluto or Jupyter).

## Julia

1. [Julia 101](julia/101.md)

## Python
