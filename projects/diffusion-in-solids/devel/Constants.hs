{-|
Module      : Constants
Copyright   : (c) Walter Dal'Maz Silva, 2025
License     : MIT
Maintainer  : walter.dalmazsilva.manager@gmail.com
Stability   : experimental
Portability : unknown, intended portable

Provides physical constants for diffusion calculations.
-}

module Constants (
        rGas,
        molarMassCC,
        molarMassNN,
        molarMassFe
    ) where

---------------------------------------------------------------------------------------------------
-- General physical constants.
---------------------------------------------------------------------------------------------------

-- Ideal gas constant [J/(mol.K)].
rGas :: Double
rGas = 8.314462618

---------------------------------------------------------------------------------------------------
-- Atomic/molar masses [g/mol].
---------------------------------------------------------------------------------------------------

molarMassCC :: Double
molarMassCC = 12.0

molarMassNN :: Double
molarMassNN = 14.0

molarMassFe :: Double
molarMassFe = 55.85

---------------------------------------------------------------------------------------------------
-- EOF
---------------------------------------------------------------------------------------------------