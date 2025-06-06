module thermo
    !! Provide thermodynamic models and sample hard-coded data.

    use constant
    use nasa7
    use thermo_base

    !============
    implicit none
    !============

    private
    public set_flag_mass_basis
    public set_flag_verbose_thermo
    public set_flag_check_fractions

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! FLAGS
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    !! If true, use mass basis thermodynamics.
    logical :: use_mass_basis = .true.

    !! If true, display warnings and other module messages.
    logical :: verbose_thermo = .false.

    !! If true, check if fractions add up to unity.
    logical :: check_fractions = .false.

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! solution_nasa7_t
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    ! type, public :: solution_nasa7_t
    !     !! Solution phase using NASA7 thermodynamic model.
    !     integer                    :: n_species
    !     type(nasa7_t), allocatable :: species(:)
    !     real(dp), allocatable      :: molar_masses(:)
    !     real(dp), allocatable      :: mass_fractions(:)
    !     real(dp), allocatable      :: mole_fractions(:)
    !   contains
    !     procedure :: density            => density_solution_nasa7
    !     procedure :: set_mass_fractions => set_mass_fractions_solution_nasa7
    !     procedure :: set_mole_fractions => set_mole_fractions_solution_nasa7
    !     procedure :: specific_heat      => specific_heat_solution_nasa7
    !     procedure :: enthalpy           => enthalpy_solution_nasa7
    !     ! procedure :: entropy       => entropy_solution_nasa7
    ! end type solution_nasa7_t

    ! interface solution_nasa7_t
    !     procedure :: new_solution_nasa7
    ! end interface solution_nasa7_t

contains

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! GLOBAL
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    subroutine set_flag_mass_basis(flag)
        logical, intent(in) :: flag

        if (verbose_thermo) then
            print *, 'WARNING: `use_mass_basis` being set to', flag
        end if

        use_mass_basis = flag
    end subroutine set_flag_mass_basis

    subroutine set_flag_check_fractions(flag)
        logical, intent(in) :: flag

        if (verbose_thermo) then
            print *, 'WARNING: `check_fractions` being set to', flag
        end if

        check_fractions = flag
    end subroutine set_flag_check_fractions

    subroutine set_flag_verbose_thermo(flag)
        logical, intent(in) :: flag

        if (verbose_thermo.or.flag) then
            print *, 'WARNING: `verbose_thermo` being set to', flag
        end if

        verbose_thermo = flag
    end subroutine set_flag_verbose_thermo

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! thermo_base_t
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    subroutine select_quantity_basis(self, p)
        class(thermo_base_t), intent(in)    :: self
        real(dp),             intent(inout) :: p

        if (use_mass_basis) then
            p = 1000.0_dp * p / self%molar_mass
        end if
    end subroutine select_quantity_basis

end module thermo
