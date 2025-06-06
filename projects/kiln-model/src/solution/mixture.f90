module mixture
    use constant

    !============
    implicit none
    private
    !============

    public mass_to_mole_fraction
    public mole_to_mass_fraction

  contains

    ! subroutine mean_molecular_mass(V, basis) result(p)
    ! end subroutine

    subroutine mass_to_mole_fraction(W, Y, X)
        real(dp), intent(in)    :: W(:)
        real(dp), intent(in)    :: Y(:)
        real(dp), intent(inout) :: X(:)

        real(dp) :: M

        M = 1.0_dp / sum(Y / W)
        X = Y * M / W
    end subroutine

    subroutine mole_to_mass_fraction(W, X, Y)
        real(dp), intent(in)    :: W(:)
        real(dp), intent(in)    :: X(:)
        real(dp), intent(inout) :: Y(:)

        real(dp) :: M

        M = dot_product(X, W)
        Y = X * W / M
    end subroutine

    subroutine normalize_fractions(A)
        real(dp), intent(inout) :: A(:)
        real(dp) :: total

        total = sum(A)

        if (abs(total - 1.0_dp) >= SMALL_FRACTION) then
            A = A / total
        end if
    end subroutine

end module mixture