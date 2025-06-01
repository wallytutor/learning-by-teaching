module thermo
    use, intrinsic :: iso_fortran_env, only : dp => real64

    !============
    implicit none
    !============
    
    private
    public set_mass_basis_flag

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

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! thermo_base_t
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    type, abstract :: thermo_base_t
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

    subroutine set_mass_basis_flag(use_mass)
        logical, intent(in) :: use_mass

        use_mass_basis = use_mass
    end subroutine set_mass_basis_flag

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

end module thermo