#=
EP algorithm from
Alfredo Braunstein, Anna Paola Muntoni, and Andrea Pagnani, “An Analytic Approximation of the Feasible
Space of Metabolic Networks,” Nature Communications 8 (April 6, 2017): https://doi.org/10.1038/ncomms14915.
=#
"""
Calls Anna's EP implementation and returns the stuff we need (a, d, v, Σ).
"""
function anna_ep_wrapper(S, b, lb, ub; β = 1e12, maxiter = 100000, epsconv=1e-7)
    @assert β > 0 && maxiter > 0 && epsconv > 0
    epout, epmat = MetabolicEP.metabolicEP(S, b, lb, ub; beta=β,
        maxiter=maxiter, verbose=false, epsconv=epsconv)

    #= Anna's code scales fluxes to [-1,1], but it
    doesn't rescale a,d back to the original range =#
    maxflux = max(maximum(abs.(lb)), maximum(abs.(ub)))
    a = epout.sol.a * maxflux;
    d = epout.sol.b * maxflux^2;
    #= a, d are the mean and variance of the univariate Gaussians
    used as site approximations in the EP =#

    #= Similarly, Anna's code never rescales the
    contents of epmat =#
    v = epmat.v * maxflux
    Σ = epmat.invKKPD * maxflux^2
    iΣ = epmat.KKPD / maxflux^2
    #= v, Σ are the mean vector and covariance matrix of Q,
    the full multivariate Gaussian (in Braunstein et al paper =#

    #= The mean and variance of the univariate marginals of Q(n)
    for each flux. Note that this does not include truncation.
    These guys are re-scaled in Anna's code, so no need to do that
    here again. =#
    μ = epout.μ
    ν = epout.σ

    @assert epout.status == :converged || epout.status == :unconverged
    if epout.status == :converged
        info("EP converged.")
    else
        warn("EP did not converge.")
    end

    # Here I return everything that I use later
    return μ, ν, a, d, v, iΣ, Σ, epout.status;
end


"converts reversible reactions to back/forward pair"
function ep_init_rev(S, mets, rxns, fbasol)
    m, n = size(S)

    rev_idx = Vector{Int}()     # indexes of reversible reactions
    for (k, rxn) in enumerate(eachrow(rxns))
        if rxn[:nub] < 0 < rxn[:pub]
            push!(rev_idx, k)
        end
    end

    rxnlb = [rxns[:plb]; -rxns[:nlb][rev_idx]]
    rxnub = [rxns[:pub]; -rxns[:nub][rev_idx]]
    a = [rxns[:ap]; rxns[:an][rev_idx]]

    @assert all(rxnlb .< rxnub)

    Srev = [S -S[:,rev_idx]]

    exchangeable_metabolites_idx = find((mets[:V] .> 0) .& (mets[:c] .> 0) .| (mets[:L] .< 0))
    exchangeable_metabolites = mets[exchangeable_metabolites_idx, :]

    uptake_ub = chemostat_bound.(mets[:V], mets[:c], fbasol.ξ)[exchangeable_metabolites_idx]
    uptake_lb = mets[:L][exchangeable_metabolites_idx]
    @assert all(uptake_lb .< uptake_ub)
    @assert all(uptake_lb .≤ 0 .≤ uptake_ub)

    @assert all(uptake_lb .≤ fbasol.u[exchangeable_metabolites_idx] .≤ uptake_ub)

    # Stoichiometric matrix of exchange reactions
    exchange_reactions_sto = sparse(
        exchangeable_metabolites_idx, 1 : length(exchangeable_metabolites_idx),
        ones(exchangeable_metabolites_idx), m, length(exchangeable_metabolites_idx)
    )

    # These are the columns of A:
    A = [Srev                   exchange_reactions_sto                  -mets[:y]   zeros(m);
         a'                     zeros(exchangeable_metabolites_idx)'    0           -1]

    b = [mets[:e]; 0.];

    lb = [rxnlb; uptake_lb; 0.; 0.];
    ub = [rxnub; uptake_ub; fbasol.μ; fbasol.ϕ];

    metsid = [mets[:id]; enz_mass_met]
    rxnsid = [rxns[:id]; rxns[:id][rev_idx] .* rev_sufix; exch_prefix .*
        exchangeable_metabolites[:id]; biomassid; enz_mass_react]


    return A, b, lb, ub, metsid, rxnsid
end

"""
    Call this from outside. Does the EP.
"""
function __ep__(S, mets, rxns, fbasol; β = 1e12, maxiter = 100000, epsconv=1e-8)
    A, b, lb, ub, metsid, rxnsid = ep_init_rev(S, mets, rxns, fbasol)
    μ, ν, a, d, v, iΣ, Σ, ep_status = anna_ep_wrapper(A, b, lb, ub, β = β,
        maxiter = maxiter, epsconv = epsconv)
    return EPResults(fbasol.ξ, μ, ν, a, d, v, iΣ, Σ, lb, ub, metsid, rxnsid, ep_status)
end
