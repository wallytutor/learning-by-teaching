module test_utils
    use constant

    !============
    implicit none
    private
    !============

    public check_result

  contains

    subroutine check_result(val, ref, atol, rtol, name)
        real(dp), intent(in)         :: val
        real(dp), intent(in)         :: ref
        real(dp), intent(in)         :: atol
        real(dp), intent(in)         :: rtol
        character(len=*), intent(in) :: name

        real(dp) :: ares, rres

        ares = abs(val - ref)
        rres = ares / max(abs(ref), abs(val))

        if ((ares > atol).or.(rres > rtol)) then
            print '("Failed to compute ",A20," : ",ES15.6, ES15.6)', &
                name, ares, rres
        end if
    end subroutine

end module test_utils