

module ideal_gas
    use constant
    ! use thermo_base
    use solution_base
    use mixture
    use nasa7

    !============
    implicit none
    private
    !============

    type, public, extends(solution_base_t) :: ideal_gas_t
        ! XXX: for now I am enforcing NASA7 here, but that should be
        ! generic for allowing each entry to have its own kind.
        ! class(thermo_base_t), pointer :: species(:)
        class(nasa7_t), allocatable :: species(:)
        integer                     :: n_species
        real(dp), allocatable       :: molar_masses(:)
        real(dp), allocatable       :: mass_fractions(:)
        real(dp), allocatable       :: mole_fractions(:)
      contains
        procedure :: density
        procedure :: set_mass_fractions
        procedure :: set_mole_fractions
        procedure :: specific_heat
        procedure :: enthalpy
        procedure :: entropy
    end type

    interface ideal_gas_t
        procedure :: new_solution
    end interface ideal_gas_t

contains

    type(ideal_gas_t) function new_solution(species)
        class(nasa7_t), intent(in) :: species(:)
        integer                    :: n, i

        n = size(species)
        new_solution % n_species = n

        allocate(new_solution % species(n))
        allocate(new_solution % molar_masses(n))
        allocate(new_solution % mass_fractions(n))
        allocate(new_solution % mole_fractions(n))

        new_solution % species = species
        
        do i = 1, n
            new_solution % molar_masses(i) = species(i) % molar_mass
            new_solution % mass_fractions(i) = 0.0_dp
            new_solution % mole_fractions(i) = 0.0_dp
        end do

    end function

    function density(self, T, P) result(rho)
        class(ideal_gas_t), intent(inout) :: self
        real(dp) :: T
        real(dp) :: P
        real(dp) :: rho

        rho = eval_density(T, P, self % mass_fractions, self % molar_masses)
        rho = rho / 1000.0_dp
    end function

    function set_mass_fractions(self, Y) result(p)
        class(ideal_gas_t), intent(inout) :: self
        real(dp),                intent(in)    :: Y(self%n_species)
        logical :: p

        p = .true.
        self%mass_fractions = Y

        ! Only activate check fractions for checking algorithm
        ! debug or other operations requiring robustness.
        ! if (check_fractions) then
        !     p = normalize_fractions(self%mass_fractions)
        ! end if

        call mass_to_mole_fraction(self%molar_masses,   &
                                   self%mass_fractions, &
                                   self%mole_fractions)
    end function

    function set_mole_fractions(self, X) result(p)
        class(ideal_gas_t), intent(inout) :: self
        real(dp),                intent(in)    :: X(self%n_species)
        logical :: p

        p = .true.
        self%mole_fractions = X

        ! Only activate check fractions for checking algorithm
        ! debug or other operations requiring robustness.
        ! if (check_fractions) then
        !     p = normalize_fractions(self%mole_fractions)
        ! end if
        
        call mole_to_mass_fraction(self%molar_masses,   &
                                   self%mole_fractions, &
                                   self%mass_fractions)
    end function

    function specific_heat(self, T) result(p)
        !! Mass-weighted specific heat of solution [J/(kg.K)].
        class(ideal_gas_t), intent(in) :: self
        real(dp),           intent(in) :: T

        integer  :: i
        real(dp) :: p, prop

        p = 0.0_dp

        do i = 1, self%n_species
            prop = self % species(i) % specific_heat(T)
            prop = prop / self % species(i) % molar_mass
            p = p + self % mass_fractions(i) * prop
        end do
    end function

    function enthalpy(self, T) result(p)
        !! Mass-weighted enthalpy of solution [J/kg].
        class(ideal_gas_t), intent(in) :: self
        real(dp),                intent(in) :: T

        integer  :: i
        real(dp) :: p, prop

        p = 0.0_dp

        do i = 1, self%n_species
            prop = self % species(i) % enthalpy(T)
            prop = prop / self % species(i) % molar_mass
            p = p + self % mass_fractions(i) * prop
        end do
    end function

    function entropy(self, T) result(p)
        !! Mass-weighted entropy of solution [J/(kg.K)].
        class(ideal_gas_t), intent(in) :: self
        real(dp),                intent(in) :: T

        integer  :: i
        real(dp) :: p, prop
        p = 0.0_dp

        do i = 1, self%n_species
            prop = self % species(i) % entropy(T)
            prop = prop / self % species(i) % molar_mass
            p = p + self % mass_fractions(i) * prop
        end do
    end function

    function eval_density(T, P, Y, W) result(rho)
        real(dp) :: T
        real(dp) :: P
        real(dp) :: Y(:)
        real(dp) :: W(:)
        real(dp) :: M
        real(dp) :: rho

        M = 1.0_dp / sum(Y / W)
        rho = P * M / (GAS_CONSTANT * T)
    end function

end module ideal_gas