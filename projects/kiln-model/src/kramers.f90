module kramers
    use constant

    !============
    implicit none
    private
    !============
    
  contains
    
end module kramers

module kiln_geometry
    use constant

    !============
    implicit none
    private
    !============

  contains

    pure function equivalent_diameter(D, phi) result(val)
        ! Kiln equivalent diameter proposed by Tscheng (1979).
        real(dp), intent(in) :: D
          ! Internal diameter of kiln [m].
        real(dp), intent(in) :: phi
          ! Central bed angle [rad].
        real(dp)             :: val
        real(dp)             :: num
        real(dp)             :: den

        num = 2 * PI - phi / 1 + sin(phi / 1)
        den = 1 * PI - phi / 2 + sin(phi / 2)
        val = 0.5 * D * num / den
    end

    pure function filling_ratio(phi) result(val)
        ! Kiln equivalent diameter proposed by Tscheng (1979).
        real(dp), intent(in) :: phi
          ! Central bed angle [rad].
        real(dp)             :: val

        val = (phi - sin(phi)) / (2 * PI)
    end function

end module kiln_geometry