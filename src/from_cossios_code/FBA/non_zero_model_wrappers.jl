function nonzero_reduce_model(gem::Chemostat.GEMs.GEM)
    Chemostat.GEMs.check_data_quality(gem);
    Chemostat.GEMs.GEM(nonzero_reduce_model(gem.S, gem.mets, gem.rxns)...);
end

function nonzero_reduce_model(gem::Chemostat.GEMs.GEM, ξ_ub)
    Chemostat.GEMs.GEM.check_data_quality(gem);
    Chemostat.GEMs.GEM(nonzero_reduce_model(gem.S, gem.mets, gem.rxns, ξ_ub)...);
end
