module thermo
    !! Provide thermodynamic models and sample hard-coded data.
    use, intrinsic :: iso_fortran_env, only : dp => real64

    !============
    implicit none
    !============
    
    private
    public set_flag_mass_basis
    public set_flag_verbose_thermo
    public species_methane_air_1step

    !! Ideal gas constant [J/(mol.K)].
    real(dp), parameter :: GAS_CONSTANT = 8.31446261815324

    !! Stefan-Boltzmann constant W/(m².K⁴).
    real(dp), parameter :: SIGMA = 5.6703744191844314e-08

    !! Water specific heat [J/(kg.K)].
    real(dp), parameter :: WATER_SPECIFIC_HEAT = 4186.0

    !! Water latent heat of evaporation [J/kg].
    real(dp), parameter :: WATER_LATENT_HEAT_EVAP = 2260000.0

    !! If true, use mass basis thermodynamics.
    logical :: use_mass_basis = .true.

    !! If true, display warnings and other module messages.
    logical :: verbose_thermo = .true.

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! thermo_base_t
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    type, abstract :: thermo_base_t
        !! Base abstract type for any compound thermodynamic model.
        character(:), allocatable :: name
        real(dp) :: molar_mass
      contains
        procedure (thermo_eval), deferred :: specific_heat
        ! procedure (thermo_eval), deferred :: enthalpy
        ! procedure (thermo_eval), deferred :: entropy
    end type thermo_base_t

    abstract interface
        function thermo_eval(self, T) result(p)
            import thermo_base_t, dp
            class(thermo_base_t), intent(in) :: self
            real(dp),             intent(in) :: T
            real(dp)                         :: p
        end function thermo_eval
    end interface

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! thermo_nasa7_t
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    type, public, extends(thermo_base_t) :: thermo_nasa7_t
        real(dp) :: temperature_change
        real(dp) :: coefs_lo(7)
        real(dp) :: coefs_hi(7)
      contains
        procedure :: specific_heat => specific_heat_nasa7
    end type thermo_nasa7_t

    interface thermo_nasa7_t
        procedure :: new_thermo_nasa7
    end interface thermo_nasa7_t

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! thermo_shomate_t
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    ! type, public, extends(thermo_base_t) :: thermo_shomate_t
    !     real(dp) :: coefs_lo(8)
    !     real(dp) :: coefs_hi(8)
    !   contains
    ! end type thermo_shomate_t

    ! interface thermo_shomate_t
    !     procedure :: new_thermo_shomate
    ! end interface thermo_shomate_t

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! thermo_maierkelley_t
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    ! type, public, extends(thermo_base_t) :: thermo_maierkelley_t
    !     real(dp) :: coefs_lo(5)
    !     real(dp) :: coefs_hi(5)
    !   contains
    ! end type thermo_maierkelley_t

    ! interface thermo_maierkelley_t
    !     procedure :: new_thermo_maierkelley
    ! end interface thermo_maierkelley_t

