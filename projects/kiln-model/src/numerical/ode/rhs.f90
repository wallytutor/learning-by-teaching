module ode_rhs
    use constant, only: dp

    !============
    implicit none
    private
    !============

    type, public, abstract :: rhs_t
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

end module ode_rhs
