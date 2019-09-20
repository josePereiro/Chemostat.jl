function find_max_xi(gem::Chemostat.GEMs.GEM)
    @assert tol > 0
    Chemostat.GEMs.check_data_quality(gem);
    LP = gurobi_problem(gem.S, gem.mets, gem.rxns);
    return find_max_xi!(LP, gem.S, gem.mets, gem.rxns);
end
