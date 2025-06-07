program check
    use constant
    use nasa7
    use ideal_gas
    use methane_air_1step

    !============
    implicit none
    !============

    print *, 'TEST: thermo'
    print *, ''

    ! call test001()
    call test002()
    ! call test_reaction_enthalpy(mixture % solution, T_STANDARD)

contains

    subroutine check_result(val, ref, tol, name)
        real(dp), intent(in)         :: val
        real(dp), intent(in)         :: ref
        real(dp), intent(in)         :: tol
        character(len=*), intent(in) :: name

        real(dp) :: res

        res = abs(val - ref)

        if (res > tol) then
            print '("Failed to compute ",A20," : ",ES15.6)', name, res
        end if
    end subroutine

    ! subroutine test001()
    !     ! The goal of this test is to check the correct computation of
    !     ! density and specific heat of a simplified composition of air.
    !     ! It also checks that setting composition from mole to mass
    !     ! fractions is reversible.

    !     integer :: i
    !     real(dp) :: X(5), Y(5), rho, cp
    !     real(dp) :: res, tol
    !     type(methane_air_1step_t) :: mixture
    !     type(ideal_gas_t) :: solution

    !     mixture = methane_air_1step_t()
    !     solution = mixture % solution

    !     ! General tolerance for round-off errors:
    !     tol = 1.0e-06

    !     ! Using mole fractions as input composition:
    !     X = [0.0000000000000000_dp, 0.20999999999999999_dp,
    !          0.0000000000000000_dp, 0.00000000000000000_dp,
    !          0.7900000000000000_dp]
    
    !     call solution % set_mole_fractions(X)
    !     rho = solution % density(T_NORMAL, ONE_ATM)
    !     cp  = solution % specific_heat(T_NORMAL)

    !     call check_result(rho, 1.2871722673691981_dp, 1.0e-08_dp, 'density')
    !     call check_result(cp,  1007.0_dp, 1.0e-08_dp, 'specific heat')

    !     print *, 'Density ......... ', rho
    !     print *, 'Specific heat ... ', cp
    !     print *, 'X ', solution%mole_fractions
    !     print *, 'Y ', solution%mass_fractions

    !     do i = 1, solution % n_species
    !         call check_result(, 1.2871722673691981_dp, 1.0e-08_dp, 'density')
    !     end do

    !     ! print *, 'Setting mass fractions'
    !     ! Y = solution%mass_fractions
    !     ! call solution%set_mass_fractions(Y)

    !     ! print *, 'Density ......... ', solution%density(T_NORMAL, ONE_ATM)
    !     ! print *, 'Specific heat ... ', solution%specific_heat(T_NORMAL)
    !     ! print *, 'X ', solution%mole_fractions
    !     ! print *, 'Y ', solution%mass_fractions

    !     ! print *, 'Residual = ', maxval(X - solution%mole_fractions)

    !     print *, 'END OF test_air_properties'
    !     print *, ''
    ! end subroutine

    subroutine test002()
        integer :: i
        real(dp) :: T
        real(dp) :: cp, hm, sm, h298
        character(:), allocatable :: name
        type(methane_air_1step_t) :: mixture
        type(ideal_gas_t) :: solution

        mixture = methane_air_1step_t()
        solution = mixture % solution

        T = 300.0_dp
        print '(A10, F8.2, A)', 'Evaluation of properties at ', T, ' K'

        do i = 1, solution % n_species
            name = solution % species(i) % name
            cp   = solution % species(i) % specific_heat(T)
            hm   = solution % species(i) % enthalpy(T)
            sm   = solution % species(i) % entropy(T)

            hm = (hm - solution%species(i)%enthalpy(298.15_dp)) / 1000.0_dp

            print '(A10," ",F10.2," J/(mol.K)",F15.3," kJ/mol",F15.1," J/(mol.K)")', name, cp, hm, sm
        end do

        print *, 'END OF test_print_properties'
        print *, ''
    end subroutine

    ! subroutine test_reaction_enthalpy(solution, T)
    !     type(ideal_gas_t), intent(in) :: solution
    !     real(dp),               intent(in) :: T
    !     real(dp) :: hm

    !     ! call set_flag_mass_basis(.false.)

    !     hm = 0.0_dp
    !     hm = hm - 1*solution % species(1) % enthalpy(T)
    !     hm = hm - 2*solution % species(2) % enthalpy(T)
    !     hm = hm + 1*solution % species(3) % enthalpy(T)
    !     hm = hm + 2*solution % species(4) % enthalpy(T)
    !     hm = hm / 1000.0_dp

    !     print '("CH4 oxydation ",F6.1," kJ/mol")', hm
    !     print *, 'END OF test_reaction_enthalpy'
    !     print *, ''
    ! end subroutine

end program check
