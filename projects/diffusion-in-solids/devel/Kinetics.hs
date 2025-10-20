{-|
Module      : Kinetics
Copyright   : (c) Walter Dal'Maz Silva, 2025
License     : MIT
Maintainer  : walte.dalmazsilva.managerr@gmail.com
Stability   : experimental
Portability : unknown, intended portable

Provides kinetics functions used in diffusion calculations.
-}
module Kinetics (
        arrheniusRate
    ) where

import Constants (rGas)

arrheniusRate :: Double -> Double -> Double -> Double
arrheniusRate a e t = a * exp (- e / (rGas * t))
