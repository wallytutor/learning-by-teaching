{-|
Module      : Carbonitriding
Copyright   : (c) Walter Dal'Maz Silva, 2025
License     : MIT
Maintainer  : walter.dalmazsilva.manager@gmail.com
Stability   : experimental
Portability : unknown, intended portable

Coefficients for carbonitriding simulation as per Skycke (1981).
-}
module Carbonitriding (
        diffusionCoefficients,
        massToMoleFraction,
        moleToMassFraction
    ) where


import Constants (molarMassCC, molarMassNN, molarMassFe)
import Kinetics (arrheniusRate)

------------------------------------------------------------------------------
-- Pre-exponential factor functions for C/N diffusion in austenite [m^2/s].
------------------------------------------------------------------------------

preExpSlycke :: Double -> Double -> Double -> Double
preExpSlycke a0 xk xt = a0 * num / den
    where num = (1.0 - 5.0 * xk)
          den = (1.0 - 5.0 * xt)

------------------------------------------------------------------------------
-- Modified activation energy for C/N diffusion in austenite [J/mol].
------------------------------------------------------------------------------

activationEnergyMod :: Double -> Double -> Double -> Double
activationEnergyMod t xc xn = -1.0 * e * f
    where e = 570_000.0 - 320.0 * t
          f = xc + 0.72 * xn

------------------------------------------------------------------------------
-- Diffusion coefficient functions for C/N diffusion in austenite [m^2/s].
------------------------------------------------------------------------------

diffusionCoeffC :: Double -> Double -> Double -> Double -> Double
diffusionCoeffC t xn xt eMod = arrheniusRate a e t
    where a = preExpSlycke 4.84e-05 xn xt
          e = 155_000.0 + eMod

diffusionCoeffN :: Double -> Double -> Double -> Double -> Double
diffusionCoeffN t xc xt eMod = arrheniusRate a e t
    where a = preExpSlycke 9.10e-05 xc xt
          e = 168_600.0 + eMod

diffusionCoefficients :: Double -> (Double, Double) -> (Double, Double)
diffusionCoefficients t (xc, xn) = (dc, dn)
    where xt   = xc + xn
          eMod = activationEnergyMod t xc xn
          dc   = diffusionCoeffC t xn xt eMod
          dn   = diffusionCoeffN t xc xt eMod

------------------------------------------------------------------------------
-- Conversion utilities for model setup.
------------------------------------------------------------------------------

molarMasses :: [Double]
molarMasses = [molarMassCC, molarMassNN, molarMassFe]

massFractions :: Double -> Double -> [Double]
massFractions yc yn = [yc, yn, 1.0 - yc - yn]

moleFractions :: Double -> Double -> [Double]
moleFractions xc xn = [xc, xn, 1.0 - xc - xn]

meanMolarMassY :: [Double] -> Double
meanMolarMassY y = 1.0 / (sum $ zipWith (/) y molarMasses)

meanMolarMassX :: [Double] -> Double
meanMolarMassX x = sum $ zipWith (*) x molarMasses

massToMoleFraction :: (Double, Double) -> (Double, Double)
massToMoleFraction (yc, yn) = (xc, xn)
    where mw = meanMolarMassY (massFractions yc yn)
          xc = (yc / molarMassCC) * mw
          xn = (yn / molarMassNN) * mw

moleToMassFraction :: (Double, Double) -> (Double, Double)
moleToMassFraction (xc, xn) = (yc, yn)
    where mw = meanMolarMassX (moleFractions xc xn)
          yc = (xc * molarMassCC) / mw
          yn = (xn * molarMassNN) / mw

------------------------------------------------------------------------------
-- EOF
------------------------------------------------------------------------------