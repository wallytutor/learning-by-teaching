module kramers
    use constant

    !============
    implicit none
    !============
    
contains
    
end module kramers

! program rk45_example
!     implicit none
!     real :: t, x, h, tol
!     integer :: i, n

!     ! Initial conditions
!     t = 0.0
!     x = 1.0
!     h = 0.1
!     tol = 1.0e-6
!     n = 100

!     print *, "t", "x"
!     do i = 1, n
!         call rk45(f, t, x, h, tol)
!         print *, t, x
!     end do
! contains
!     function f(t, x) result(y)
!         real, intent(in) :: t, x
!         real :: y
!         y = x - t**2 + 1.0  ! Example ODE: dy/dt = x - t^2 + 1
!     end function f

!     subroutine rk45(f, t, x, h, tol)
!         interface
!             function f(t, x) result(y)
!                 real, intent(in) :: t, x
!                 real :: y
!             end function f
!         end interface
        
!         real, intent(inout) :: t, x, h
!         real, intent(in) :: tol
!         real :: k1, k2, k3, k4, k5, k6, x4, x5, error

!         k1 = h * f(t, x)
!         k2 = h * f(t + 0.25*h, x + 0.25*k1)
!         k3 = h * f(t + 0.375*h, x + 0.09375*k1 + 0.28125*k2)
!         k4 = h * f(t + 0.923*h, x + 0.87938*k1 - 3.2772*k2 + 3.32089*k3)
!         k5 = h * f(t + h, x + 2.0324*k1 - 8.0*k2 + 7.1735*k3 - 0.2059*k4)
!         k6 = h * f(t + 0.5*h, x - 0.2963*k1 + 2.0*k2 - 1.3817*k3 + 0.45297*k4 - 0.275*k5)

!         x4 = x + (0.11574*k1 + 0.54893*k3 + 0.53533*k4 - 0.2*k5)
!         x5 = x + (0.11852*k1 + 0.51899*k3 + 0.50613*k4 - 0.18*k5 + 0.03636*k6)

!         error = abs(x5 - x4)
!         if (error > tol) then
!             h = h * 0.9 * (tol / error)**0.25  ! Adjust step size
!         else
!             t = t + h
!             x = x5
!         end if
!     end subroutine rk45
! end program rk45_example
