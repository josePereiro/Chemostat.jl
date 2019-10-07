# FBASolution -------------------------------------------------------------------------
struct FBASolution
    ξ::Float64  # X / D
    r::Vector{Float64} # internal reaction fluxes
    u::Vector{Float64} # uptakes (negative if secretion)
    s::Vector{Float64} # metabolite concentrations
    μ::Float64 # number of metabolites
    ϕ::Float64 # enzymatic mass fraction
end

function FBASolution(x::AbstractVector, S::AbstractMatrix, mets, rxns, ξ)
    m, n = size(S)
    @assert length(x) == 2n + m + 2
    r = x[1:n] .- x[n + (1:n)]
    u = x[2n + (1:m)];
    s = mets[:c] .- u * ξ
    μ = x[2n + m + 1]
    ϕ = x[2n + m + 2]
    FBASolution(ξ, r, u, s, μ, ϕ)
end

function ExpRes(fbasols::Vector{FBASolution}, gem::Chemostat.GEMs.GEM, description)

    @assert all(length(first(fbasols).s) .== length.([fbasols.s for fbasols in fbasols]))
    @assert length(first(fbasols).s) == size(gem.mets,1);
    @assert all(length(first(fbasols).r) .== length.([fbasols.r for fbasols in fbasols]))
    @assert length(first(fbasols).r) == size(gem.rxns,1);

    expres = Chemostat.ExpRess.ExpRes();
    # Chemostat.ExpRess.set_working_expres(expres);
    for fbasol in fbasols
        ξ = fbasol.ξ;
        Chemostat.ExpRess.add_ξ!(expres, ξ);
        Chemostat.ExpRess.set_μ!(expres, ξ, fbasol.μ);
        D = Chemostat.get_D(fbasol.μ);
        Chemostat.ExpRess.set_D!(expres, ξ, D);
        Chemostat.ExpRess.set_Xv!(expres, ξ, Chemostat.get_Xv(ξ, D));

        Chemostat.ExpRess.set_ϕ!(expres, ξ, fbasol.ϕ);

        for (i,met) in enumerate(gem.mets[:id])
            Chemostat.ExpRess.set_s!(expres, ξ, met, fbasol.s[i]);
            Chemostat.ExpRess.set_u!(expres, ξ, met, fbasol.u[i]);
        end

        for (i, rxn) in enumerate(gem.rxns[:id])
            Chemostat.ExpRess.set_r!(expres, ξ, rxn, fbasol.r[i]);
        end
    end

    for (i,met) in enumerate(gem.mets[:id])
        Chemostat.ExpRess.set_c!(expres, met, gem.mets[:c][i]);
    end

    Chemostat.ExpRess.set_GEM!(expres, gem);
    Chemostat.ExpRess.set_type!(expres, :fba);
    Chemostat.ExpRess.set_description!(expres, description);
    Chemostat.ExpRess.set_metids!(expres, gem.mets[:id]);
    Chemostat.ExpRess.set_rxnids!(expres, gem.rxns[:id]);

    return expres;
end

function ExpRes(fbasol::FBASolution,
    gem::Chemostat.GEMs.GEM, description)

    @assert length(fbasol.s) == size(gem.mets,1)
    @assert length(fbasol.r) == size(gem.rxns,1)

    expres = Chemostat.ExpRess.ExpRes();
    # Chemostat.ExpRess.set_working_expres(expres)
    ξ = fbasol.ξ;
    Chemostat.ExpRess.add_ξ!(expres, ξ);
    Chemostat.ExpRess.set_μ!(expres, ξ, fbasol.μ);
    D = Chemostat.get_D(fbasol.μ);
    Chemostat.ExpRess.set_D!(expres, ξ, D);
    Chemostat.ExpRess.set_Xv!(expres, ξ, Chemostat.get_Xv(ξ, D));
    Chemostat.ExpRess.set_ϕ!(expres, ξ, fbasol.ϕ);
    Chemostat.ExpRess.set_GEM!(expres, gem);
    Chemostat.ExpRess.set_type!(expres, :fba);
    Chemostat.ExpRess.set_description!(expres, description);
    Chemostat.ExpRess.set_metids!(expres, gem.mets[:id]);
    Chemostat.ExpRess.set_rxnids!(expres, gem.rxns[:id]);

    for (i,met) in enumerate(gem.mets[:id])
        Chemostat.ExpRess.set_s!(expres, ξ, met, fbasol.s[i]);
        Chemostat.ExpRess.set_u!(expres, ξ, met, fbasol.u[i]);
        Chemostat.ExpRess.set_c!(expres, met, gem.mets[:c][i]);
    end

    for (i, rxn) in enumerate(gem.rxns[:id])
        Chemostat.ExpRess.set_r!(expres, ξ, rxn, fbasol.r[i]);
    end

    return expres;
end
