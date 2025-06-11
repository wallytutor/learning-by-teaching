!------------------------------------------------------------------
! GENERAL
!------------------------------------------------------------------

module numutils
    use constant

    !============
    implicit none
    private
    !============

    public linspace

  contains

    function linspace(a, b, n) result(arr)
        real(dp), intent(in)  :: a
        real(dp), intent(in)  :: b
        integer, intent(in)   :: n
        real(dp), allocatable :: arr(:)

        real(dp)              :: step
        integer               :: i

        allocate(arr(n))

        step = (b - a) / (n - 1)

        arr(1) = a
        arr(n) = b
        arr(2:n-1) = [(a + (i-1)*step, i = 2, n-1)]
    end function

end module numutils

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
        subroutine problem(self, t, u)
            import dp, rhs_base_t
            class(rhs_base_t), intent(inout)  :: self
            real(dp), intent(in)              :: t
            real(dp), allocatable, intent(in) :: u(:)
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

    type :: integ_rkf45_mem_t
        real(dp) :: t1
        real(dp) :: t2
        real(dp) :: t3
        real(dp) :: t4
        real(dp) :: t5
        real(dp) :: t6

        ! Store solution before the rest:
        real(dp), allocatable :: x0(:)

        real(dp), allocatable :: x1(:)
        real(dp), allocatable :: x2(:)
        real(dp), allocatable :: x3(:)
        real(dp), allocatable :: x4(:)
        real(dp), allocatable :: x5(:)
        real(dp), allocatable :: x6(:)

        real(dp), allocatable :: k1(:)
        real(dp), allocatable :: k2(:)
        real(dp), allocatable :: k3(:)
        real(dp), allocatable :: k4(:)
        real(dp), allocatable :: k5(:)
        real(dp), allocatable :: k6(:)

        real(dp), allocatable :: e4(:)
        real(dp), allocatable :: e5(:)
    end type

    type, public :: integ_rkf45_t
        integer  :: maxfevs
        integer  :: totfevs
        real(dp) :: atol
        real(dp) :: ttol
        real(dp) :: tmin
        real(dp) :: t_now
        real(dp) :: t_out
        real(dp) :: h_now
        real(dp) :: h_last
        real(dp), allocatable :: sol(:, :)
        class(rhs_base_t), pointer :: rhs
        class(integ_rkf45_mem_t), allocatable :: mem
      contains
        procedure :: integrate
        procedure :: advance
        procedure :: step
    end type

    interface integ_rkf45_mem_t
        procedure :: new_mem
    end interface

    interface integ_rkf45_t
        procedure :: new_integ
    end interface

  contains

    type(integ_rkf45_mem_t) function new_mem(n)
        integer, intent(in) :: n

        allocate(new_mem % x0(n))
        allocate(new_mem % x1(n))
        allocate(new_mem % x2(n))
        allocate(new_mem % x3(n))
        allocate(new_mem % x4(n))
        allocate(new_mem % x5(n))
        allocate(new_mem % x6(n))
        allocate(new_mem % k1(n))
        allocate(new_mem % k2(n))
        allocate(new_mem % k3(n))
        allocate(new_mem % k4(n))
        allocate(new_mem % k5(n))
        allocate(new_mem % k6(n))
        allocate(new_mem % e4(n))
        allocate(new_mem % e5(n))
    end function

    type(integ_rkf45_t) function new_integ(rhs)
        class(rhs_base_t), target, intent(inout) :: rhs

        new_integ % totfevs = 0
        new_integ % maxfevs = 10
        new_integ % atol = 1.0e-06
        new_integ % ttol = 1.0e-12
        new_integ % tmin = 1.0e-10

        new_integ % rhs => rhs
        new_integ % mem = integ_rkf45_mem_t(rhs % neqs)
    end function

    subroutine integrate(self, times)
        class(integ_rkf45_t), intent(inout)  :: self
        real(dp), allocatable, intent(inout) :: times(:)

        integer  :: i, n, m

        ! Allocate solution table:
        n = size(times)
        m = 1 + self % rhs % neqs

        if (.not.allocated(self % sol)) then
            allocate(self % sol(n, m))
        end if

        ! Initialize solution table:
        self % sol(1, 1) = times(1)
        self % sol(1, 2:m) = self % rhs % u

        ! A *high* value for *last* step initially:
        self % h_last = times(size(times))

        do i = 2, n
            ! Update time points and global step:
            self % t_now = times(i-1)
            self % t_out = times(i)

            ! Try to advance to current *t_out*:
            call self % advance(self % t_out)

            ! Store current time and results:
            self % sol(i, 1)  = self % t_out
            self % sol(i, 2:) = self % rhs % u
        end do
    end

    subroutine advance(self, t_out)
        class(integ_rkf45_t), intent(inout) :: self
        real(dp), intent(inout)             :: t_out

        integer  :: maxfevs
        real(dp) :: t_last, h_incr
        real(dp) :: h

        ! Initialize counter:
        maxfevs = 0

        ! Compure required step to reach `t_out`:
        self % h_now = t_out - self % t_now

        ! Enforce first `t_now` < `t_out`:
        h = self % h_now * 2.0_dp / 3.0_dp

        ! Use a smaller step if that was already the case:
        if (h.gt.self % h_last) then
            h = self % h_last
        end if

        ! Keep track of last output time:
        t_last = self % t_now

        do while (abs(self % t_out - self % t_now) > self % ttol)
            call self % step(h)

            ! Update last tentative step:
            self % h_last = h

            ! Last call to step did not progress, try again:
            if (abs(self % t_now - t_last) < self % ttol) then
                maxfevs = maxfevs + 1
                cycle
            end if

            ! Reached maximum number of trials:
            if (maxfevs.ge.self % maxfevs) then
                print *, 'Error: maximum number of function evaluations!'
                print '(5X,"required <=",I0)', self % maxfevs
                stop "Advancement failed to progress!"
            end if

            ! How much does it take to reach exit?
            h_incr = self % t_out - self % t_now

            ! Step to exit may be less than current `h`
            h = min(h_incr, self % h_last)
        end do
    end

    subroutine step(self, h)
        class(integ_rkf45_t), intent(inout) :: self
        real(dp), intent(inout)             :: h

        real(dp) :: error

        !--------------------------------------------------------------
        ! INITIALIZE
        !--------------------------------------------------------------

        self % totfevs = self % totfevs + 1

        self % mem % t1 = self % t_now + h * (0.000e+00_dp / 1.000e+00_dp)
        self % mem % t2 = self % t_now + h * (1.000e+00_dp / 4.000e+00_dp)
        self % mem % t3 = self % t_now + h * (3.000e+00_dp / 8.000e+00_dp)
        self % mem % t4 = self % t_now + h * (1.200e+01_dp / 1.300e+01_dp)
        self % mem % t5 = self % t_now + h * (1.000e+00_dp / 1.000e+00_dp)
        self % mem % t6 = self % t_now + h * (1.000e+00_dp / 2.000e+00_dp)

        self % mem % x0 = self % rhs % u
        self % mem % x1 = self % rhs % u
        self % mem % x2 = self % rhs % u
        self % mem % x3 = self % rhs % u
        self % mem % x4 = self % rhs % u
        self % mem % x5 = self % rhs % u
        self % mem % x6 = self % rhs % u

        self % mem % e4 = 0.0_dp
        self % mem % e5 = 0.0_dp

        !--------------------------------------------------------------
        ! STEP 1
        !--------------------------------------------------------------

        call self % rhs % evaluate(self % mem % t1, self % mem % x1)
        self % mem % k1 = h * self % rhs % du

        self % mem % x2 = self % mem % x2 + (1.0000e+00_dp / 4.0000e+00_dp) * self % mem % k1
        self % mem % x3 = self % mem % x3 + (3.0000e+00_dp / 3.2000e+01_dp) * self % mem % k1
        self % mem % x4 = self % mem % x4 + (1.9320e+03_dp / 2.1970e+03_dp) * self % mem % k1
        self % mem % x5 = self % mem % x5 + (4.3900e+02_dp / 2.1600e+02_dp) * self % mem % k1
        self % mem % x6 = self % mem % x6 - (8.0000e+00_dp / 2.7000e+01_dp) * self % mem % k1
        self % mem % e4 = self % mem % e4 + (2.5000e+01_dp / 2.1600e+02_dp) * self % mem % k1
        self % mem % e5 = self % mem % e5 + (1.6000e+01_dp / 1.3500e+02_dp) * self % mem % k1

        !--------------------------------------------------------------
        ! STEP 2
        !--------------------------------------------------------------

        call self % rhs % evaluate(self % mem % t2, self % mem % x2)
        self % mem % k2 = h * self % rhs % du

        self % mem % x3 = self % mem % x3 + (9.0000e+00_dp / 3.2000e+01_dp) * self % mem % k2
        self % mem % x4 = self % mem % x4 - (7.2000e+03_dp / 2.1970e+03_dp) * self % mem % k2
        self % mem % x5 = self % mem % x5 - (8.0000e+00_dp / 1.0000e+00_dp) * self % mem % k2
        self % mem % x6 = self % mem % x6 + (2.0000e+00_dp / 1.0000e+00_dp) * self % mem % k2

        !--------------------------------------------------------------
        ! STEP 3
        !--------------------------------------------------------------

        call self % rhs % evaluate(self % mem % t3, self % mem % x3)
        self % mem % k3 = h * self % rhs % du

        self % mem % x4 = self % mem % x4 + (7.2960e+03_dp / 2.1970e+03_dp) * self % mem % k3
        self % mem % x5 = self % mem % x5 + (3.6800e+03_dp / 5.1300e+02_dp) * self % mem % k3
        self % mem % x6 = self % mem % x6 - (3.5440e+03_dp / 2.5650e+03_dp) * self % mem % k3
        self % mem % e4 = self % mem % e4 + (1.4080e+03_dp / 2.5650e+03_dp) * self % mem % k3
        self % mem % e5 = self % mem % e5 + (6.6560e+03_dp / 1.2825e+04_dp) * self % mem % k3

        !--------------------------------------------------------------
        ! STEP 4
        !--------------------------------------------------------------

        call self % rhs % evaluate(self % mem % t4, self % mem % x4)
        self % mem % k4 = h * self % rhs % du

        self % mem % x5 = self % mem % x5 - (8.4500e+02_dp / 4.1040e+03_dp) * self % mem % k4
        self % mem % x6 = self % mem % x6 + (1.8590e+03_dp / 4.1040e+03_dp) * self % mem % k4
        self % mem % e4 = self % mem % e4 + (2.1970e+03_dp / 4.1040e+03_dp) * self % mem % k4
        self % mem % e5 = self % mem % e5 + (2.8561e+04_dp / 5.6430e+04_dp) * self % mem % k4

        !--------------------------------------------------------------
        ! STEP 5
        !--------------------------------------------------------------

        call self % rhs % evaluate(self % mem % t5, self % mem % x5)
        self % mem % k5 = h * self % rhs % du

        self % mem % x6 = self % mem % x6 - (1.1000e+01_dp / 4.0000e+01_dp) * self % mem % k5
        self % mem % e4 = self % mem % e4 - (1.0000e+00_dp / 5.0000e+00_dp) * self % mem % k5
        self % mem % e5 = self % mem % e5 - (9.0000e+00_dp / 5.0000e+01_dp) * self % mem % k5

        !--------------------------------------------------------------
        ! STEP 6
        !--------------------------------------------------------------

        call self % rhs % evaluate(self % mem % t6, self % mem % x6)
        self % mem % k6 = h * self % rhs % du

        self % mem % e5 = self % mem % e5 + (2.0000e+00_dp / 5.5000e+01_dp) * self % mem % k6

        !--------------------------------------------------------------
        ! ERROR
        !--------------------------------------------------------------

        error = maxval(abs(self % mem % e5 - self % mem % e4))

        if (error > self % atol) then
            h = h * 0.9 * (self % atol / error)**0.2
        else
            self % t_now = self % t_now + h
            self % rhs % u = self % mem % x0 + self % mem % e5
        end if

        ! TODO: increase step if tolerance was respected for a while...

        ! Check if minimum step was reached:
        if (h.lt.self % tmin) then
            print *, 'Error: reached minimum time step!'
            print '(5X,"got ",ES12.6," < ",ES12.6)', h, self % tmin
            stop "Advancement failed to progress!"
        end if
    end

end module integ_rkf45
