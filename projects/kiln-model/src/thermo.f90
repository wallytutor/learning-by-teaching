module thermo_base
    use constant

    !============
    implicit none
    private
    !============

    type, public, abstract :: thermo_base_t
        !! Base abstract type for any compound thermodynamic model.
        ! XXX: still struggling with getting the names in memory, so for
        ! now, fall-back to constant sized character arrays.
        ! character(:), allocatable :: name
        character(20) :: name
        real(dp)      :: molar_mass
      contains
        procedure (thermo_eval), deferred :: specific_heat
        procedure (thermo_eval), deferred :: enthalpy
        procedure (thermo_eval), deferred :: entropy
    end type thermo_base_t

    abstract interface
        function thermo_eval(self, T) result(p)
            import thermo_base_t, dp
            class(thermo_base_t), intent(in) :: self
            real(dp),             intent(in) :: T
            real(dp)                         :: p
        end function thermo_eval
    end interface

end module thermo_base

module nasa7
    use constant
    use thermo_base

    !============
    implicit none
    private
    !============

    type, public, extends(thermo_base_t) :: nasa7_t
        real(dp) :: temperature_change
        real(dp) :: coefs_lo(7)
        real(dp) :: coefs_hi(7)
      contains
        procedure :: specific_heat
        procedure :: enthalpy
        procedure :: entropy
    end type

    interface nasa7_t
        procedure :: new_thermo
    end interface

  contains

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! CONSTRUCTOR (OVERRIDE)
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    type(nasa7_t) function new_thermo(&
        name, molar_mass,temperature_change, coefs_lo, coefs_hi)
        character(len=*), intent(in) :: name
        real(dp),         intent(in) :: molar_mass
        real(dp),         intent(in) :: temperature_change
        real(dp),         intent(in) :: coefs_lo(7)
        real(dp),         intent(in) :: coefs_hi(7)

        new_thermo % name = name
        new_thermo % molar_mass = molar_mass
        new_thermo % temperature_change = temperature_change
        new_thermo % coefs_lo = coefs_lo
        new_thermo % coefs_hi = coefs_hi
    end function

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! REQUIRED INTERFACES
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    function specific_heat(self, T) result(p)
        !! Specific heat from NASA7 polynomial [J/(mol.K)].
        class(nasa7_t), intent(in) :: self
        real(dp),       intent(in) :: T

        ! XXX: how do I handle this selection without copy?
        ! real(dp), pointer :: c(:)
        real(dp) :: c(7)
        real(dp) :: p

        call range_selector(self, T, c)
        call eval_specific_heat(T, c, p)
    end function

    function enthalpy(self, T) result(p)
        !! Enthalpy from NASA7 polynomial [J/mol].
        class(nasa7_t), intent(in) :: self
        real(dp),       intent(in) :: T

        ! XXX: how do I handle this selection without copy?
        ! real(dp), pointer :: c(:)
        real(dp) :: c(7)
        real(dp) :: p

        call range_selector(self, T, c)
        call eval_enthalpy(T, c, p)
    end function

    function entropy(self, T) result(p)
        !! Entropy from NASA7 polynomial [J/(mol.K)].
        class(nasa7_t), intent(in) :: self
        real(dp),       intent(in) :: T

        ! XXX: how do I handle this selection without copy?
        ! real(dp), pointer :: c(:)
        real(dp) :: c(7)
        real(dp) :: p

        call range_selector(self, T, c)
        call eval_entropy(T, c, p)
    end function

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! INTERNALS
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    subroutine range_selector(self, T, c)
        class(nasa7_t), intent(in)  :: self
        real(dp),       intent(in)  :: T
        real(dp),       intent(out) :: c(7)

        if (T.lt.self%temperature_change) then
            c = self%coefs_lo
        else
            c = self%coefs_hi
        end if
    end subroutine

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! PURE IMPLEMENTATIONS BY DEFINITION
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    subroutine eval_specific_heat(T, c, p)
        real(dp), intent(in)  :: T
        real(dp), intent(in)  :: c(7)
        real(dp), intent(out) :: p

        p = c(5)
        p = c(4) + T * p
        p = c(3) + T * p
        p = c(2) + T * p
        p = c(1) + T * p
        p = GAS_CONSTANT * p
    end subroutine

    subroutine eval_enthalpy(T, c, p)
        real(dp), intent(in)  :: T
        real(dp), intent(in)  :: c(7)
        real(dp), intent(out) :: p

        p = c(5) / 5.0_dp
        p = c(4) / 4.0_dp + T * p
        p = c(3) / 3.0_dp + T * p
        p = c(2) / 2.0_dp + T * p
        p = c(1) / 1.0_dp + T * p
        p = GAS_CONSTANT * T * (p + c(6) / T)
    end subroutine

    subroutine eval_entropy(T, c, p)
        real(dp), intent(in)  :: T
        real(dp), intent(in)  :: c(7)
        real(dp), intent(out) :: p

        p = c(5) / 4.0_dp
        p = c(4) / 3.0_dp + T * p
        p = c(3) / 2.0_dp + T * p
        p = c(2) / 1.0_dp + T * p
        p = GAS_CONSTANT * (T * p + c(7) + c(1) * log(T))
    end subroutine

end module nasa7

module shomate
    use constant
    use thermo_base

    !============
    implicit none
    private
    !============

    ! type, public, extends(thermo_base_t) :: thermo_shomate_t
    !     real(dp) :: coefs_lo(8)
    !     real(dp) :: coefs_hi(8)
    !   contains
    ! end type thermo_shomate_t

    ! interface thermo_shomate_t
    !     procedure :: new_thermo_shomate
    ! end interface thermo_shomate_t

  contains

    ! function [p] = shomate_specific_heat(T, c)
    !     % Molar specific heat with Shomate equation [J/(mol.K)].
    !     p = T.*(c(2)+T.*(c(3)+c(4).*T))+c(5)./T.^2+c(1);
    ! endfunction
    !
    ! function [p] = shomate_enthalpy(T, c)
    !     % Molar enthalpy with Shomate equation [J/mol].
    !     p = T.*(c(1)+T.*(c(2)/2+T.*(c(3)/3+c(4)/4.*T)))-c(5)./T+c(6)-c(8);
    ! endfunction
    !
    ! function [p] = shomate_entropy(T, c)
    !     % Entropy with Shomate equation [J/K].
    !     p = c(1).*log(T)+T.*(c(2)+T.*(c(3)/2+c(4)/3.*T))+c(5)./(2.*T.^2)+c(7);
    ! endfunction

end module shomate

module maier_kelley
    use constant
    use thermo_base

    !============
    implicit none
    private
    !============

    ! type, public, extends(thermo_base_t) :: thermo_maierkelley_t
    !     real(dp) :: coefs_lo(5)
    !     real(dp) :: coefs_hi(5)
    !   contains
    ! end type thermo_maierkelley_t

    ! interface thermo_maierkelley_t
    !     procedure :: new_thermo_maierkelley
    ! end interface thermo_maierkelley_t

  contains

end module maier_kelley
