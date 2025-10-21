///////////////////////////////////////////////////////////////////////
// CONSTANTS
///////////////////////////////////////////////////////////////////////

// Ideal gas constant [J/(mol.K)].
R_GAS = 8.314462618

///////////////////////////////////////////////////////////////////////
// DATA VALIDATION
///////////////////////////////////////////////////////////////////////

function validate_composition(X, tol)
    arguments
        X (:, 1) double
        tol      double
    end

    if or(X < 0) then
        error("Compositions should not contain negative numbers.")
    end

    if sum(X) < tol then
        error("Compositions should not add up to approximately zero.")
    end

    try
        assert_checkalmostequal(sum(X), 1, tol)
    catch
        disp("WARNING: renormalizing composition!")
        X = X / sum(X)
    end
endfunction

function validate_slycke_composition(X, tol)
    arguments
        X (7, 1) double
        tol double = 10 * %eps
    end
    validate_composition(X, tol)
endfunction

///////////////////////////////////////////////////////////////////////
// PHYSICS
///////////////////////////////////////////////////////////////////////

function [r] = Reaction(A_c, B_c, A_f, E_f, A_b, E_b)
    arguments
        A_c double
        B_c double
        A_f double
        E_f double
        A_b double
        E_b double
    end

    r = struct("A_c", A_c, "B_c", B_c, ..
               "A_f", A_f, "E_f", E_f, ..
               "A_b", A_b, "E_b", E_b)
end

function [K] = equilibrium_by_def(T, A, B)
    K = 10^(A + B / T)
endfunction

function [k] = arrhenius_by_def(T, A, E)
    k = A * exp(-E / (R_GAS * T))
endfunction

function [K] = equilibrium_constant(T, r)
    K = equilibrium_by_def(T, r.A_c, r.B_c)
endfunction

function [k] = forward_rate(T, r)
    k = arrhenius_by_def(T, r.A_f, r.E_f)
endfunction

function [k] = backward_rate(T, r)
    k = arrhenius_by_def(T, r.A_b, r.E_b)
endfunction
