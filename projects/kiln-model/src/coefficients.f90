module coefficients
    use, intrinsic :: iso_fortran_env, only : dp => real64

    !============
    implicit none
    private
    !============

  contains

end module coefficients

module li2005
    use constant

    !============
    implicit none
    private
    !============

  contains

end module li2005

module dimensionless
    use constant

    !============
    implicit none
    private
    !============

  contains

    pure function reynolds_axial(v, D_e, nu) result(val)
        ! Axial Reynolds number in rotary kiln.
        ! Tcheng (1979), exposed by Li (2005)
        real(dp), intent(in) :: v
          ! Flue gases local mean velocity [m/s].
        real(dp), intent(in) :: D_e
          ! Kiln equivalent internal diameter [m].
        real(dp), intent(in) :: nu
          ! Flue gases kinematic viscosity [m^2/s].
        real(dp)             :: val

        val = v * D_e / nu
    end function

    pure function reynolds_angular(w, D_e, nu) result(val)
        ! Rotational Reynolds (Taylor) number in rotary kiln.
        ! Tcheng (1979), exposed by Li (2005)
        real(dp), intent(in) :: w
          ! Kiln angular velocity [rad/s].
        real(dp), intent(in) :: D_e
          ! Kiln equivalent internal diameter [m].
        real(dp), intent(in) :: nu
          ! Flue gases kinematic viscosity [m^2/s].
        real(dp)             :: val
        
        val = w * D_e**2 / nu
    end function

    pure function nusselt_fb_eb(Re_d, Re_w, eta) result(val)
        ! Nusselt number definition for freeboard to exposed bed pair.
        ! Tcheng (1979), 1600<Re_d<7800, 20<Re_w<800
        real(dp), intent(in) :: Re_d
        real(dp), intent(in) :: Re_w
        real(dp), intent(in) :: eta
        real(dp)             :: val

        ! TODO add validity check

        val = 0.46 * Re_d**(0.535) * Re_w**(0.104) * eta**(-0.341)
    end function

    pure function nusselt_fb_ew(Re_d, Re_w) result(val)
        ! Nusselt number definition for freeboard to exposed bed pair.
        ! Tcheng (1979), 1600<Re_d<7800, 20<Re_w<800
        real(dp), intent(in) :: Re_d
        real(dp), intent(in) :: Re_w
        real(dp)             :: val

        ! TODO add validity check

        val = 1.54 * Re_d**(0.575) * Re_w**(-0.292)
    end function

end module dimensionless

!------------------------------------------------------------------
! IMPORTANT: in what follows we have a convention of storing heat
! transfer coefficients in modules dedicated to the pair to which
! they correspond to, regardless of the data source. The provided
! functions are pure in a sense that they expect no specific data
! structure, but simply arguments. It is up the the user who will
! assemble the heat fluxes to import the adapted coefficients and
! wrap them in a suitable way. The following naming convention is
! adopted:
!
! - `fb`: freeboard (gas)
! - `cw`: covered wall
! - `eb`: exposed bed
! - `ew`: exposed wall
!------------------------------------------------------------------

module heat_transfer_fb_eb
    use constant
    
    !============
    implicit none
    private
    !============

  contains

end module heat_transfer_fb_eb

module heat_transfer_fb_ew
    use constant
    
    !============
    implicit none
    private
    !============

  contains

end module heat_transfer_fb_ew

module heat_transfer_ew_eb
    use constant
    
    !============
    implicit none
    private
    !============

  contains

end module heat_transfer_ew_eb

module heat_transfer_cw_cb
    use constant
    
    !============
    implicit none
    private
    !============

  contains

end module heat_transfer_cw_cb

module heat_transfer_shell
    use constant
    
    !============
    implicit none
    private
    !============

  contains

end module heat_transfer_shell