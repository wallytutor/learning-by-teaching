module thermo
    !! Provide thermodynamic models and sample hard-coded data.
    use, intrinsic :: iso_fortran_env, only : dp => real64

    !============
    implicit none
    !============

    private
    public T_NORMAL
    public T_STANDARD
    public ONE_ATM
    public thermo_nasa7_t
    public set_flag_mass_basis
    public set_flag_verbose_thermo
    public set_flag_check_fractions

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! PARAMETERS
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

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

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! FLAGS
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    !! If true, use mass basis thermodynamics.
    logical :: use_mass_basis = .true.

    !! If true, display warnings and other module messages.
    logical :: verbose_thermo = .false.

    !! If true, check if fractions add up to unity.
    logical :: check_fractions = .false.

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! thermo_base_t
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    type, abstract :: thermo_base_t
        !! Base abstract type for any compound thermodynamic model.
        character(:), allocatable :: name
        real(dp)                  :: molar_mass
      contains
        procedure (thermo_eval), deferred :: specific_heat
        procedure (thermo_eval), deferred :: enthalpy
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
        procedure :: enthalpy      => enthalpy_nasa7
        ! procedure :: entropy       => entropy_nasa7
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

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! solution_nasa7_t
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    type, public :: solution_nasa7_t
        !! Solution phase using NASA7 thermodynamic model.
        integer                           :: n_species
        type(thermo_nasa7_t), allocatable :: species(:)
        real(dp), allocatable             :: molar_masses(:)
        real(dp), allocatable             :: mass_fractions(:)
        real(dp), allocatable             :: mole_fractions(:)
      contains
        procedure :: density            => density_solution_nasa7
        procedure :: set_mass_fractions => set_mass_fractions_solution_nasa7
        procedure :: set_mole_fractions => set_mole_fractions_solution_nasa7
        procedure :: specific_heat      => specific_heat_solution_nasa7
        procedure :: enthalpy           => enthalpy_solution_nasa7
        ! procedure :: entropy       => entropy_solution_nasa7
    end type solution_nasa7_t

    interface solution_nasa7_t
        procedure :: new_solution_nasa7
    end interface solution_nasa7_t

