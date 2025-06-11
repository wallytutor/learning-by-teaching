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
        ! real(dp) :: h
        ! real(dp) :: tol
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

    interface
        function ode_rhs(t, x) result(y)
            import dp
            real(dp), intent(in) :: t
            real(dp), intent(in) :: x
            real(dp) :: y
        end function
    end interface

  contains

    subroutine rk45(f, t, x, h, tol)
        procedure(ode_rhs) :: f
        real(dp), intent(inout) :: t, x, h
        real(dp), intent(in) :: tol

        real(dp) :: t1, t2, t3, t4, t5, t6
        real(dp) :: x1, x2, x3, x4, x5, x6
        real(dp) :: k1, k2, k3, k4, k5, k6
        real(dp) :: e4, e5, error

        t1 = t + h * (0.000e+00_dp / 1.000e+00_dp)
        t2 = t + h * (1.000e+00_dp / 4.000e+00_dp)
        t3 = t + h * (3.000e+00_dp / 8.000e+00_dp)
        t4 = t + h * (1.200e+01_dp / 1.300e+01_dp)
        t5 = t + h * (1.000e+00_dp / 1.000e+00_dp)
        t6 = t + h * (1.000e+00_dp / 2.000e+00_dp)

        x1 = x
        x2 = x
        x3 = x
        x4 = x
        x5 = x
        x6 = x

        e4 = 0.0_dp
        e5 = 0.0_dp

        k1 = h * f(t1, x1)
        x2 = x2 + (1.0000e+00_dp / 4.0000e+00_dp) * k1
        x3 = x3 + (3.0000e+00_dp / 3.2000e+01_dp) * k1
        x4 = x4 + (1.9320e+03_dp / 2.1970e+03_dp) * k1
        x5 = x5 + (4.3900e+02_dp / 2.1600e+02_dp) * k1
        x6 = x6 - (8.0000e+00_dp / 2.7000e+01_dp) * k1
        e4 = e4 + (2.5000e+01_dp / 2.1600e+02_dp) * k1
        e5 = e5 + (1.6000e+01_dp / 1.3500e+02_dp) * k1 
    
        k2 = h * f(t2, x2)
        x3 = x3 + (9.0000e+00_dp / 3.2000e+01_dp) * k2
        x4 = x4 - (7.2000e+03_dp / 2.1970e+03_dp) * k2
        x5 = x5 - (8.0000e+00_dp / 1.0000e+00_dp) * k2
        x6 = x6 + (2.0000e+00_dp / 1.0000e+00_dp) * k2

        k3 = h * f(t3, x3)
        x4 = x4 + (7.2960e+03_dp / 2.1970e+03_dp) * k3
        x5 = x5 + (3.6800e+03_dp / 5.1300e+02_dp) * k3
        x6 = x6 - (3.5440e+03_dp / 2.5650e+03_dp) * k3
        e4 = e4 + (1.4080e+03_dp / 2.5650e+03_dp) * k3
        e5 = e5 + (6.6560e+03_dp / 1.2825e+04_dp) * k3 

        k4 = h * f(t4, x4)
        x5 = x5 - (8.4500e+02_dp / 4.1040e+03_dp) * k4
        x6 = x6 + (1.8590e+03_dp / 4.1040e+03_dp) * k4
        e4 = e4 + (2.1970e+03_dp / 4.1040e+03_dp) * k4
        e5 = e5 + (2.8561e+04_dp / 5.6430e+04_dp) * k4 

        k5 = h * f(t5, x5)
        x6 = x6 - (1.1000e+01_dp / 4.0000e+01_dp) * k5
        e4 = e4 - (1.0000e+00_dp / 5.0000e+00_dp) * k5
        e5 = e5 - (9.0000e+00_dp / 5.0000e+01_dp) * k5 

        k6 = h * f(t6, x6)
        e5 = e5 + (2.0000e+00_dp / 5.5000e+01_dp) * k6
        
        error = abs(e5 - e4)

        if (error > tol) then
            h = h * 0.9 * (tol / error)**0.25
        else
            t = t + h
            x = x + e5
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

        if (allocated(self % du)) then
            deallocate(self % du)
        end if

        if (allocated(self % u)) then
            deallocate(self % u)
        end if
    end subroutine

end module sample_ode
