module test_sample_ode
    use constant
    use test_utils
    use numutils
    use ode_rhs
    use ode_rkf45

    !============
    implicit none
    private
    !============

    public test

    integer, parameter :: STATE_SIZE = 1

    type, extends(rhs_t) :: sample_ode_t
      contains
        procedure :: initialize
        procedure :: evaluate
        final :: delete
    end type

    interface sample_ode_t
        procedure :: new_ode
    end interface

  contains

    subroutine test()
        type(sample_ode_t)    :: ode
        type(ode_rkf45_t)     :: integ
        real(dp)              :: t, x, y
        real(dp), allocatable :: u(:)
        real(dp), allocatable :: times(:)
        integer               :: i, n

        print *, 'TEST: check RK45 integration'

        allocate(u(1))

        ! Array of time points
        n = 10+1
        times = linspace(0.0_dp, 1.0_dp, n)

        ! Initial conditions
        t = times(1)
        u(1) = 1.0

        ode = sample_ode_t()
        call ode % initialize(t, u)

        integ = ode_rkf45_t(ode)
        integ % atol = 1.0e-08
        integ % tmin = 1.0e-06

        call integ % integrate(times)

        ! print *, 'Function evaluations', integ % totfevs

        do i = 1, n
            t = integ % sol(i, 1)
            x = integ % sol(i, 2)
            y = t**2 + 2*t + 1
            ! print '(ES15.6,ES15.6,ES15.6)', t, x, y
            call check_result(x, y, integ % atol, integ % atol, 'point')
        end do
    end subroutine

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

        call self % evaluate(t, u)
    end subroutine

    subroutine evaluate(self, t, u)
        class(sample_ode_t), intent(inout) :: self
        real(dp), intent(in)               :: t
        real(dp), allocatable, intent(in)  :: u(:)

        self % du(1) = u(1) - t**2 + 1.0
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

end module test_sample_ode

module test_numerical
    use test_sample_ode, only: run_test_sample_ode => test

    !============
    implicit none
    private
    !============

    public test

  contains

    subroutine test()
        print *, ''
        print *, 'test_numerical'

        call run_test_sample_ode()
    end subroutine

end module test_numerical