contains

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! GLOBAL
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    subroutine set_flag_mass_basis(flag)
        logical, intent(in) :: flag

        if (verbose_thermo) then
            print *, 'WARNING: `use_mass_basis` being set to', flag
        end if

        use_mass_basis = flag
    end subroutine set_flag_mass_basis

    subroutine set_flag_check_fractions(flag)
        logical, intent(in) :: flag

        if (verbose_thermo) then
            print *, 'WARNING: `check_fractions` being set to', flag
        end if

        check_fractions = flag
    end subroutine set_flag_check_fractions

    subroutine set_flag_verbose_thermo(flag)
        logical, intent(in) :: flag

        if (verbose_thermo.or.flag) then
            print *, 'WARNING: `verbose_thermo` being set to', flag
        end if

        verbose_thermo = flag
    end subroutine set_flag_verbose_thermo

    subroutine mass_to_mole_fraction(W, Y, X)
        real(dp), intent(in)    :: W(:)
        real(dp), intent(in)    :: Y(:)
        real(dp), intent(inout) :: X(:)

        real(dp) :: M

        M = 1.0_dp / sum(Y / W)
        X = Y * M / W
    end subroutine mass_to_mole_fraction

    subroutine mole_to_mass_fraction(W, X, Y)
        real(dp), intent(in)    :: W(:)
        real(dp), intent(in)    :: X(:)
        real(dp), intent(inout) :: Y(:)

        real(dp) :: M

        M = dot_product(X, W)
        Y = X * W / M
    end subroutine mole_to_mass_fraction

    ! XXX: how could I get a single interface for this?
    ! function mean_molecular_mass(X) result(p)
    ! end function mean_molecular_mass

    function normalize_fractions(A) result(p)
        real(dp), intent(inout) :: A(:)
        real(dp) :: total
        logical :: p

        p = .true.
        total = sum(A)

        if (abs(total - 1.0_dp) >= SMALL_FRACTION) then
            A = A / total
            p = .false.
        end if
    end function normalize_fractions

    function density(T, P, Y, W) result(rho)
        real(dp) :: T
        real(dp) :: P
        real(dp) :: Y(:)
        real(dp) :: W(:)
        real(dp) :: M
        real(dp) :: rho

        M = 1.0_dp / sum(Y / W)
        rho = P * M / (GAS_CONSTANT * T)
    end function density

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

    type(solution_nasa7_t) function new_solution_nasa7(species)
        type(thermo_nasa7_t), intent(in) :: species(:)
        integer                          :: n, i

        n = size(species)
        new_solution_nasa7%n_species = n
        allocate(new_solution_nasa7%species(n))
        allocate(new_solution_nasa7%molar_masses(n))
        allocate(new_solution_nasa7%mass_fractions(n))
        allocate(new_solution_nasa7%mole_fractions(n))

        new_solution_nasa7%species = species

        do i = 1, n
            new_solution_nasa7%molar_masses(i) = species(i)%molar_mass
            new_solution_nasa7%mass_fractions(i) = 0.0_dp
            new_solution_nasa7%mole_fractions(i) = 0.0_dp
        end do
    end function new_solution_nasa7

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! thermo_base_t
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    subroutine select_quantity_basis(self, p)
        class(thermo_base_t), intent(in)    :: self
        real(dp),             intent(inout) :: p

        if (use_mass_basis) then
            p = 1000.0_dp * p / self%molar_mass
        end if
    end subroutine select_quantity_basis

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! thermo_nasa7_t
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    function specific_heat_nasa7(self, T) result(p)
        !! Specific heat from NASA7 polynomial [J/(<base>.K)].
        class(thermo_nasa7_t), intent(in) :: self
        real(dp),              intent(in) :: T

        ! XXX: how do I handle this selection without copy?
        ! real(dp), pointer :: c(:)
        real(dp) :: c(7)
        real(dp) :: p

        call range_selector_nasa7(self, T, c)
        call eval_specific_heat_nasa7(T, c, p)
        call select_quantity_basis(self, p)
    end function specific_heat_nasa7

    function enthalpy_nasa7(self, T) result(p)
        !! Enthalpy from NASA7 polynomial [J/<base>].
        class(thermo_nasa7_t), intent(in) :: self
        real(dp),              intent(in) :: T

        ! XXX: how do I handle this selection without copy?
        ! real(dp), pointer :: c(:)
        real(dp) :: c(7)
        real(dp) :: p

        call range_selector_nasa7(self, T, c)
        call eval_enthalpy_nasa7(T, c, p)
        call select_quantity_basis(self, p)
    end function enthalpy_nasa7

    subroutine range_selector_nasa7(self, T, c)
        class(thermo_nasa7_t), intent(in)  :: self
        real(dp),              intent(in)  :: T
        real(dp),              intent(out) :: c(7)

        if (T.lt.self%temperature_change) then
            c = self%coefs_lo
        else
            c = self%coefs_hi
        end if
    end subroutine range_selector_nasa7

    subroutine eval_specific_heat_nasa7(T, c, p)
        real(dp), intent(in)  :: T
        real(dp), intent(in)  :: c(7)
        real(dp), intent(out) :: p

        p = c(5)
        p = c(4) + T * p
        p = c(3) + T * p
        p = c(2) + T * p
        p = c(1) + T * p
        p = GAS_CONSTANT * p
    end subroutine eval_specific_heat_nasa7

    subroutine eval_enthalpy_nasa7(T, c, p)
        real(dp), intent(in)  :: T
        real(dp), intent(in)  :: c(7)
        real(dp), intent(out) :: p

        p = c(5) / 5.0_dp
        p = c(4) / 4.0_dp + T * p
        p = c(3) / 3.0_dp + T * p
        p = c(2) / 2.0_dp + T * p
        p = c(1) / 1.0_dp + T * p
        p = GAS_CONSTANT * T * (p + c(6) / T)
    end subroutine eval_enthalpy_nasa7

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! thermo_shomate_t
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

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

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! solution_nasa7_t
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    function density_solution_nasa7(self, T, P) result(rho)
        class(solution_nasa7_t), intent(inout) :: self
        real(dp) :: T
        real(dp) :: P
        real(dp) :: rho

        rho = density(T, P, self%mass_fractions, self%molar_masses)
        rho = rho / 1000.0_dp
    end function density_solution_nasa7

    function set_mass_fractions_solution_nasa7(self, Y) result(p)
        class(solution_nasa7_t), intent(inout) :: self
        real(dp),                intent(in)    :: Y(self%n_species)
        logical :: p

        p = .true.
        self%mass_fractions = Y

        ! Only activate check fractions for checking algorithm
        ! debug or other operations requiring robustness.
        if (check_fractions) then
            p = normalize_fractions(self%mass_fractions)
        end if

        call mass_to_mole_fraction(self%molar_masses,   &
                                   self%mass_fractions, &
                                   self%mole_fractions)
    end function set_mass_fractions_solution_nasa7

    function set_mole_fractions_solution_nasa7(self, X) result(p)
        class(solution_nasa7_t), intent(inout) :: self
        real(dp),                intent(in)    :: X(self%n_species)
        logical :: p

        p = .true.
        self%mole_fractions = X

        ! Only activate check fractions for checking algorithm
        ! debug or other operations requiring robustness.
        if (check_fractions) then
            p = normalize_fractions(self%mole_fractions)
        end if
        
        call mole_to_mass_fraction(self%molar_masses,   &
                                   self%mole_fractions, &
                                   self%mass_fractions)
    end function set_mole_fractions_solution_nasa7

    function specific_heat_solution_nasa7(self, T) result(p)
        !! Mass-weighted specific heat of solution [J/(<base>.K)].
        class(solution_nasa7_t), intent(in) :: self
        real(dp),                intent(in) :: T

        integer  :: i
        real(dp) :: p, prop

        call set_flag_mass_basis(.true.)

        p = 0.0_dp

        do i = 1, self%n_species
            prop = self%species(i)%specific_heat(T)
            p = p + self%mass_fractions(i) * prop
        end do
    end function specific_heat_solution_nasa7

    function enthalpy_solution_nasa7(self, T) result(p)
        !! Mass-weighted enthalpy of solution [J/<base>].
        class(solution_nasa7_t), intent(in) :: self
        real(dp),                intent(in) :: T

        integer  :: i
        real(dp) :: p, prop

        call set_flag_mass_basis(.true.)

        p = 0.0_dp

        do i = 1, self%n_species
            prop = self%species(i)%enthalpy(T)
            p = p + self%mass_fractions(i) * prop
        end do
    end function enthalpy_solution_nasa7

end module thermo