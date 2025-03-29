function M = mean_molecular_mass(Y, W)
    M = 1.0 / sum(Y ./ W);
end
