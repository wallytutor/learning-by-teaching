module kinetics
    use, intrinsic :: iso_fortran_env, only : dp => real64

    !============
    implicit none
    !============

    private
    public GAS_CONSTANT
    public poly_nasa7_specific_heat

    real(dp), parameter :: GAS_CONSTANT = 8.31446261815324

    type, public :: Solution
    end type Solution

    type, public :: species_nasa7_t
        character(:), allocatable :: name
        real(dp) :: molar_mass
        real(dp) :: temperature_change
        real(dp) :: coefs_lo(7)
        real(dp) :: coefs_hi(7)
    end type species_nasa7_t

    type, public :: methane_air_one_step_t
        type(species_nasa7_t) :: species(5)
    end type methane_air_one_step_t

    ! interface methane_air_one_step_t
    !     procedure :: new_methane_air_one_step
    ! end interface methane_air_one_step_t

contains

    function poly_nasa7_specific_heat(T, c) result(p)
        !! Molar specific heat from NASA7 polynomial [J/(mol.K)].

        ! Arguments
        real(dp), intent(in) :: T
            !! Temperature of solution [K].
        real(dp), intent(in) :: c(7)
            !! Coefficients in molar units.

        ! Returns
        real(dp) :: p

        p = c(1) + T * (c(2) + T * (c(3) + T * (c(4) + c(5) * T)))
        p = GAS_CONSTANT * p;
    end function poly_nasa7_specific_heat

    ! type(methane_air_one_step_t) function new_methane_air_one_step()
    !     new_methane_air_one_step
    ! end function new_methane_air_one_step

end module kinetics