-- diffusion.hs

import Carbonitriding (
    diffusionCoefficients,
    massToMoleFraction,
    moleToMassFraction)

------------------------------------------------------------------------------
-- Problem conditions
------------------------------------------------------------------------------

n   = 100
t   = 1173.15
yc0 = 0.016
yn0 = 0.000

------------------------------------------------------------------------------
-- Problem setup
------------------------------------------------------------------------------

-- Compose initial profiles:
yc = replicate n yc0
yn = replicate n yn0

-- Convert to mole fractions:
compositionsX = map massToMoleFraction (zip yc yn)

------------------------------------------------------------------------------
-- Problem solution
------------------------------------------------------------------------------

-- 1. Retrieve composition-dependent diffusion coefficients.
-- 2. Assemble matrices for solution of each species.
-- 3. Perform an implicit time step with iterative coupling.
-- 4. Repeat steps 1-3 until final time is reached.

(dc, dn) = unzip $ map (diffusionCoefficients t) compositionsX

------------------------------------------------------------------------------
-- Post-processing
------------------------------------------------------------------------------

compositionsY = map moleToMassFraction compositionsX

(ycFinal, ynFinal) = unzip compositionsY

------------------------------------------------------------------------------
-- EOF
------------------------------------------------------------------------------