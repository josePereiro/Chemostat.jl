# fba_w_mc_chemostat -------------------------------------------------------------------------
"""
    fba_w_mc_chemostat(gem::Chemostat.GEMs.GEM, ξ::Number; description = "")
    fba_w_mc_chemostat(gem::Chemostat.GEMs.GEM, ξs; description = "", verbose = true)
    fba_w_mc_chemostat(gem::Chemostat.GEMs.GEM; sample_approx_len = 20,
            ξ_lb = 1, verbose = true, ξs_to_include = [], description = "")

    Perform FBAwMC to a GEM, include the chemostat constraints,
    See http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1005835
"""
function fba_w_mc_chemostat(gem::Chemostat.GEMs.GEM, ξ::Number; description = "")
    ξ = Float64(ξ);
    Chemostat.GEMs.check_data_quality(gem);
    LP = gurobi_problem(gem.S, gem.mets, gem.rxns);
    fbasol = model_solve!(LP, gem.S, gem.mets, gem.rxns, ξ);
    return ExpRes(fbasol, gem, description);
end

function fba_w_mc_chemostat(gem::Chemostat.GEMs.GEM, ξs;
                    description = "", verbose = true)
    ξs = Float64.(ξs);

    # Cheking
    verbose && println("Checking gem data quality!!!");
    Chemostat.GEMs.check_data_quality(gem);
    verbose && println("Check passed!!!");

    # FBA
    LP = gurobi_problem(gem.S,gem.mets,gem.rxns);
    fbasols = Vector{FBASolution}(length(ξs));
    verbose && println();
    verbose && println("Executing FBAwMC");
    verbose && println();
    for (i,ξ) in enumerate(Float64.(ξs))
        fbasols[i] = model_solve!(LP, gem.S,gem.mets, gem.rxns, ξ)
        verbose && println("ξ = $(ξ) [$i/$(length(ξs))] μ: $(fbasols[i].μ)");
        verbose && flush(STDOUT);
    end
    verbose && println();
    verbose && println("Finished ...");
    return ExpRes(fbasols, gem, description);
end

function fba_w_mc_chemostat(gem::Chemostat.GEMs.GEM;
                    sample_approx_len = 20,
                    ξ_lb = 1, verbose = true, ξs_to_include = [],
                description = "")
    # Checking
    verbose && println("Checking gem data quality!!!");
    Chemostat.GEMs.check_data_quality(gem);
    verbose && println("Check passed!!!");

    # Finding ξ_ub
    verbose && println("Finding ξ_ub");
    ξ_lb = Float64(ξ_lb);
    ξ_ub = find_max_xi(gem.S, gem.mets, gem.rxns);
    if ξ_lb >= ξ_ub error("ξ_lb = $ξ_lb is greater than ξ_ub = $ξ_ub!!!"); end
    verbose && println("ξ_ub = $ξ_ub found!!!");
    #ξs
    ξs = Chemostat.Tools.log_sample(ξ_lb, ξ_ub,
                        include = ξs_to_include,
                    approx_len = sample_approx_len);
    verbose && println("ξs from $ξ_lb to $ξ_ub, length $(length(ξs))");
    verbose && println();
    verbose && flush(STDOUT);


    #FBA
    verbose && println("FBA");
    return fba_w_mc_chemostat(gem, ξs, description = description, verbose = verbose);

end
