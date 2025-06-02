module kinetics
    use, intrinsic :: iso_fortran_env, only : dp => real64
    use thermo

    !============
    implicit none
    !============

    private

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! methane_air_one_step_t
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    type, public :: methane_air_one_step_t
        type(thermo_nasa7_t) :: species(5)
        real(dp)             :: mass_fractions(5)
    end type methane_air_one_step_t

    interface methane_air_one_step_t
        procedure :: new_methane_air_one_step
    end interface methane_air_one_step_t

contains

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! GLOBAL
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! CONSTRUCTORS
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    type(methane_air_one_step_t) function new_methane_air_one_step()
        call species_methane_air_1step(new_methane_air_one_step%species)

        ! new_methane_air_one_step%mass_fractions(1:5) = 0.0

    end function new_methane_air_one_step

end module kinetics