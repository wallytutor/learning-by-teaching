function rho = ideal_gas_density(T, P, Y, W)
    M = mean_molecular_mass(Y, W);
    rho = (P * M) / (8314.46261815324 * T);
end
