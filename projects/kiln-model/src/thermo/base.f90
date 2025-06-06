module thermo_base
    use constant

    !============
    implicit none
    private
    !============

    type, public, abstract :: thermo_base_t
        !! Base abstract type for any compound thermodynamic model.
        character(:), allocatable :: name
        real(dp)                  :: molar_mass
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
