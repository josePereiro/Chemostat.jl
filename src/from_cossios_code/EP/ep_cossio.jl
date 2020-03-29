#=
EP algorithm from
Alfredo Braunstein, Anna Paola Muntoni, and Andrea Pagnani, “An Analytic Approximation of the Feasible
Space of Metabolic Networks,” Nature Communications 8 (April 6, 2017): https://doi.org/10.1038/ncomms14915.
=#

"""
    Call this from outside. Does the EP.
"""
function __ep__(S, mets, rxns, fbasol; β = 1e12, maxiter = 100000, epsconv=1e-8)
    A, b, lb, ub, metsid, rxnsid = ep_init_rev(S, mets, rxns, fbasol)
    μ, ν, a, d, v, iΣ, Σ, ep_status = anna_ep_wrapper(A, b, lb, ub, β = β,
        maxiter = maxiter, epsconv = epsconv)
    return EPResults(fbasol.ξ, μ, ν, a, d, v, iΣ, Σ, lb, ub, metsid, rxnsid, ep_status)
end

"""
    This set the linear problem that will feed the anna ep algorithm.
    A * x = b
    lb <= x <= ub
"""
function ep_init_rev(S, mets, rxns, fbasol)
    m, n = size(S)

    # indexes of reversible reactions
    rev_idx = Vector{Int}()     
    for (k, rxn) in enumerate(eachrow(rxns))
        if rxn[:nub] < 0 < rxn[:pub]
            push!(rev_idx, k)
        end
    end

    # collect rxns data [rxn; rev_rxn]
    # plb <= r+ <= pub
    # -nlb <= r- <= -nub
    rxnlb = [rxns[:plb]; -rxns[:nlb][rev_idx]]
    rxnub = [rxns[:pub]; -rxns[:nub][rev_idx]]
    a = [rxns[:ap]; rxns[:an][rev_idx]]

    # Reaction bound checking
    for (i, rxn_i) in enumerate([1:n; rev_idx])
        lb = rxnlb[i]
        ub = rxnub[i]
        rxn_id = rxns[:id][rxn_i]

        if !(lb < ub)
            error("Error checking lb < ub: lb ($lb), ub ($ub), rxn_id ($rxn_id)")
        end
    end

    # the same with the S data
    Srev = [S -S[:,rev_idx]]

    # collect exchangeable metabolites
    exchangeable_metabolites_idx = find((mets[:V] .> 0) .& (mets[:c] .> 0) .| (mets[:L] .< 0))
    exchangeable_metabolites = mets[exchangeable_metabolites_idx, :]

    uptake_ub = chemostat_bound.(mets[:V], mets[:c], fbasol.ξ)[exchangeable_metabolites_idx]
    uptake_lb = mets[:L][exchangeable_metabolites_idx]

    # Uptake bound checking
    for (i, exch_i) in enumerate(exchangeable_metabolites_idx)

        upk_lb = uptake_lb[i]
        upk_ub = uptake_ub[i]
        fba_u = fbasol.u[exch_i]
        met_id = mets[:id][exch_i]

        if !(upk_lb < upk_ub)
            error("Error checking upk_lb < upk_ub: upk_lb ($upk_lb), upk_ub ($upk_ub), met_id (met_id)")
        end
        if !(upk_lb ≤ 0 ≤ upk_ub)
            error("Error checking upk_lb ≤ 0 ≤ upk_ub: upk_lb ($upk_lb), upk_ub ($upk_ub), met_id (met_id)")
        end
        if !(upk_lb ≤ fba_u ≤ upk_ub)
            error("Error checking upk_lb ≤ fba_u ≤ upk_ub: upk_lb ($upk_lb), upk_ub ($upk_ub), fba_u ($fba_u), met_id (met_id)")
        end

    end
    
    
    # Stoichiometric matrix of exchange reactions
    # one row for each metabolite and one column for each exchange
    exchange_reactions_sto = sparse(
        exchangeable_metabolites_idx, # row indexes
        1 : length(exchangeable_metabolites_idx), # column indexes
        ones(exchangeable_metabolites_idx), # values 
        m, length(exchangeable_metabolites_idx) # dimensions
    )

    # These are the columns of A:
    # nrev is the number of reversible reactions
    # nexch the number of exchangeable metabolites
    # A =  | [m x (n + nrev)] [m x nexch] [m x 1] [m x 1] |
    #      | [1 x (n + nrev)] [1 x nexch]    0      -1    |
    #
    A = [Srev                   exchange_reactions_sto                  -mets[:y]   zeros(m);
         a'                     zeros(exchangeable_metabolites_idx)'    0           -1]
    # right hand member 
    # [(m + 1) x 1]
    b = [mets[:e]; 0.];

    # Total bounds [((n + nrev) + (m + nexch) + 1 + 1) x 1]
    lb = [rxnlb; uptake_lb; 0.; 0.];
    ub = [rxnub; uptake_ub; fbasol.μ; fbasol.ϕ];

    # mets ids [(m + 1) x 1]
    metsid = [mets[:id]; enz_mass_met];

    # rxns ids [(n + nrev + nexch + 1 + 1) x 1]
    rxnsid = [rxns[:id]; rxns[:id][rev_idx] .* rev_sufix; 
        exch_prefix .* exchangeable_metabolites[:id]; 
        biomassid; enz_mass_react]


    return A, b, lb, ub, metsid, rxnsid
end

"""
Calls Anna's EP implementation and returns the stuff we need (a, d, v, Σ).
"""
function anna_ep_wrapper(S, b, lb, ub; β = 1e12, maxiter = 100000, epsconv=1e-7)
    @assert β > 0 && maxiter > 0 && epsconv > 0

    # calls Anna's method
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
        verbose && info("EP converged.")
    else
        verbose && warn("EP did not converge.")
    end

    # Here I return everything that I use later
    return μ, ν, a, d, v, iΣ, Σ, epout.status;
end