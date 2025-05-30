# Fortran

## Quick-start

Code (with a few modifications in some cases) from tutorial provided [here](https://fortran-lang.org/learn/quickstart/). Recommended study order, as per the original source:

1. [hello](src/quickstart/hello.f90)
1. [variables](src/quickstart/variables.f90)
1. [read_values](src/quickstart/read_values.f90)
1. [arithmetic](src/quickstart/arithmetic.f90)
1. [floatf](src/quickstart/floatf.f90)
1. [floatc](src/quickstart/floatc.f90)
1. [block](src/quickstart/block.f90)
1. [arrays](src/quickstart/arrays.f90)
1. [array_slice](src/quickstart/array_slice.f90)
1. [allocatable](src/quickstart/allocatable.f90)
1. [string](src/quickstart/string.f90)
1. [allocatable_string](src/quickstart/allocatable_string.f90)
1. [string_array](src/quickstart/string_array.f90)

## Cheat-sheet

### General

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

### Strings

- Constant size allocation with `character(len=<n>)` for `n` characters

- Runtime allocation declared with `character(:), allocatable`

- Allocation can be done explicitly `allocate(character(<n>) :: <var-name>)` or implicitly on assignment

- Concatenation is performed with `//`
