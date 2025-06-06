module shomate
    use constant
    use thermo_base

    ! type, public, extends(thermo_base_t) :: thermo_shomate_t
    !     real(dp) :: coefs_lo(8)
    !     real(dp) :: coefs_hi(8)
    !   contains
    ! end type thermo_shomate_t

    ! interface thermo_shomate_t
    !     procedure :: new_thermo_shomate
    ! end interface thermo_shomate_t

contains

    ! function [p] = shomate_specific_heat(T, c)
    !     % Molar specific heat with Shomate equation [J/(mol.K)].
    !     p = T.*(c(2)+T.*(c(3)+c(4).*T))+c(5)./T.^2+c(1);
    ! endfunction
    !
    ! function [p] = shomate_enthalpy(T, c)
    !     % Molar enthalpy with Shomate equation [J/mol].
    !     p = T.*(c(1)+T.*(c(2)/2+T.*(c(3)/3+c(4)/4.*T)))-c(5)./T+c(6)-c(8);
    ! endfunction
    !
    ! function [p] = shomate_entropy(T, c)
    !     % Entropy with Shomate equation [J/K].
    !     p = c(1).*log(T)+T.*(c(2)+T.*(c(3)/2+c(4)/3.*T))+c(5)./(2.*T.^2)+c(7);
    ! endfunction

end module shomate
