module ode_rkf45
    ! https://en.wikipedia.org/wiki/Runge%E2%80%93Kutta%E2%80%93Fehlberg_method
    use constant
    use ode_rhs

    !============
    implicit none
    private
    !============

    type :: ode_rkf45_mem_t
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

        class(rhs_t), pointer :: rhs
      contains
         procedure :: step
    end type

    type, public :: ode_rkf45_t
        integer  :: maxfevs
        integer  :: totfevs
        real(dp) :: atol
        real(dp) :: ttol
        real(dp) :: h_now
        real(dp) :: h_last
        real(dp), allocatable :: sol(:, :)
        class(ode_rkf45_mem_t), allocatable :: mem
      contains
        procedure :: integrate
        procedure :: advance
    end type

    interface ode_rkf45_mem_t
        procedure :: new_mem
    end interface

    interface ode_rkf45_t
        procedure :: new_integ
    end interface

  contains

    type(ode_rkf45_mem_t) function new_mem(rhs)
        class(rhs_t), target, intent(inout) :: rhs
        integer :: n, m

        if (.not.rhs % get_state_ready()) then
            print *, 'Error: RHS function not initialized!'
            stop "Failed to create RKF45 ODE solver!"
        end if

        n = rhs % get_num_equations()
        new_mem % rhs => rhs

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

    type(ode_rkf45_t) function new_integ(rhs)
        class(rhs_t), target, intent(inout) :: rhs

        new_integ % totfevs = 0
        new_integ % maxfevs = 10
        new_integ % atol = 1.0e-06
        new_integ % ttol = 1.0e-12

        new_integ % mem = ode_rkf45_mem_t(rhs)
    end function

    subroutine integrate(self, times)
        class(ode_rkf45_t), intent(inout) :: self
        real(dp), allocatable, intent(inout) :: times(:)

        integer  :: i, n, m

        ! Allocate solution table:
        n = size(times)
        m = 1 + self % mem % rhs % get_num_equations()

        if (.not.allocated(self % sol)) then
            allocate(self % sol(n, m))
        end if

        ! Initialize solution table:
        self % sol(1, 1) = times(1)
        self % sol(1, 2:m) = self % mem % rhs % u

        ! A *high* value for *last* step initially:
        self % h_last = times(size(times))

        do i = 2, n
            ! Update time points and global step:
            ! XXX: this should have been done in initialize!
            !self % mem % rhs % t = times(i-1)

            ! Try to advance to current *t_out*:
            call self % advance(times(i))

            ! Store current time and results:
            self % sol(i, 1)  = self % mem % rhs % t
            self % sol(i, 2:) = self % mem % rhs % u
        end do
    end

    subroutine advance(self, t_out)
        class(ode_rkf45_t), intent(inout) :: self
        real(dp),           intent(in)    :: t_out

        integer  :: maxfevs
        real(dp) :: t_last
        real(dp) :: h

        ! Initialize counter:
        maxfevs = 0

        ! Compure required step to reach `t_out`:
        self % h_now = t_out - self % mem % rhs % t

        ! Enforce first `t` < `t_out`:
        h = self % h_now * 2.0_dp / 3.0_dp

        ! Use a smaller step if that was already the case:
        if (h.gt.self % h_last) then
            h = self % h_last
        end if

        ! Keep track of last output time:
        t_last = self % mem % rhs % t

        do while (abs(t_out - self % mem % rhs % t) > self % ttol)
            ! Increment counter and call stepper:
            self % totfevs = self % totfevs + 1
            call self % mem % step(h, self % atol, self % ttol)

            ! Update last tentative step:
            self % h_last = h

            ! Last call to step did not progress, try again:
            if (abs(self % mem % rhs % t - t_last) < self % ttol) then
                maxfevs = maxfevs + 1
                cycle
            end if

            ! Reached maximum number of trials:
            if (maxfevs.ge.self % maxfevs) then
                print *, 'Error: maximum number of function evaluations!'
                print '(5X,"required <=",I0)', self % maxfevs
                stop "Advancement failed to progress!"
            end if

            ! How much does it take to reach exit? Keep in mind
            ! that the step to exit may be less than current `h`:
            h = min(t_out - self % mem % rhs % t, self % h_last)
        end do
    end

    subroutine step(self, h, atol, ttol)
        class(ode_rkf45_mem_t), intent(inout) :: self
        real(dp),               intent(inout) :: h
        real(dp),               intent(in)    :: atol
        real(dp),               intent(in)    :: ttol

        real(dp) :: error

        !--------------------------------------------------------------
        ! COEFFICIENTS
        !--------------------------------------------------------------

        real(dp), parameter :: ct1  = 0.0000e+00_dp / 1.0000e+00_dp
        real(dp), parameter :: ct2  = 1.0000e+00_dp / 4.0000e+00_dp
        real(dp), parameter :: ct3  = 3.0000e+00_dp / 8.0000e+00_dp
        real(dp), parameter :: ct4  = 1.2000e+01_dp / 1.3000e+01_dp
        real(dp), parameter :: ct5  = 1.0000e+00_dp / 1.0000e+00_dp
        real(dp), parameter :: ct6  = 1.0000e+00_dp / 2.0000e+00_dp

        real(dp), parameter :: ck12 = 1.0000e+00_dp / 4.0000e+00_dp
        real(dp), parameter :: ck13 = 3.0000e+00_dp / 3.2000e+01_dp
        real(dp), parameter :: ck14 = 1.9320e+03_dp / 2.1970e+03_dp
        real(dp), parameter :: ck15 = 4.3900e+02_dp / 2.1600e+02_dp
        real(dp), parameter :: ck16 = 8.0000e+00_dp / 2.7000e+01_dp
        real(dp), parameter :: ce14 = 2.5000e+01_dp / 2.1600e+02_dp
        real(dp), parameter :: ce15 = 1.6000e+01_dp / 1.3500e+02_dp

        real(dp), parameter :: ck23 = 9.0000e+00_dp / 3.2000e+01_dp
        real(dp), parameter :: ck24 = 7.2000e+03_dp / 2.1970e+03_dp
        real(dp), parameter :: ck25 = 8.0000e+00_dp / 1.0000e+00_dp
        real(dp), parameter :: ck26 = 2.0000e+00_dp / 1.0000e+00_dp

        real(dp), parameter :: ck34 = 7.2960e+03_dp / 2.1970e+03_dp
        real(dp), parameter :: ck35 = 3.6800e+03_dp / 5.1300e+02_dp
        real(dp), parameter :: ck36 = 3.5440e+03_dp / 2.5650e+03_dp
        real(dp), parameter :: ce34 = 1.4080e+03_dp / 2.5650e+03_dp
        real(dp), parameter :: ce35 = 6.6560e+03_dp / 1.2825e+04_dp

        real(dp), parameter :: ck45 = 8.4500e+02_dp / 4.1040e+03_dp
        real(dp), parameter :: ck46 = 1.8590e+03_dp / 4.1040e+03_dp
        real(dp), parameter :: ce44 = 2.1970e+03_dp / 4.1040e+03_dp
        real(dp), parameter :: ce45 = 2.8561e+04_dp / 5.6430e+04_dp

        real(dp), parameter :: ck56 = 1.1000e+01_dp / 4.0000e+01_dp
        real(dp), parameter :: ce54 = 1.0000e+00_dp / 5.0000e+00_dp
        real(dp), parameter :: ce55 = 9.0000e+00_dp / 5.0000e+01_dp

        real(dp), parameter :: ce65 = 2.0000e+00_dp / 5.5000e+01_dp

        real(dp), parameter :: cr1  = 0.9_dp
        real(dp), parameter :: cr2  = 0.2_dp

        !--------------------------------------------------------------
        ! INITIALIZE
        !--------------------------------------------------------------

        self % t1 = self % rhs % t + h * ct1
        self % t2 = self % rhs % t + h * ct2
        self % t3 = self % rhs % t + h * ct3
        self % t4 = self % rhs % t + h * ct4
        self % t5 = self % rhs % t + h * ct5
        self % t6 = self % rhs % t + h * ct6

        self % x0 = self % rhs % u
        self % x1 = self % rhs % u
        self % x2 = self % rhs % u
        self % x3 = self % rhs % u
        self % x4 = self % rhs % u
        self % x5 = self % rhs % u
        self % x6 = self % rhs % u

        self % e4 = 0.0_dp
        self % e5 = 0.0_dp

        !--------------------------------------------------------------
        ! STEP 1
        !--------------------------------------------------------------

        call self % rhs % evaluate(self % t1, self % x1)
        self % k1 = h * self % rhs % du

        self % x2 = self % x2 + ck12 * self % k1
        self % x3 = self % x3 + ck13 * self % k1
        self % x4 = self % x4 + ck14 * self % k1
        self % x5 = self % x5 + ck15 * self % k1
        self % x6 = self % x6 - ck16 * self % k1
        self % e4 = self % e4 + ce14 * self % k1
        self % e5 = self % e5 + ce15 * self % k1

        !--------------------------------------------------------------
        ! STEP 2
        !--------------------------------------------------------------

        call self % rhs % evaluate(self % t2, self % x2)
        self % k2 = h * self % rhs % du

        self % x3 = self % x3 + ck23 * self % k2
        self % x4 = self % x4 - ck24 * self % k2
        self % x5 = self % x5 - ck25 * self % k2
        self % x6 = self % x6 + ck26 * self % k2

        !--------------------------------------------------------------
        ! STEP 3
        !--------------------------------------------------------------

        call self % rhs % evaluate(self % t3, self % x3)
        self % k3 = h * self % rhs % du

        self % x4 = self % x4 + ck34 * self % k3
        self % x5 = self % x5 + ck35 * self % k3
        self % x6 = self % x6 - ck36 * self % k3
        self % e4 = self % e4 + ce34 * self % k3
        self % e5 = self % e5 + ce35 * self % k3

        !--------------------------------------------------------------
        ! STEP 4
        !--------------------------------------------------------------

        call self % rhs % evaluate(self % t4, self % x4)
        self % k4 = h * self % rhs % du

        self % x5 = self % x5 - ck45 * self % k4
        self % x6 = self % x6 + ck46 * self % k4
        self % e4 = self % e4 + ce44 * self % k4
        self % e5 = self % e5 + ce45 * self % k4

        !--------------------------------------------------------------
        ! STEP 5
        !--------------------------------------------------------------

        call self % rhs % evaluate(self % t5, self % x5)
        self % k5 = h * self % rhs % du

        self % x6 = self % x6 - ck56 * self % k5
        self % e4 = self % e4 - ce54 * self % k5
        self % e5 = self % e5 - ce55 * self % k5

        !--------------------------------------------------------------
        ! STEP 6
        !--------------------------------------------------------------

        call self % rhs % evaluate(self % t6, self % x6)
        self % k6 = h * self % rhs % du

        self % e5 = self % e5 + ce65 * self % k6

        !--------------------------------------------------------------
        ! ERROR
        !--------------------------------------------------------------

        error = maxval(abs(self % e5 - self % e4))

        if (error > atol) then
            h = h * cr1 * (atol / error)**cr2
        else
            self % rhs % t = self % rhs % t + h
            self % rhs % u = self % x0 + self % e5
        end if

        ! TODO: increase step if tolerance was respected for a while...

        ! Check if minimum step was reached:
        if (h.le.ttol) then
            print *, 'Error: reached minimum time step!'
            print '(5X,"got ",ES12.6," < ",ES12.6)', h, ttol
            stop "Advancement failed to progress!"
        end if
    end

end module ode_rkf45
