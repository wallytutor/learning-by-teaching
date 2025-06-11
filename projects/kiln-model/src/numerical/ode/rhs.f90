module ode_rhs
    use constant, only: dp

    !============
    implicit none
    private
    !============

    type, public, abstract :: rhs_t
        logical, private      :: m_ready
        integer, private      :: m_neqs
        real(dp)              :: t
        real(dp), allocatable :: du(:)
        real(dp), allocatable :: u(:)
      contains
        procedure (initial), deferred :: initialize
        procedure (problem), deferred :: evaluate
        procedure :: set_state_ready
        procedure :: get_state_ready
        procedure :: set_num_equations
        procedure :: get_num_equations
    end type

    abstract interface ! initialize
        subroutine initial(self, t, u)
            import dp, rhs_t
            class(rhs_t),          intent(inout) :: self
            real(dp),              intent(in)    :: t
            real(dp), allocatable, intent(in)    :: u(:)
        end subroutine
    end interface

    abstract interface ! evaluate
        subroutine problem(self, t, u)
            import dp, rhs_t
            class(rhs_t),          intent(inout) :: self
            real(dp),              intent(in)    :: t
            real(dp), allocatable, intent(in)    :: u(:)
        end subroutine
    end interface

  contains

    subroutine set_state_ready(self, ready)
        class(rhs_t), intent(inout) :: self
        logical,      intent(in)    :: ready

        self % m_ready = ready
    end

    subroutine set_num_equations(self, neqs)
        class(rhs_t), intent(inout) :: self
        integer,      intent(in)    :: neqs
        logical :: alloc1, alloc2

        alloc1 = allocated(self % du)
        alloc2 = allocated(self % u)

        if (alloc1.or.alloc2) then
            print *, 'Error: cannot resize system RHS!'
            print '(5X,"got size",I0)', self % m_neqs
            stop "Failed to create RHS system!"
        else
            self % m_neqs = neqs
        end if

        if (.not.alloc1) then
            allocate(self % du(neqs))
        end if

        if (.not.alloc2) then
            allocate(self % u(neqs))
        end if

        call self % set_state_ready(.false.)
    end

    function get_state_ready(self) result(val)
        class(rhs_t), intent(in) :: self
        logical :: val

        val = self % m_ready
    end function

    function get_num_equations(self) result(val)
        class(rhs_t), intent(in) :: self
        integer :: val

        val = self % m_neqs
    end function

end module ode_rhs
