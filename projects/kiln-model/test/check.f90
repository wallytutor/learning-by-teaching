program check
    use constant
    use thermo
    use methane_air_1step

    !============
    implicit none
    !============

    integer :: i
    type(solution_methane_air_1step_t) :: mixture

    character(:), allocatable :: name

    print *, 'TEST: thermo'
    print *, ''

    call set_flag_verbose_thermo(.false.)
    call set_flag_mass_basis(.true.)
    call set_flag_check_fractions(.true.)

    mixture = solution_methane_air_1step_t()

    call test_air_properties(mixture%solution)
    call test_print_properties(mixture%solution, 300.0_dp)
    call test_reaction_enthalpy(mixture%solution, T_STANDARD)

contains

    subroutine test_air_properties(solution)
        type(solution_nasa7_t), intent(inout) :: solution
        real(dp) :: X(5), Y(5)
        logical :: dummy

        print *, 'Setting mole fractions'
        X = [0.0_dp, 0.21_dp, 0.0_dp, 0.0_dp, 0.79_dp]
        dummy = solution%set_mole_fractions(X)

        print *, 'Density ......... ', solution%density(T_NORMAL, ONE_ATM)
        print *, 'Specific heat ... ', solution%specific_heat(T_NORMAL)
        print *, 'X ', solution%mole_fractions
        print *, 'Y ', solution%mass_fractions

        print *, 'Setting mass fractions'
        Y = solution%mass_fractions
        dummy = solution%set_mass_fractions(Y)

        print *, 'Density ......... ', solution%density(T_NORMAL, ONE_ATM)
        print *, 'Specific heat ... ', solution%specific_heat(T_NORMAL)
        print *, 'X ', solution%mole_fractions
        print *, 'Y ', solution%mass_fractions

        print *, 'Residual = ', maxval(X - solution%mole_fractions)

        print *, 'END OF test_air_properties'
        print *, ''
    end subroutine test_air_properties

    subroutine test_print_properties(solution, T)
        type(solution_nasa7_t), intent(in) :: solution
        real(dp),               intent(in) :: T
        real(dp) :: cp, hm, sm, h298

        print '(A, F8.2, A)', 'Evaluation of properties at ', T, ' K'


        do i = 1,size(solution%species)
            name = solution%species(i)%name
            cp = solution%species(i)%specific_heat(T)
            hm = solution%species(i)%enthalpy(T)
            sm = solution%species(i)%entropy(T)

            hm = (hm - solution%species(i)%enthalpy(298.15_dp)) / 1000.0_dp

            print '(A10," ",F10.2," J/(mol.K)",F15.2," kJ/mol",F15.1," J/(mol.K)")', name, cp, hm, sm
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
        hm = hm / 1000.0_dp

        print '("CH4 oxydation ",F6.1," kJ/mol")', hm
        print *, 'END OF test_reaction_enthalpy'
        print *, ''
    end subroutine test_reaction_enthalpy

end program check
