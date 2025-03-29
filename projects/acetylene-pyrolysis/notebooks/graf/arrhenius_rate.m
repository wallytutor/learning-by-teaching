function k = arrhenius_rate(T, A, Ea)
    k = A * exp(-Ea / (8.31446261815324 * T));
end
