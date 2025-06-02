program test_thermodynamics
    use, intrinsic :: iso_fortran_env, only : dp => real64
    use thermo

    !============
    implicit none
    !============

    integer :: i
    logical                :: check
    type(thermo_nasa7_t)   :: species(5)
    type(solution_nasa7_t) :: solution
    real(dp)               :: X(5)
    character(:), allocatable :: name
    
    print *, 'TEST: thermo'
    
    call set_flag_verbose_thermo(.false.)
    call set_flag_mass_basis(.true.)
    call set_flag_check_fractions(.true.)
    call species_methane_air_1step(species)
    
    X = [0.9_dp, 0.1_dp, 0.0_dp, 0.0_dp, 0.0_dp]

    solution = solution_nasa7_t(species)
    check = solution%set_mole_fractions(X)

    print *, solution%mole_fractions
    print *, solution%mass_fractions

    call test_print_properties(873.15_dp, solution)

contains
    
    subroutine test_print_properties(T, solution)
        real(dp),               intent(in) :: T
        type(solution_nasa7_t), intent(in) :: solution
        real(dp)                           :: cp, hm

        print '(A, F8.2, A)', 'Evaluation of properties at ', T, ' K'

        do i = 1,size(solution%species)
            name = solution%species(i)%name
            cp = solution%species(i)%specific_heat(T)
            hm = solution%species(i)%enthalpy(T)
            print '(A10, A, F10.1, A, F15.1, A)', name, ' ', cp, ' J/(kg.K)', hm, ' J/kg'
        end do
    end subroutine test_print_properties

end program test_thermodynamics