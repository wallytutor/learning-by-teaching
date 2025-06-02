program test_thermodynamics
    use, intrinsic :: iso_fortran_env, only : dp => real64
    use thermo

    !============
    implicit none
    !============

    integer :: i
    type(thermo_nasa7_t) :: species(5)
    character(:), allocatable :: name
    real(dp) :: T, cp, hm
    
    print *, 'TEST: thermo'

    call set_flag_verbose_thermo(.false.)
    call set_flag_mass_basis(.true.)
    call species_methane_air_1step(species)

    T = 873.15_dp
    print '(A, F8.2, A)', 'Evaluation of properties at ', T, ' K'

    do i = 1,size(species)
        name = species(i)%name
        cp = species(i)%specific_heat(T)
        hm = species(i)%enthalpy(T)
        print '(A10, A, F10.1, A, F15.1, A)', name, ' ', cp, ' J/(kg.K)', hm, ' J/kg'
    end do

end program test_thermodynamics