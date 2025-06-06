module thermo
    !! Provide thermodynamic models and sample hard-coded data.

    use constant
    use nasa7
    use thermo_base

    !============
    implicit none
    !============

    private
    public set_flag_mass_basis
    public set_flag_verbose_thermo
    public set_flag_check_fractions

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
    ! solution_nasa7_t
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    type, public :: solution_nasa7_t
        !! Solution phase using NASA7 thermodynamic model.
        integer                    :: n_species
        type(nasa7_t), allocatable :: species(:)
        real(dp), allocatable      :: molar_masses(:)
        real(dp), allocatable      :: mass_fractions(:)
        real(dp), allocatable      :: mole_fractions(:)
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

    type(solution_nasa7_t) function new_solution_nasa7(species)
        type(nasa7_t), intent(in) :: species(:)
        integer                   :: n, i

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
