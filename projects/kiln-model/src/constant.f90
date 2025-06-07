module constant

    !============
    implicit none
    public
    !============

    !! Default real type for project.
    integer, parameter :: dp = selected_real_kind(15)

    !! Reference normal temperature [K].
    real(dp), parameter :: T_NORMAL = 273.15_dp

    !! Reference standard state temperature [K].
    real(dp), parameter :: T_STANDARD = 298.15_dp

    !! Reference atmospheric pressure [Pa].
    real(dp), parameter :: ONE_ATM = 101325.0_dp

    !! Ideal gas constant [J/(mol.K)].
    real(dp), parameter :: GAS_CONSTANT = 8.31446261815324_dp

    !! Stefan-Boltzmann constant W/(m².K⁴).
    real(dp), parameter :: SIGMA = 5.6703744191844314e-08_dp

    !! Water specific heat [J/(kg.K)].
    real(dp), parameter :: WATER_SPECIFIC_HEAT = 4186.0_dp

    !! Water latent heat of evaporation [J/kg].
    real(dp), parameter :: WATER_LATENT_HEAT_EVAP = 2260000.0_dp

    !! Tolerance applied to fraction checks.
    real(dp), parameter :: SMALL_FRACTION = 1.0e-08_dp

end module constant
