!------------------------------------------------------------------
! INTERPOLATION
!------------------------------------------------------------------

! TODO

!------------------------------------------------------------------
! RHS
!------------------------------------------------------------------

module rhs_base
    use constant

    !============
    implicit none
    private
    !============

    type, public, abstract :: rhs_base_t
        integer               :: neqs
        real(dp)              :: t
        real(dp), allocatable :: du(:)
        real(dp), allocatable :: u(:)
      contains
        procedure (initial), deferred :: initialize
        procedure (problem), deferred :: evaluate
    end type

    abstract interface ! initialize
        subroutine initial(self, t, u)
            import dp, rhs_base_t
            class(rhs_base_t), intent(inout)  :: self
            real(dp), intent(in)              :: t
            real(dp), allocatable, intent(in) :: u(:)
        end subroutine
    end interface

    abstract interface ! evaluate
        subroutine problem(self, t)
            import dp, rhs_base_t
            class(rhs_base_t), intent(inout) :: self
            real(dp), intent(in)             :: t
        end subroutine
    end interface

end module rhs_base

!------------------------------------------------------------------
! ODE SOLVERS
!------------------------------------------------------------------

module integ_rkf45
    ! https://en.wikipedia.org/wiki/Runge%E2%80%93Kutta%E2%80%93Fehlberg_method
    use constant
    use rhs_base

    !============
    implicit none
    private
    !============

    type, public :: integ_rkf45_t
        class(rhs_base_t), pointer :: rhs
    end type

    interface integ_rkf45_t
        procedure :: new_integ
    end interface

  contains

    type(integ_rkf45_t)  function new_integ(rhs)
        class(rhs_base_t), target, intent(inout) :: rhs

        new_integ % rhs => rhs
    end function

end module integ_rkf45

module ode_rkf
    use constant
    use rhs_base

    !============
    implicit none
    private
    !============

    public rk45

    real(dp), parameter :: A(6) = [    &
        (0.000e+00_dp / 1.000e+00_dp), &
        (1.000e+00_dp / 4.000e+00_dp), &
        (3.000e+00_dp / 8.000e+00_dp), &
        (1.200e+01_dp / 1.300e+01_dp), &
        (1.000e+00_dp / 1.000e+00_dp), &
        (1.000e+00_dp / 2.000e+00_dp)]

    ! type, public :: ode_t
    !     procedure(ode_rhs), pointer :: rhs
    ! end type

    ! interface ode_t
    !     procedure :: new_ode
    ! end interface

    interface
        function ode_rhs(t, x) result(y)
            import dp
            real(dp), intent(in) :: t
            real(dp), intent(in) :: x
            real(dp) :: y
        end function
    end interface

  contains

    ! type(ode_t) function new_ode(rhs)
    !     procedure(ode_rhs), pointer :: rhs

    !     new_ode % rhs => rhs
    ! end function

    subroutine rk45(f, t, x, h, tol)
        procedure(ode_rhs) :: f
        real(dp), intent(inout) :: t, x, h
        real(dp), intent(in) :: tol
        real(dp) :: t1, t2, t3, t4, t5, t6
        real(dp) :: k1, k2, k3, k4, k5, k6
        real(dp) ::x4, x5, error

        t1 = t + h * A(1)
        t2 = t + h * A(2)
        t3 = t + h * A(3)
        t4 = t + h * A(4)
        t5 = t + h * A(5)
        t6 = t + h * A(6)

        k1 = h * f(t1, x)
        k2 = h * f(t2, x + 0.25000*k1)
        k3 = h * f(t3, x + 0.09375*k1 + 0.28125*k2)
        k4 = h * f(t4, x + 0.87938*k1 - 3.2772*k2 + 3.32089*k3)
        k5 = h * f(t5, x + 2.0324*k1 - 8.0*k2 + 7.1735*k3 - 0.2059*k4)
        k6 = h * f(t6, x - 0.2963*k1 + 2.0*k2 - 1.3817*k3 + 0.45297*k4 - 0.275*k5)

        x4 = x + (0.11574*k1 + 0.54893*k3 + 0.53533*k4 - 0.2*k5)
        x5 = x + (0.11852*k1 + 0.51899*k3 + 0.50613*k4 - 0.18*k5 + 0.03636*k6)

        error = abs(x5 - x4)

        if (error > tol) then
            h = h * 0.9 * (tol / error)**0.25
        else
            t = t + h
            x = x5
        end if
    end subroutine rk45

end module ode_rkf

!------------------------------------------------------------------
! SAMPLE
!------------------------------------------------------------------

module sample_ode
    use constant
    use rhs_base

    !============
    implicit none
    private
    !============

    integer, parameter :: STATE_SIZE = 1

    type, public, extends(rhs_base_t) :: sample_ode_t
      contains
        procedure :: initialize
        procedure :: evaluate
        final :: delete
    end type

    interface sample_ode_t
        procedure :: new_ode
    end interface

  contains

    type(sample_ode_t) function new_ode()
        new_ode % neqs = STATE_SIZE
        allocate(new_ode % du(STATE_SIZE))
        allocate(new_ode % u(STATE_SIZE))
    end function

    subroutine initialize(self, t, u)
        class(sample_ode_t), intent(inout) :: self
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

        call self % evaluate(t)
    end subroutine

    subroutine evaluate(self, t)
        class(sample_ode_t), intent(inout) :: self
        real(dp), intent(in)               :: t

        self % du(1) = self % u(1) - t**2 + 1.0
    end subroutine

    subroutine delete(self)
        type(sample_ode_t) :: self

        deallocate(self % du)
        deallocate(self % u)
    end subroutine

end module sample_ode