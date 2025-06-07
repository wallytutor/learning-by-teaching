module solution_base
    use constant

    !============
    implicit none
    private
    !============

    type, public, abstract :: solution_base_t
    end type

  contains

end module solution_base

module mixture
    use constant

    !============
    implicit none
    private
    !============

    !! If true, use mass basis thermodynamics.
    logical :: use_mass_basis = .true.

    !! If true, display warnings and other module messages.
    logical :: verbose_thermo = .false.

    !! If true, check if fractions add up to unity.
    logical :: check_fractions = .false.

    public mass_to_mole_fraction
    public mole_to_mass_fraction
    public normalize_fractions
    ! public set_flag_mass_basis
    ! public set_flag_verbose_thermo
    ! public set_flag_check_fractions

  contains

    ! subroutine mean_molecular_mass(V, basis) result(p)
    ! end subroutine

    ! subroutine specific_heat(obj, T, basis) result(p)
    ! end subroutine

    subroutine mass_to_mole_fraction(W, Y, X)
        real(dp), intent(in)    :: W(:)
        real(dp), intent(in)    :: Y(:)
        real(dp), intent(inout) :: X(:)

        real(dp) :: M

        M = 1.0_dp / sum(Y / W)
        X = Y * M / W
    end subroutine

    subroutine mole_to_mass_fraction(W, X, Y)
        real(dp), intent(in)    :: W(:)
        real(dp), intent(in)    :: X(:)
        real(dp), intent(inout) :: Y(:)

        real(dp) :: M

        M = dot_product(X, W)
        Y = X * W / M
    end subroutine

    subroutine normalize_fractions(A, small)
        real(dp), intent(inout) :: A(:)
        real(dp), intent(in), optional :: small
        real(dp) :: total
        real(dp) :: tol

        total = sum(A)

        if (.not.present(small)) then
            tol = SMALL_FRACTION
        else
            tol = small
        end if
        
        if (abs(total - 1.0_dp) >= tol) then
            A = A / total
        end if
    end subroutine

    subroutine set_flag_mass_basis(flag)
        logical, intent(in) :: flag

        if (verbose_thermo) then
            print *, 'WARNING: `use_mass_basis` being set to', flag
        end if

        use_mass_basis = flag
    end subroutine

    subroutine set_flag_check_fractions(flag)
        logical, intent(in) :: flag

        if (verbose_thermo) then
            print *, 'WARNING: `check_fractions` being set to', flag
        end if

        check_fractions = flag
    end subroutine

    subroutine set_flag_verbose_thermo(flag)
        logical, intent(in) :: flag

        if (verbose_thermo.or.flag) then
            print *, 'WARNING: `verbose_thermo` being set to', flag
        end if

        verbose_thermo = flag
    end subroutine

    ! subroutine select_quantity_basis(obj, p)
    !     class(thermo_base_t), intent(in)    :: obj
    !     real(dp),             intent(inout) :: p
    !
    !     if (use_mass_basis) then
    !         p = 1000.0_dp * p / self%molar_mass
    !     end if
    ! end subroutine

end module mixture

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
        integer                     :: n_species
        real(dp), allocatable       :: molar_masses(:)
        real(dp), allocatable       :: mass_fractions(:)
        real(dp), allocatable       :: mole_fractions(:)
        class(nasa7_t), allocatable :: species(:)
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

    subroutine set_mass_fractions(self, Y)
        class(ideal_gas_t), intent(inout) :: self
        real(dp),           intent(in)    :: Y(self % n_species)

        self % mass_fractions = Y

        call normalize_fractions(self % mass_fractions)
        call mass_to_mole_fraction(self % molar_masses,   &
                                   self % mass_fractions, &
                                   self % mole_fractions)
    end subroutine

    subroutine set_mole_fractions(self, X)
        class(ideal_gas_t), intent(inout) :: self
        real(dp),           intent(in)    :: X(self % n_species)

        self % mole_fractions = X

        call normalize_fractions(self % mole_fractions)
        call mole_to_mass_fraction(self % molar_masses,   &
                                   self % mole_fractions, &
                                   self % mass_fractions)
    end subroutine

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

        ! Molar mass is stored in g/mol => x1000 g / kg.
        p = 1000.00_dp * p
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

