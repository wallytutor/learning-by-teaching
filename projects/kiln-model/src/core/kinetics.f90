module kinetics
    implicit none

    private

    type, public :: Solution
    end type Solution

    type, public :: SpeciesNasa7
        character(:), allocatable :: name
        real :: molar_mass
        real :: temperature_change
        real :: coefs_lo(7)
        real :: coefs_hi(7)
    end type SpeciesNasa7

contains



end module kinetics