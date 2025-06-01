program test_kinetics
    use, intrinsic :: iso_fortran_env, only : dp => real64
    use kinetics

    !============
    implicit none
    !============

    type(species_nasa7_t) :: species
    real(dp) :: cp

    print *, 'TEST: kinetics'

    species = species_nasa7_t('CH4', 0.016043, 1000.0,                &
        [5.14987613, -0.0136709788,  0.0000491800599, -4.84743026e-8, &
         1.66693956e-11, -10246.6476, -4.64130376],                   &
        [0.074851495, 0.0133909467, -0.00000573285809, 1.22292535e-9, &
        -1.0181523e-13,  -9468.34459, 18.437318])

    cp = poly_nasa7_specific_heat(873.15d0, species%coefs_lo)

    print *, cp

end program test_kinetics