contains

    subroutine set_flag_mass_basis(flag)
        logical, intent(in) :: flag

        if (verbose_thermo) then
            print *, 'WARNING: `use_mass_basis` being set to', flag
        end if

        use_mass_basis = flag
    end subroutine set_flag_mass_basis

    subroutine set_flag_verbose_thermo(flag)
        logical, intent(in) :: flag

        verbose_thermo = flag
    end subroutine set_flag_verbose_thermo

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! CONSTRUCTORS
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    type(thermo_nasa7_t) function new_thermo_nasa7(&
            name, molar_mass,temperature_change, coefs_lo, coefs_hi)
        character(len=*), intent(in) :: name
        real(dp),         intent(in) :: molar_mass
        real(dp),         intent(in) :: temperature_change
        real(dp),         intent(in) :: coefs_lo(7)
        real(dp),         intent(in) :: coefs_hi(7)

        new_thermo_nasa7%name = name
        new_thermo_nasa7%molar_mass = molar_mass
        new_thermo_nasa7%temperature_change = temperature_change
        new_thermo_nasa7%coefs_lo = coefs_lo
        new_thermo_nasa7%coefs_hi = coefs_hi
    end function new_thermo_nasa7

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! SPECIFIC HEAT
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    function specific_heat_nasa7(self, T) result(p)
        !! Molar specific heat from NASA7 polynomial [J/(mol.K)].
        class(thermo_nasa7_t), intent(in) :: self
        real(dp),              intent(in) :: T
            !! Temperature of solution [K].
        real(dp)                          :: p
            !! Coefficients in molar units.

        ! XXX: how do I handle this selection without copy?
        ! real(dp), pointer                 :: c(:)
        real(dp), allocatable             :: c(:)

        if (T.lt.self%temperature_change) then
            c = self%coefs_lo
        else
            c = self%coefs_hi
        end if

        p = c(1) + T * (c(2) + T * (c(3) + T * (c(4) + c(5) * T)))
        p = GAS_CONSTANT * p

        if (use_mass_basis) then
            p = 1000.0 * p / self%molar_mass
        end if

    end function specific_heat_nasa7

    ! function [p] = shomate_specific_heat(T, c)
    !     % Molar specific heat with Shomate equation [J/(mol.K)].
    !     p = T.*(c(2)+T.*(c(3)+c(4).*T))+c(5)./T.^2+c(1);
    ! endfunction

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! ENTHALPY
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    ! function [p] = poly_nasa7_enthapy(T, c)
    !     % Molar enthalpy from NASA7 polynomial [J/mol].
    !     d = c(1:5) ./ linspace(1, 5, 5);
    !     p = d(1)+T.*(d(2)+T.*(d(3)+T.*(d(4)+d(5).*T)))+c(6)./T;
    !     p = Thermodata.GAS_CONSTANT .* T .* p;
    ! end

    ! function [p] = shomate_enthalpy(T, c)
    !     % Molar enthalpy with Shomate equation [J/mol].
    !     p = T.*(c(1)+T.*(c(2)/2+T.*(c(3)/3+c(4)/4.*T)))-c(5)./T+c(6)-c(8);
    ! endfunction

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! ENTROPY
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    ! function [p] = shomate_entropy(T, c)
    !     % Entropy with Shomate equation [J/K].
    !     p = c(1).*log(T)+T.*(c(2)+T.*(c(3)/2+c(4)/3.*T))+c(5)./(2.*T.^2)+c(7);
    ! endfunction

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! DATA
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    subroutine species_methane_air_1step(species)
        type(thermo_nasa7_t) :: species(5)

        species(1) = new_thermo_nasa7('CH4', 16.04300_dp, 1000.00_dp, &
            [+5.149876130000e+00_dp, -1.367097880000e-02_dp, &
             +4.918005990000e-05_dp, -4.847430260000e-08_dp, &
             +1.666939560000e-11_dp, -1.024664760000e+04_dp, &
             -4.641303760000e+00_dp],                        &
            [+7.485149500000e-02_dp, +1.339094670000e-02_dp, &
             -5.732858090000e-06_dp, +1.222925350000e-09_dp, &
             -1.018152300000e-13_dp, -9.468344590000e+03_dp, &
             +1.843731800000e+01_dp])

        species(2) = new_thermo_nasa7('O2',  31.99800_dp, 1000.00_dp, &
            [+3.782456360000e+00_dp, -2.996734160000e-03_dp, &
             +9.847302010000e-06_dp, -9.681295090000e-09_dp, &
             +3.243728370000e-12_dp, -1.063943560000e+03_dp, &
             +3.657675730000e+00_dp],                        &
            [+3.282537840000e+00_dp, +1.483087540000e-03_dp, &
             -7.579666690000e-07_dp, +2.094705550000e-10_dp, &
             -2.167177940000e-14_dp, -1.088457720000e+03_dp, &
             +5.453231290000e+00_dp])

        species(3) = new_thermo_nasa7('CO2', 44.00900_dp, 1000.00_dp, &
            [+2.356773520000e+00_dp, +8.984596770000e-03_dp, &
             -7.123562690000e-06_dp, +2.459190220000e-09_dp, &
             -1.436995480000e-13_dp, -4.837196970000e+04_dp, &
             +9.901052220000e+00_dp],                        &
            [+3.857460290000e+00_dp, +4.414370260000e-03_dp, &
             -2.214814040000e-06_dp, +5.234901880000e-10_dp, &
             -4.720841640000e-14_dp, -4.875916600000e+04_dp, &
             +2.271638060000e+00_dp])

        species(4) = new_thermo_nasa7('H2O', 18.01500_dp, 1000.00_dp, &
            [+4.198640560000e+00_dp, -2.036434100000e-03_dp, &
             +6.520402110000e-06_dp, -5.487970620000e-09_dp, &
             +1.771978170000e-12_dp, -3.029372670000e+04_dp, &
             -8.490322080000e-01_dp],                        &
            [+3.033992490000e+00_dp, +2.176918040000e-03_dp, &
             -1.640725180000e-07_dp, -9.704198700000e-11_dp, &
             +1.682009920000e-14_dp, -3.000429710000e+04_dp, &
             +4.966770100000e+00_dp])

        species(5) = new_thermo_nasa7('N2',  28.01400_dp, 1000.00_dp, &
            [+3.298677000000e+00_dp, +1.408240400000e-03_dp, &
             -3.963222000000e-06_dp, +5.641515000000e-09_dp, &
             -2.444854000000e-12_dp, -1.020899900000e+03_dp, &
             +3.950372000000e+00_dp],                        &
            [+2.926640000000e+00_dp, +1.487976800000e-03_dp, &
             -5.684760000000e-07_dp, +1.009703800000e-10_dp, &
             -6.753351000000e-15_dp, -9.227977000000e+02_dp, &
             +5.980528000000e+00_dp])
    end subroutine species_methane_air_1step

end module thermo