
module kiln_geometry
    use constant

    !============
    implicit none
    private
    !============

    public central_angle
    public bed_cord
    public bed_section
    public filling_ratio
    public equivalent_diameter

  contains

    pure function central_angle(h, R) result(val)
        ! Kiln bed central angle [rad].
        real(dp), intent(in) :: h
          ! Kiln bed depth at cross-section [m].
        real(dp), intent(in) :: R
          ! Kiln internal radius at cross-section [m].
        real(dp)             :: val

        val = 2.0_dp * acos(1.0_dp - h / R)
    end function

    pure function bed_cord(R, theta) result(val)
        ! Kiln bed cord length derived from geometry [m].
        real(dp), intent(in) :: R
          ! Kiln internal radius at cross-section [m].
        real(dp), intent(in) :: theta
        real(dp)             :: val

        val = 2.0_dp * R * sin(theta / 2.0_dp)
    end function

    pure function bed_section(h, R, l, theta) result(val)
        ! Kiln bed cross section area as defined in Mujumdar (2006).
        real(dp), intent(in) :: h
          ! Kiln bed depth at cross-section [m].
        real(dp), intent(in) :: R
          ! Kiln internal radius at cross-section [m].
        real(dp), intent(in) :: l
          ! Kiln bed cord length at cross-section [m].
        real(dp), intent(in) :: theta
          ! Kiln bed central angle [rad].
        real(dp)             :: val

        val = (theta * R**2 - l * (R - h)) / 2.0_dp
    end function

    ! TODO: simplify to compute from h, R only in kramers module:
    ! pure function bed_section_all(h, R) result(val)
    !     ! Kiln bed cross section area as defined in Mujumdar (2006).
    !     real(dp), intent(in) :: h
    !       ! Kiln bed depth at cross-section [m].
    !     real(dp), intent(in) :: R
    !       ! Kiln internal radius at cross-section [m].
    !     real(dp), intent(in) :: l
    !       ! Kiln bed cord length at cross-section [m].
    !     real(dp), intent(in) :: theta
    !       ! Kiln bed central angle [rad].
    !     real(dp)             :: val
    !
    !     theta = 2.0_dp * acos(1.0_dp - h / R)
    !     l = 2.0_dp * R * sin(theta / 2.0_dp)
    !
    !     val = (theta * R**2 - l * (R - h)) / 2.0_dp
    ! end function

    pure function filling_ratio(theta) result(val)
        ! Kiln local loading as defined in Tscheng (1979).
        real(dp), intent(in) :: theta
          ! Central bed angle [rad].
        real(dp)             :: val

        val = (theta - sin(theta)) / (2 * PI)
    end function

    pure function equivalent_diameter(R, theta) result(val)
        ! Kiln equivalent diameter proposed by Tscheng (1979).
        real(dp), intent(in) :: R
          ! Kiln internal radius at cross-section [m].
        real(dp), intent(in) :: theta
          ! Central bed angle [rad].
        real(dp)             :: val
        real(dp)             :: num
        real(dp)             :: den

        num = 2 * PI - theta / 1 + sin(theta / 1)
        den = 1 * PI - theta / 2 + sin(theta / 2)
        val = R * num / den
    end

end module kiln_geometry

module kiln_grid
    use constant
    use kiln_geometry

    !============
    implicit none
    private
    !============

    type, public :: kiln_cell_t
        real(dp) :: local_radius
        real(dp) :: diameter_eff
        real(dp) :: bed_height
        real(dp) :: central_angle
        real(dp) :: bed_cord_length
        real(dp) :: bed_cross_area
        real(dp) :: gas_cross_area
        real(dp) :: local_loading
    end type

    type, public :: kiln_grid_t
    end type

    interface kiln_cell_t
        procedure :: new_cell
    end interface

    interface kiln_grid_t
        procedure :: new_grid
    end interface

  contains

    type(kiln_cell_t) function new_cell(R, h)
        real(dp), intent(in) :: R
          ! Kiln internal radius at cross-section [m].
        real(dp), intent(in) :: h
          ! Kiln bed depth at cross-section [m].

        real(dp) :: theta, lb, eta, A_b, A_f, D

        theta = central_angle(h, R)
        lb    = bed_cord(R, theta)
        eta   = filling_ratio(theta)
        A_b   = bed_section(h, R, lb, theta)
        A_f   = PI * R**2 - A_b
        D     = equivalent_diameter(R, theta)

        new_cell % local_radius    = R
        new_cell % diameter_eff    = D
        new_cell % bed_height      = h
        new_cell % central_angle   = theta
        new_cell % bed_cord_length = lb
        new_cell % local_loading   = eta
        new_cell % bed_cross_area  = A_b
        new_cell % gas_cross_area  = A_f
    end function

    type(kiln_grid_t) function new_grid()
    end function

end module kiln_grid

module kramers
    use constant
    use rhs_base
    use integ_rkf45
    use kiln_geometry, only: bed_section

    !============
    implicit none
    private
    !============
    
    integer, parameter :: STATE_SIZE = 2

    type, extends(rhs_base_t) :: kramers_ode_t
      contains
        procedure :: initialize
        procedure :: evaluate
        final :: delete
    end type

    interface kramers_ode_t
        procedure :: new_ode
    end interface

  contains
    
    type(kramers_ode_t) function new_ode()
        new_ode % neqs = STATE_SIZE
        allocate(new_ode % du(STATE_SIZE))
        allocate(new_ode % u(STATE_SIZE))
    end function

    subroutine initialize(self, t, u)
        class(kramers_ode_t), intent(inout) :: self
        real(dp), intent(in)               :: t
        real(dp), allocatable, intent(in)  :: u(:)
        integer                            :: n

        n = size(u)

        if (n.ne.STATE_SIZE) then
            print *, 'Error: bad input size'
            print '(5X,"required size",I0," got ",I0)', STATE_SIZE, n
            stop "Unsuitable state vector size!"
        end if

        self % t = t
        self % u = u

        call self % evaluate(t, u)
    end subroutine

    subroutine evaluate(self, t, u)
        class(kramers_ode_t), intent(inout) :: self
        real(dp), intent(in)               :: t
        real(dp), allocatable, intent(in)  :: u(:)

        real(dp) :: h
        real(dp) :: A

        h = u(1)
        ! A = bed_section()
        self % du(1) = 1
        self % du(2) = 1
    end subroutine

    subroutine delete(self)
        type(kramers_ode_t) :: self

        if (allocated(self % du)) then
            deallocate(self % du)
        end if

        if (allocated(self % u)) then
            deallocate(self % u)
        end if
    end subroutine

end module kramers
