-- diffusion.hs

import Carbonitriding (diffusionCoefficients)
import Constants (molarMassCC, molarMassNN, molarMassFe)

(dc, dn) = diffusionCoefficients 0.010 0.005 1173.15


molarMasses = [molarMassCC, molarMassNN, molarMassFe]

massFractions yc yn = [yc, yn, 1.0 - yc - yn]
moleFractions xc xn = [xc, xn, 1.0 - xc - xn]

meanMolarMassY y = 1.0 / (sum $ zipWith (/) y molarMasses)
meanMolarMassX x = sum $ zipWith (*) x molarMasses

massToMoleFraction yc yn = (xc, xn)
    where mw = meanMolarMassY (massFractions yc yn)
          xc = (yc / molarMassCC) * mw
          xn = (yn / molarMassNN) * mw
