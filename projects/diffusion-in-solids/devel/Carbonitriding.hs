{-|
Module      : Carbonitriding
Copyright   : (c) Walter Dal'Maz Silva, 2025
License     : MIT
Maintainer  : walte.dalmazsilva.managerr@gmail.com
Stability   : experimental
Portability : unknown, intended portable

Coefficients for carbonitriding simulation as per Skycke (1981).
-}
module Carbonitriding (
        diffusionCoefficients
    ) where


import Kinetics (arrheniusRate)

---------------------------------------------------------------------------------------------------
-- Pre-exponential factor functions for carbon/nitrogen diffusion in austenite [m^2/s].
---------------------------------------------------------------------------------------------------

preExpSlycke :: Double -> Double -> Double -> Double
preExpSlycke a0 xk xt = a0 * num / den
    where num = (1.0 - 5.0 * xk)
          den = (1.0 - 5.0 * xt)

---------------------------------------------------------------------------------------------------
-- Activation energy modification for carbon/nitrogen diffusion in austenite [J/mol].
---------------------------------------------------------------------------------------------------

activationEnergyMod :: Double -> Double -> Double -> Double
activationEnergyMod t xc xn = -1.0 * e * f
    where e = 570_000.0 - 320.0 * t
          f = xc + 0.72 * xn

---------------------------------------------------------------------------------------------------
-- Diffusion coefficient functions for carbon/nitrogen diffusion in austenite [m^2/s].
---------------------------------------------------------------------------------------------------

diffusionCoeffC :: Double -> Double -> Double -> Double -> Double
diffusionCoeffC t xn xt eMod = arrheniusRate a e t
    where a = preExpSlycke 4.84e-05 xn xt
          e = 155_000.0 + eMod

diffusionCoeffN :: Double -> Double -> Double -> Double -> Double
diffusionCoeffN t xc xt eMod = arrheniusRate a e t
    where a = preExpSlycke 9.10e-05 xc xt
          e = 168_600.0 + eMod

diffusionCoefficients :: Double -> Double -> Double -> (Double, Double)
diffusionCoefficients xc xn t = (dc, dn)
    where xt   = xc + xn
          eMod = activationEnergyMod t xc xn
          dc   = diffusionCoeffC t xn xt eMod
          dn   = diffusionCoeffN t xc xt eMod