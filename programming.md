# Programming

This page provides access to programming learning materials and related links. If this subject is new to you, to be able to successfully follow the contents you might learn a bit about the environment we will use, [VS Code](../software/vscode.md) and the minimum about [command prompt](../software/cli.md). If you are planning to start a career in scientific computing, there is also a short introduction [here](../software/README.md) that might help you find your way through this broad field.

Sample projects are found [here](projects/README.md).

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

Python code documentation is generally done with [Sphinx](https://www.sphinx-doc.org/en/master/). Julia has its own [syntax](https://docs.julialang.org/en/v1/manual/documentation/#Syntax-Guide) which can be used to generate package documentation with help of [Documenter.jl](https://documenter.juliadocs.org/stable/). 

**Important:** Julia supports [Unicode input](https://docs.julialang.org/en/v1/manual/unicode-input/), but its use is highly discouraged in modules. Unicode characters are better suited to write application scripts such as notebooks (in Pluto or Jupyter).

## Julia

[Julia from zero to hero (for Scientific Computing)!](programming/julia/julia.md)

**Important:** the following course may assume you are using a redistributable version of Julia packaged as described [here](https://github.com/wallytutor/julia101/tree/main). This might be useful for instructors willing to work without internet access.

## Python

*Upcoming*

## Scientific publishing

The following tools might be of interest for creating scientific content with embedded code.

- [Jupytext documentation](https://jupytext.readthedocs.io/en/latest/)
- [Jupyter Book](https://jupyterbook.org/en/stable/intro.html)
- [Weave.jl - Scientific Reports Using Julia](https://weavejl.mpastell.com/stable/)
- [Franklin - Building static websites in Julia](https://franklinjl.org/)
- [Pluto.jl - interactive Julia programming environment](https://plutojl.org/)
- [Quarto](https://quarto.org/)

## Fortran

### Quick-start

Code (with a few modifications in some cases) from tutorial provided [here](https://fortran-lang.org/learn/quickstart/). Recommended study order, as per the original source:

1. [hello](fortran/src/quickstart/hello.f90)
1. [variables](fortran/src/quickstart/variables.f90)
1. [read_values](fortran/src/quickstart/read_values.f90)
1. [arithmetic](fortran/src/quickstart/arithmetic.f90)
1. [floatf](fortran/src/quickstart/floatf.f90)
1. [floatc](fortran/src/quickstart/floatc.f90)
1. [block](fortran/src/quickstart/block.f90)
1. [arrays](fortran/src/quickstart/arrays.f90)
1. [array_slice](fortran/src/quickstart/array_slice.f90)
1. [allocatable](fortran/src/quickstart/allocatable.f90)
1. [string](fortran/src/quickstart/string.f90)
1. [allocatable_string](fortran/src/quickstart/allocatable_string.f90)
1. [string_array](fortran/src/quickstart/string_array.f90)
1. [control_if](fortran/src/quickstart/control_if.f90)
1. [control_loop](fortran/src/quickstart/control_loop.f90)

### Cheat-sheet

#### General

- Subroutines can be declared directly inside a program

```fortran
program program_name
    implicit none

    some_subroutine()

    contains

    subroutine some_subroutine()
        print *, "Hello, world!"
    end subroutine some_subroutine

end program program_name
```

### Flow control

- Both single branch `if` and `if-else` conditionals are supported

- Multi-branch is obtained by chaining `if-else` conditionals

#### Strings

- Constant size allocation with `character(len=<n>)` for `n` characters

- Runtime allocation declared with `character(:), allocatable`

- Allocation can be done explicitly `allocate(character(<n>) :: <var-name>)` or implicitly on assignment

- Concatenation is performed with `//`

- An array of strings keeps strings of a single size (which can be trimmed for display)

## LISP

- [Recommended environment Portacle](https://portacle.github.io/)
- [Common LISP resources](https://lisp-lang.org/learn/getting-started/)
- [Tutorialspoint tutorial](https://www.tutorialspoint.com/lisp/index.htm)

### Tutorials

1. [Getting started](lisp/getting-started.lisp)

### Tips

- Who do I produce an executable from within the REPL?

```lisp
; For Windows use the `.exe` otherwise it won't execute!
(save-lisp-and-die "myapp.exe" :executable t :toplevel #'main)
```

## Rust

Standard resources:

- [Rust Programming Language](https://www.rust-lang.org/)
- [Rustlings hands on course](https://github.com/rust-lang/rustlings/)
- [Rust Standard Library](https://doc.rust-lang.org/std/index.html)

A full set of documentation and web-books is available at [Learn Rust](https://www.rust-lang.org/learn) ; the main resources in the form of *books* are listed below following their order of importance in the beginner learning path:

- [Rust Book](https://doc.rust-lang.org/book/)
- [Rust By Example](https://doc.rust-lang.org/rust-by-example/)
- [The Cargo Book](https://doc.rust-lang.org/cargo/index.html)

For learning and reviewing the basics of Rust I recommend the following videos; start with the first for a crash course and then take more time to repeat everything and learn in more depth with the second.

- [Rust Programming (3h)](https://www.youtube.com/watch?v=rQ_J9WH6CGk)
- [Learn Rust Programming (13h)](https://www.youtube.com/watch?v=BpPEoZW5IiY)

Not yet reviewed:

- [Rust 101 Crash Course (6h)](https://www.youtube.com/watch?v=lzKeecy4OmQ)
- [Parallel Programming in Rust (1h)](https://www.youtube.com/watch?v=zQgN75kdR9M)
- [Clean Rust (playlist)](https://www.youtube.com/playlist?list=PLVbq-Dh4_0uyfA7FDduMjKp3L60WoQZgX)

### Beginner cheat-sheet

#### Compilation and Cargo

Create `hello.rs` with the following and compile with `rustc hello.rs`:

```rust
// Comments are just like in C!
/*
	Multiline also work, but I don't like it!
*/
fn main() {
    println!("Hello, world!");
}
```

Create a new project with `cargo new hello-cargo`; enter the folder and `cargo run`. Alternatively create the folder manually, enter it and `cargo init`.

#### Data types

- Primitives
- Compounds
- Collections

#### Functions and ownership

- Definition
- Ownership
- Borrowing
- References

#### Variables and mutability

- Declaration
- Mutability
- Constants
- Shadowing

#### Control flow

- Conditionals
- Loops

#### Structures and enumerations

#### Error handling

- Results
- Options
