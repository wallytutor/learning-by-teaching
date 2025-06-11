module numutils
    use constant

    !============
    implicit none
    private
    !============

    public linspace

  contains

    pure function linspace(a, b, n) result(arr)
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