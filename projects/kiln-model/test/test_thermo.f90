program test_thermodynamics
    use, intrinsic :: iso_fortran_env, only : dp => real64
    use thermo
    use methane_air_1step

    !============
    implicit none
    !============

    integer :: i
    logical :: check
    type(solution_methane_air_1step_t) :: mixture

    character(:), allocatable :: name
    
    print *, 'TEST: thermo'
    print *, ''

    call set_flag_verbose_thermo(.false.)
    call set_flag_mass_basis(.true.)
    call set_flag_check_fractions(.true.)

    mixture = solution_methane_air_1step_t()

    call test_air_properties(mixture%solution)
    call test_print_properties(mixture%solution, T_STANDARD)
    call test_reaction_enthalpy(mixture%solution, T_STANDARD)

contains

    subroutine test_air_properties(solution)
        type(solution_nasa7_t), intent(inout) :: solution
        real(dp) :: X(5)

        X = [0.0_dp, 0.21_dp, 0.0_dp, 0.0_dp, 0.79_dp]
        check = solution%set_mole_fractions(X)

        print *, 'Density ......... ', solution%density(T_NORMAL, ONE_ATM)
        print *, 'Specific heat ... ', solution%specific_heat(T_NORMAL)
        print *, 'X ', solution%mole_fractions
        print *, 'Y ', solution%mass_fractions
        print *, 'END OF test_air_properties'
        print *, ''
    end subroutine test_air_properties    

    subroutine test_print_properties(solution, T)
        type(solution_nasa7_t), intent(in) :: solution
        real(dp),               intent(in) :: T
        real(dp) :: cp, hm

        print '(A, F8.2, A)', 'Evaluation of properties at ', T, ' K'

        do i = 1,size(solution%species)
            name = solution%species(i)%name
            cp = solution%species(i)%specific_heat(T)
            hm = solution%species(i)%enthalpy(T)
            print '(A10, A, F10.1, A, F15.1, A)', name, ' ', cp, ' J/(kg.K)', hm, ' J/kg'
        end do

        print *, 'END OF test_print_properties'
        print *, ''
    end subroutine test_print_properties

    subroutine test_reaction_enthalpy(solution, T)
        type(solution_nasa7_t), intent(in) :: solution
        real(dp),               intent(in) :: T
        real(dp) :: hm

        call set_flag_mass_basis(.false.)

        hm = 0.0_dp
        hm = hm - 1*solution%species(1)%enthalpy(T)
        hm = hm - 2*solution%species(2)%enthalpy(T)
        hm = hm + 1*solution%species(3)%enthalpy(T)
        hm = hm + 2*solution%species(4)%enthalpy(T)
        print '(A, F6.1, A)', 'CH4 oxydation ', hm / 1000.0_dp, ' kJ/mol'
        print *, 'END OF test_reaction_enthalpy'
        print *, ''
    end subroutine test_reaction_enthalpy

end program test_thermodynamics