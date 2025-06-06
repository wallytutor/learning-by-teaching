module methane_air_1step
    !! Provide thermodynamic models and sample hard-coded data.
    use constant
    use ideal_gas
    use nasa7

    !============
    implicit none
    private
    !============

    type, public :: methane_air_1step_t
        type(ideal_gas_t) :: solution
      contains

    end type methane_air_1step_t

    interface methane_air_1step_t
        procedure :: new_solution
    end interface methane_air_1step_t

contains

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! CONSTRUCTOR
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    type(methane_air_1step_t) function new_solution()
        type(nasa7_t) :: species(5)
        integer :: i
        call create_species(species)
        new_solution % solution = ideal_gas_t(species)

        do i = 1, new_solution % solution % n_species
            print *, new_solution % solution % species(i) % name
            print *, len(new_solution % solution % species(i) % name)
        end do
    end function new_solution

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! DATA
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    subroutine create_species(species)
        type(nasa7_t) :: species(5)

        species(1) = nasa7_t('CH4', 16.04300_dp, 1000.00_dp, &
            [+5.149876130000e+00_dp, -1.367097880000e-02_dp, &
             +4.918005990000e-05_dp, -4.847430260000e-08_dp, &
             +1.666939560000e-11_dp, -1.024664760000e+04_dp, &
             -4.641303760000e+00_dp],                        &
            [+7.485149500000e-02_dp, +1.339094670000e-02_dp, &
             -5.732858090000e-06_dp, +1.222925350000e-09_dp, &
             -1.018152300000e-13_dp, -9.468344590000e+03_dp, &
             +1.843731800000e+01_dp])

        species(2) = nasa7_t('O2',  31.99800_dp, 1000.00_dp, &
            [+3.782456360000e+00_dp, -2.996734160000e-03_dp, &
             +9.847302010000e-06_dp, -9.681295090000e-09_dp, &
             +3.243728370000e-12_dp, -1.063943560000e+03_dp, &
             +3.657675730000e+00_dp],                        &
            [+3.282537840000e+00_dp, +1.483087540000e-03_dp, &
             -7.579666690000e-07_dp, +2.094705550000e-10_dp, &
             -2.167177940000e-14_dp, -1.088457720000e+03_dp, &
             +5.453231290000e+00_dp])

        species(3) = nasa7_t('CO2', 44.00900_dp, 1000.00_dp, &
            [+2.356773520000e+00_dp, +8.984596770000e-03_dp, &
             -7.123562690000e-06_dp, +2.459190220000e-09_dp, &
             -1.436995480000e-13_dp, -4.837196970000e+04_dp, &
             +9.901052220000e+00_dp],                        &
            [+3.857460290000e+00_dp, +4.414370260000e-03_dp, &
             -2.214814040000e-06_dp, +5.234901880000e-10_dp, &
             -4.720841640000e-14_dp, -4.875916600000e+04_dp, &
             +2.271638060000e+00_dp])

        species(4) = nasa7_t('H2O', 18.01500_dp, 1000.00_dp, &
            [+4.198640560000e+00_dp, -2.036434100000e-03_dp, &
             +6.520402110000e-06_dp, -5.487970620000e-09_dp, &
             +1.771978170000e-12_dp, -3.029372670000e+04_dp, &
             -8.490322080000e-01_dp],                        &
            [+3.033992490000e+00_dp, +2.176918040000e-03_dp, &
             -1.640725180000e-07_dp, -9.704198700000e-11_dp, &
             +1.682009920000e-14_dp, -3.000429710000e+04_dp, &
             +4.966770100000e+00_dp])

        species(5) = nasa7_t('N2',  28.01400_dp, 1000.00_dp, &
            [+3.298677000000e+00_dp, +1.408240400000e-03_dp, &
             -3.963222000000e-06_dp, +5.641515000000e-09_dp, &
             -2.444854000000e-12_dp, -1.020899900000e+03_dp, &
             +3.950372000000e+00_dp],                        &
            [+2.926640000000e+00_dp, +1.487976800000e-03_dp, &
             -5.684760000000e-07_dp, +1.009703800000e-10_dp, &
             -6.753351000000e-15_dp, -9.227977000000e+02_dp, &
             +5.980528000000e+00_dp])
    end subroutine

end module methane_air_1step
