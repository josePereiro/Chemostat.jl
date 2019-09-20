function ep(gem::Chemostat.GEMs.GEM, ξs;
        β = 1e12, maxiter = 100000, epsconv = 1e-7,
        verbose = true)

    #Cheking data
    # Checking
    verbose && println("Checking gem data quality!!!");
    Chemostat.GEMs.check_data_quality(gem);
    verbose && println("Check passed!!!");
    S, mets, rxns = gem.S, gem.mets, gem.rxns;

    epress = [];
    verbose && println("EP");
    for (i,ξ) in enumerate(Float64.(ξs))

        verbose && println("Processing ξ = $ξ, [$i/$(length(ξs))]");
        verbose && flush(STDOUT);

        # FBA
        LP = Chemostat.FBA.gurobi_problem(S, mets, rxns);
        fbasol = Chemostat.FBA.model_solve!(LP, S, mets, rxns, ξ);

        # EP
        push!(epress, __ep__(S, mets, rxns, fbasol;
                β = β, maxiter = maxiter, epsconv = epsconv))
    end

    #return
    res = Dict();
    res["ep"] = epress;
    res["gem"] = gem;
    return res;
end

function ep(gem::Chemostat.GEMs.GEM; ξ_lb = 1, ξs_to_include = [],
        sample_approx_len = 25, β = 1e12, maxiter = 100000,
        epsconv = 1e-7,
        verbose = true)

    # Checking
    verbose && println("Checking gem data quality!!!");
    Chemostat.GEMs.check_data_quality(gem);
    verbose && println("Check passed!!!");

    # Finding ξ_ub
    verbose && println("Finding ξ_ub");
    ξ_lb = Float64(ξ_lb);
    ξ_ub = Chemostat.FBA.find_max_xi(gem.S, gem.mets, gem.rxns);
    if ξ_lb >= ξ_ub error("ξ_lb = $ξ_lb is greater than ξ_ub = $ξ_ub!!!"); end
    verbose && println("ξ_ub = $ξ_ub found!!!");
    verbose && flush(STDOUT);
    #ξs
    ξs = Chemostat.Tools.log_sample(ξ_lb, ξ_ub,
                        include = ξs_to_include,
                    approx_len = sample_approx_len);
    verbose && println("ξs from $ξ_lb to $ξ_ub, length $(length(ξs))");
    verbose && println();
    verbose && flush(STDOUT);

    #EP
    return ep(gem, ξs, β = β, maxiter = maxiter, epsconv = epsconv,
        verbose = verbose)
end