module methane_air_1step
    !! Provide thermodynamic models and sample hard-coded data.
    use constant
    use ideal_gas
    use nasa7

    !============
    implicit none
    private
    !============

    public create_species
    
    type, public :: methane_air_1step_t
        type(ideal_gas_t) :: solution
      contains
    end type methane_air_1step_t

    interface methane_air_1step_t
        procedure :: new_solution
    end interface methane_air_1step_t

  contains

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! CONSTRUCTOR
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    type(methane_air_1step_t) function new_solution()
        type(nasa7_t) :: species(5)

        call create_species(species)
        new_solution % solution = ideal_gas_t(species)
    end function new_solution

    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ! DATA
    !\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    subroutine create_species(species)
        type(nasa7_t) :: species(5)

        species(1) = nasa7_t('CH4', 16.04300_dp, 1000.00_dp, &
            [+5.149876130000e+00_dp, -1.367097880000e-02_dp, &
             +4.918005990000e-05_dp, -4.847430260000e-08_dp, &
             +1.666939560000e-11_dp, -1.024664760000e+04_dp, &
             -4.641303760000e+00_dp],                        &
            [+7.485149500000e-02_dp, +1.339094670000e-02_dp, &
             -5.732858090000e-06_dp, +1.222925350000e-09_dp, &
             -1.018152300000e-13_dp, -9.468344590000e+03_dp, &
             +1.843731800000e+01_dp])

        species(2) = nasa7_t('O2',  31.99800_dp, 1000.00_dp, &
            [+3.782456360000e+00_dp, -2.996734160000e-03_dp, &
             +9.847302010000e-06_dp, -9.681295090000e-09_dp, &
             +3.243728370000e-12_dp, -1.063943560000e+03_dp, &
             +3.657675730000e+00_dp],                        &
            [+3.282537840000e+00_dp, +1.483087540000e-03_dp, &
             -7.579666690000e-07_dp, +2.094705550000e-10_dp, &
             -2.167177940000e-14_dp, -1.088457720000e+03_dp, &
             +5.453231290000e+00_dp])

        species(3) = nasa7_t('CO2', 44.00900_dp, 1000.00_dp, &
            [+2.356773520000e+00_dp, +8.984596770000e-03_dp, &
             -7.123562690000e-06_dp, +2.459190220000e-09_dp, &
             -1.436995480000e-13_dp, -4.837196970000e+04_dp, &
             +9.901052220000e+00_dp],                        &
            [+3.857460290000e+00_dp, +4.414370260000e-03_dp, &
             -2.214814040000e-06_dp, +5.234901880000e-10_dp, &
             -4.720841640000e-14_dp, -4.875916600000e+04_dp, &
             +2.271638060000e+00_dp])

        species(4) = nasa7_t('H2O', 18.01500_dp, 1000.00_dp, &
            [+4.198640560000e+00_dp, -2.036434100000e-03_dp, &
             +6.520402110000e-06_dp, -5.487970620000e-09_dp, &
             +1.771978170000e-12_dp, -3.029372670000e+04_dp, &
             -8.490322080000e-01_dp],                        &
            [+3.033992490000e+00_dp, +2.176918040000e-03_dp, &
             -1.640725180000e-07_dp, -9.704198700000e-11_dp, &
             +1.682009920000e-14_dp, -3.000429710000e+04_dp, &
             +4.966770100000e+00_dp])

        species(5) = nasa7_t('N2',  28.01400_dp, 1000.00_dp, &
            [+3.298677000000e+00_dp, +1.408240400000e-03_dp, &
             -3.963222000000e-06_dp, +5.641515000000e-09_dp, &
             -2.444854000000e-12_dp, -1.020899900000e+03_dp, &
             +3.950372000000e+00_dp],                        &
            [+2.926640000000e+00_dp, +1.487976800000e-03_dp, &
             -5.684760000000e-07_dp, +1.009703800000e-10_dp, &
             -6.753351000000e-15_dp, -9.227977000000e+02_dp, &
             +5.980528000000e+00_dp])
    end subroutine

end module methane_air_1step

module pure_silica
    !! Provides pure silica data mainly for model testing.
    ! https://webbook.nist.gov/cgi/cbook.cgi?ID=C14808607
    use constant

    !============
    implicit none
    private
    !============

    type, public :: pure_silica_t
        ! type(ideal_gas_t) :: solution
      contains
    end type pure_silica_t

    interface pure_silica_t
        procedure :: new_solution
    end interface pure_silica_t

  contains

    type(pure_silica_t) function new_solution()
    
    end function

end module pure_silica