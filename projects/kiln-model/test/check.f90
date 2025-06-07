program check
    use constant
    
    ! thermo.f90
    use nasa7
    use shomate

    ! solution.f90
    use ideal_gas
    use methane_air_1step
    use pure_silica

    !============
    implicit none
    !============

    print *, 'STARTING TESTS'

    call test001()
    call test002()
    call test003()
    call test004()

contains

    function get_solution() result(solution)
        type(methane_air_1step_t) :: phase
        type(ideal_gas_t) :: solution

        phase = methane_air_1step_t()
        solution = phase % solution
    end function

    subroutine check_result(val, ref, atol, rtol, name)
        real(dp), intent(in)         :: val
        real(dp), intent(in)         :: ref
        real(dp), intent(in)         :: atol
        real(dp), intent(in)         :: rtol
        character(len=*), intent(in) :: name

        real(dp) :: ares, rres

        ares = abs(val - ref)
        rres = ares / max(abs(ref), abs(val))

        if ((ares > atol).or.(rres > rtol)) then
            print '("Failed to compute ",A20," : ",ES15.6, ES15.6)', &
                name, ares, rres
        end if
    end subroutine

    subroutine test001()
        ! The goal of this test is to check the correct computation of
        ! density and specific heat of a simplified composition of air.
        ! It also checks that setting composition from mole to mass
        ! fractions is reversible.

        integer :: i
        character(len=5) :: num_name
        real(dp) :: X_num(5), Y_num(5), rho_num, cp_num
        real(dp) :: X_ref(5), Y_ref(5), rho_ref, cp_ref
        real(dp) :: Ui, Vi, res, atol, rtol
        type(ideal_gas_t) :: solution

        print *, 'TEST: check mass/mole fractions conversion'

        solution = get_solution()

        ! General tolerance for round-off errors:
        atol = 1.0e-05_dp
        rtol = 1.0e-06_dp

        X_ref = [0.0000000000000000_dp, 0.20999999999999999_dp, &
                 0.0000000000000000_dp, 0.00000000000000000_dp, &
                 0.7900000000000000_dp]
        
        Y_ref = [0.0000000000000000_dp, 0.23290921795842306_dp, &
                 0.0000000000000000_dp, 0.00000000000000000_dp, &
                 0.7670907820415768_dp]
        
        ! STEP 1: using mole fractions as input composition:
        call solution % set_mole_fractions(X_ref)
        rho_num = solution % density(T_NORMAL, ONE_ATM)
        cp_num  = solution % specific_heat(T_NORMAL)
        Y_num   = solution % mass_fractions

        ! print *, 'Density ......... ', rho_num
        ! print *, 'Specific heat ... ', cp_num
        ! print *, 'X_ref ', X_ref
        ! print *, 'X_num ', X_num
        ! print *, 'Y_num ', Y_ref
        ! print *, 'Y_ref ', Y_num

        rho_ref = 1.2871722_dp
        cp_ref  = 1007.3328253_dp
    
        ! Confirm density / cp match expected values:
        call check_result(rho_num, rho_ref, atol, rtol, 'rho')
        call check_result(cp_num,  cp_ref,  atol, rtol, 'cp')

        ! Check converted mole to mass fractions:
        do i = 1, solution % n_species
            Ui = Y_num(i)
            Vi = Y_ref(i)
            write(num_name, '("X(",I0,")")') i
            call check_result(Ui, Vi, atol, rtol, 'Y' // num_name)
        end do

        ! -------------------------------------------------------------

        ! STEP 2: using mass fractions as input composition:
        call solution % set_mass_fractions(Y_ref)
        rho_num = solution % density(T_NORMAL, ONE_ATM)
        cp_num  = solution % specific_heat(T_NORMAL)
        X_num   = solution % mole_fractions

        ! print *, 'Density ......... ', rho_num
        ! print *, 'Specific heat ... ', cp_num
        ! print *, 'X_ref ', X_ref
        ! print *, 'X_num ', X_num
        ! print *, 'Y_num ', Y_ref
        ! print *, 'Y_ref ', Y_num

        ! Confirm density / cp match expected values:
        call check_result(rho_num, rho_ref, atol, rtol, 'rho')
        call check_result(cp_num,  cp_ref,  atol, rtol, 'cp')

        ! Check converted mole to mass fractions:
        do i = 1, solution % n_species
            Ui = X_num(i)
            Vi = X_ref(i)
            write(num_name, '("X(",I0,")")') i
            call check_result(Ui, Vi, atol, rtol, num_name)
        end do
    end subroutine

    subroutine test002()
        ! This test provides evaluation of thermodynamic properties of
        ! individual species in a solution. Specific heat, enthalpy, and
        ! entropy are verified. Results can be qualitatively verified
        ! using the following data sources:
        ! CH4 https://webbook.nist.gov/cgi/cbook.cgi?ID=C74828&Units=SI
        !  O2 https://webbook.nist.gov/cgi/cbook.cgi?Name=o2&Units=SI
        ! CO2 https://webbook.nist.gov/cgi/cbook.cgi?ID=C124389&Units=SI
        ! H2O https://webbook.nist.gov/cgi/cbook.cgi?Name=h2o&Units=SI
        !  N2 https://webbook.nist.gov/cgi/cbook.cgi?Name=n2&Units=SI
        integer                   :: i
        real(dp)                  :: T, h298, atol, rtol
        real(dp)                  :: truth(5, 3), props(5, 3)
        character(:), allocatable :: name
        type(ideal_gas_t)         :: solution

        print *, 'TEST: check thermodynamic properties'

        atol = 1.0e-05_dp
        rtol = 1.0e-06_dp

        truth(1, :) = [52.730444, 13.173499, 216.191441]
        truth(2, :) = [32.082784,  9.244821, 226.455202]
        truth(3, :) = [47.355942, 12.903822, 243.265289]
        truth(4, :) = [36.320662, 10.500607, 213.045352]
        truth(5, :) = [30.086511,  8.905025, 212.104576]

        solution = get_solution()

        T = 600.0_dp
        ! print '("Evaluation of properties at ",F8.2," K")', T
        ! print *, 'Species  cp [J/(mol.K)]  hm [kJ/mol]  sm [J/(mol.K)]'

        do i = 1, solution % n_species
            name = solution % species(i) % name
            props(i, 1) = solution % species(i) % specific_heat(T)
            props(i, 2) = solution % species(i) % enthalpy(T)
            props(i, 3) = solution % species(i) % entropy(T)

            h298 = solution % species(i) % enthalpy(298.15_dp)
            props(i, 2) = (props(i, 2) - h298) / 1000.0_dp

            ! print '(X,A10,F10.6,F15.6,F15.6)', name, props(i, :)
            call check_result(props(i, 1), truth(i, 1), atol, rtol, 'cp')
            call check_result(props(i, 2), truth(i, 2), atol, rtol, 'hm')
            call check_result(props(i, 3), truth(i, 3), atol, rtol, 'sm')
        end do
    end subroutine

    subroutine test003()
        ! This test verifies that methane LHV matches known value.
        ! https://cantera.org/stable/userguide/heating-value.html
        type(ideal_gas_t) :: solution
        real(dp)          :: T, hm

        print *, 'TEST: check combustion enthalpy'

        solution = get_solution()
        T = T_STANDARD

        hm = 0.0_dp
        hm = hm - 1*solution % species(1) % enthalpy(T)
        hm = hm - 2*solution % species(2) % enthalpy(T)
        hm = hm + 1*solution % species(3) % enthalpy(T)
        hm = hm + 2*solution % species(4) % enthalpy(T)

        hm = -hm / (1000.0_dp * solution % species(1) % molar_mass)

        call check_result(hm, 50.025_dp, 1.0e-03_dp, 1.0e-04_dp, &
            'reaction enthalpy')
        ! print '("CH4 oxydation ",F10.3," MJ/kg",/)', hm
    end subroutine

    subroutine test004()
        ! This test verifies the values of Shomate polynomial against:
        ! https://webbook.nist.gov/cgi/cbook.cgi?ID=C14808607
        ! TODO: scan a range of temperatures, recover the full table.
        type(shomate_t) :: sio2
        real(dp) :: atol, rtol, T, props(3), truth(3)
    
        print *, 'TEST: Shomate properties'

        T = 600.0_dp
        atol = 1.0e-05
        rtol = 1.0e-07

        truth = [64.4181291, 16.8949049, 79.8162941]

        sio2 = shomate_t("SiO2", 60.0843_dp,                       &
            [-6.076591e+00_dp,  2.516755e+02_dp, -3.247964e+02_dp, &
              1.685604e+02_dp,  2.548000e-03_dp, -9.176893e+02_dp, &
             -2.796962e+01_dp, -9.108568e+02_dp])

        props(1) = sio2 % specific_heat(T)
        props(2) = sio2 % enthalpy(T)
        props(3) = sio2 % entropy(T)

        call check_result(props(1), truth(1), atol, rtol, 'cp')
        call check_result(props(2), truth(2), atol, rtol, 'hm')
        call check_result(props(3), truth(3), atol, rtol, 'sm')
    end subroutine

end program check
