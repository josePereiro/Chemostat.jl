### Code derived from MaxEntChemostat2018 Cossios package.
# nonzero_reduce_model -------------------------------------------------------------------------
"""
Scans the range of feasible ξ values and removes
all the reactions that are always zero. Also removes
metabolites that are left without reactions.
Returns the reduced S, mets, rxns (without modifying
original arguments).
"""
function nonzero_reduce_model(S, mets, rxns, ξ_ub)
    @assert 0 < nonzero_reduce_model_Δξ < Inf

    LP = gurobi_problem(S, mets, rxns)
    nz_rxns_idx = Set{Int}()
    for ξ = 0.01 : nonzero_reduce_model_Δξ : ξ_ub - nonzero_reduce_model_Δξ
        fbasol = model_solve!(LP, S, mets, rxns, ξ)
        for (k, rxn) in enumerate(DataFrames.eachrow(rxns))
            iszero(fbasol.r[k]) || push!(nz_rxns_idx, k)
        end
    end

    nz_rxns_idx = sort(collect(nz_rxns_idx))
    nz_mets_idx = [i for i = 1 : size(S, 1) if !iszero(S[i, nz_rxns_idx])]
    nz_S = S[nz_mets_idx, nz_rxns_idx]
    nz_rxns = rxns[nz_rxns_idx, :]
    nz_mets = mets[nz_mets_idx, :]

    if isempty(nz_S) error("Fba is returning all fluxes as zero!!!") end

    return nz_S, nz_mets, nz_rxns
end

function nonzero_reduce_model(S, mets, rxns)
    LP = gurobi_problem(S, mets, rxns)
    ξmax = find_max_xi!(LP, S, mets, rxns)
    @assert ξmax > 0
    return nonzero_reduce_model(S, mets, rxns, ξmax);
end
