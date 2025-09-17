## Python

*Upcoming*

## Fortran

### Quick-start

Code (with a few modifications in some cases) from tutorial provided [here](https://fortran-lang.org/learn/quickstart/). Recommended study order, as per the original source:

1. [hello](projects/lean-fortran/src/hello.f90)
1. [variables](projects/lean-fortran/src/variables.f90)
1. [read_values](projects/lean-fortran/src/read_values.f90)
1. [arithmetic](projects/lean-fortran/src/arithmetic.f90)
1. [floatf](projects/lean-fortran/src/floatf.f90)
1. [floatc](projects/lean-fortran/src/floatc.f90)
1. [block](projects/lean-fortran/src/block.f90)
1. [arrays](projects/lean-fortran/src/arrays.f90)
1. [array_slice](projects/lean-fortran/src/array_slice.f90)
1. [allocatable](projects/lean-fortran/src/allocatable.f90)
1. [string](projects/lean-fortran/src/string.f90)
1. [allocatable_string](projects/lean-fortran/src/allocatable_string.f90)
1. [string_array](projects/lean-fortran/src/string_array.f90)
1. [control_if](projects/lean-fortran/src/control_if.f90)
1. [control_loop](projects/lean-fortran/src/control_loop.f90)

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

## Scheme

Scheme is a minimalist essence of Lisp; there are many *flavors* of Scheme, and that's exactly what the language is about: conceiving new domain specific languages. Here we have chosen to proceed with [Racket](https://racket-lang.org/).

Full package for Windows does not seem to be provided as a compressed folder anymore (as the Minimal Racket tarball). No worries, just navigate to [Racket: Index](https://download.racket-lang.org/releases/), choose your version and download the installer. Instead of executing, right-click the file and select *Extract to...*; all the contents will be placed in the directory of your choice, where you find `DrRacket.exe`, the IDE for the language. It seems to work out of the box.

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
