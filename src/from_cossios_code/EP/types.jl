"""
Data structure to organize the results of the EP run.
"""
struct EPResults
    ξ::Float64
    μ::Vector{Float64}
    ν::Vector{Float64}
    a::Vector{Float64}
    d::Vector{Float64}
    v::Vector{Float64}
    iΣ::Matrix{Float64}
    Σ::Matrix{Float64}
    lb::Vector{Float64}
    ub::Vector{Float64}
    metsid::Vector{String}
    rxnsid::Vector{String}
    ep_status::Symbol
end

# Expres
function ExpRes(epress::Dict, β, description)

    β = Float64(β);

    # expres
    expres = Chemostat.ExpRess.ExpRes();
    gem = epress["gem"];
    Chemostat.set_working_gem(gem);

    for (i, epres) in enumerate(epress["ep"])

        # mets and rxns
        if i == 1
            Chemostat.ExpRess.set_metids!(expres, [met for met in epres.metsid if is_met(met)]);
            Chemostat.ExpRess.set_rxnids!(expres, [rxn for rxn in epres.rxnsid if is_inner_rxn(rxn)]);
            for met in Chemostat.RES.get_mets_ids(expres)
                Chemostat.ExpRess.set_c!(expres, met, Chemostat.METS.get_c(met));
            end
        end

        flxs_ave = get_flxs_ave(epres, β);
        ξ = epres.ξ;
        Chemostat.ExpRess.add_ξ!(expres, ξ);
        μ = flxs_ave[find_ep_flx(epres, biomassid)];
        Chemostat.ExpRess.set_μ!(expres, ξ, μ);
        D = μ / ϕ;
        Chemostat.ExpRess.set_D!(expres, ξ, D);
        Chemostat.ExpRess.set_Xv!(expres, ξ, ξ * D);
        Chemostat.ExpRess.set_ϕ!(expres, ξ, NaN);
        Chemostat.ExpRess.set_GEM!(expres, gem);
        Chemostat.ExpRess.set_type!(expres, :ep);
        Chemostat.ExpRess.set_description!(expres, description);
        Chemostat.ExpRess.set_description!(expres, description);
        Chemostat.ExpRess.set_β!(expres, β);

        # mets
        for met in Chemostat.RES.get_mets_ids(expres)
            exchi = find_ep_exch(epres, met);

            # u
            u = 0.0;
            if exchi != 0.0 u = flxs_ave[exchi]; end
            Chemostat.ExpRess.set_u!(expres, ξ, met, u);

            #s
            c = Chemostat.ExpRess.get_c(expres, met);
            Chemostat.ExpRess.set_s!(expres, ξ, met, c - u * ξ);
        end

        for rxn in Chemostat.RES.get_rxns_ids(expres)
            r = flxs_ave[find_ep_flx(epres,rxn)];
            Chemostat.ExpRess.set_r!(expres, ξ, rxn, r)
        end

    end

    return expres;

end
