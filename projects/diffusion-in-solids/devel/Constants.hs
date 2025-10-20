{-|
Module      : Constants
Copyright   : (c) Walter Dal'Maz Silva, 2025
License     : MIT
Maintainer  : walte.dalmazsilva.managerr@gmail.com
Stability   : experimental
Portability : unknown, intended portable

Provides physical constants for diffusion calculations.
-}

module Constants (
        rGas
    ) where

-- Ideal gas constant [J/(mol.K)].
rGas :: Double
rGas = 8.314462618
