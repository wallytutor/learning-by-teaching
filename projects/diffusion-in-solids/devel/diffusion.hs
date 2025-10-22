-- diffusion.hs

import Data.List (zip4)
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

-- Solve Ax = d where A is tridiagonal with subdiagonal a, diagonal b, superdiagonal c
thomas :: Fractional g => [g] -> [g] -> [g] -> [g] -> [g]
thomas as bs cs ds = xs
  where
    n = length bs
    bs' = b(0) : [b(i) - a(i)/b'(i-1) * c(i-1) | i <- [1..n-1]]
    ds' = d(0) : [d(i) - a(i)/b'(i-1) * d'(i-1) | i <- [1..n-1]]
    xs = reverse $ d'(n-1) / b'(n-1) : [(d'(i) - c(i) * x(i+1)) / b'(i) | i <- [n-2, n-3..0]]

    -- convenience accessors (because otherwise it's hard to read)
    a i = as !! (i-1) --  because the list's first item is equivalent to a_1
    b i = bs !! i
    c i = cs !! i
    d i = ds !! i
    x i = xs !! i
    b' i = bs' !! i
    d' i = ds' !! i

-- Solve Ax = d where A is tridiagonal with subdiagonal a, diagonal b, superdiagonal c
-- Solve Ax = d for tridiagonal A with subdiag a, diag b, superdiag c
-- Conventions: a !! 0 is ignored (use 0), c !! (n-1) is ignored (can be 0)
tdma :: Fractional a => [a] -> [a] -> [a] -> [a] -> [a]
tdma a b c d
  | null b || length b /= length d || length a /= length b || length c /= length b
  = error "tdma: mismatched lengths"
  | otherwise =
      let -- forward sweep: compute modified coefficients c' and d'
          c0 = head c / head b
          d0 = head d / head b

          rest = zip4 (tail a) (tail b) (tail c) (tail d)
          step (cPrev, dPrev, csAcc, dsAcc) (ai, bi, ci, di) =
            let denom = bi - ai * cPrev
                cNew  =           ci / denom
                dNew  = (di - ai * dPrev) / denom
            in (cNew, dNew, cNew : csAcc, dNew : dsAcc)

          (_, _, csAcc, dsAcc) = foldl step (c0, d0, [c0], [d0]) rest
          cs' = reverse csAcc
          ds' = reverse dsAcc

          -- back substitution: x_n = d'_n; x_i = d'_i - c'_i * x_{i+1}
          x = foldr (\(ci, di) acc@(xNext:_) -> (di - ci * xNext) : acc)
                    [last ds']
                    (zip cs' (init ds'))
      in x



a = [0, 1, 1]     -- subdiagonal (a₁ to aₙ₋₁)
b = [4, 4, 4, 4]  -- main diagonal
c = [1, 1, 0]     -- superdiagonal (c₀ to cₙ₋₂)
d = [5, 6, 6, 5]  -- RHS vector
x = thomas a b c d
xs = tdma a b c d
