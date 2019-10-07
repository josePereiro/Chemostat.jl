module GEMs

using DataFrames;

export GEM;
"""
    Just a wrapper of the network data, that represents the Genome-scale mEtabolic Model!!!
    This link the data to a format!!!
"""
struct GEM
    S # The Stoichimetric matrix
    mets # Information linked to the metabolites of the net
    rxns # Information linked to the reactions of the net
    function GEM(S::AbstractMatrix, mets::DataFrame, rxns::DataFrame)
        check_format(S, mets, rxns);
        check_data_quality(S, mets, rxns);
        new(S,mets,rxns);
    end
end

Base.size(gem::GEM) = Base.size(gem.S);
Base.size(gem::GEM, i::Int) = Base.size(gem.S, i);

gem_format = Dict("mets_keys"  => [:id, :V, :L, :e, :y, :c],
                  "mets_types" => Dict(:id =>  String, :V => Float64,
                                       :L  => Float64, :e => Float64,
                                       :y  => Float64, :c => Float64),

                  "rxns_keys"  => [:id, :pub, :plb, :nub, :nlb, :ap, :an],
                  "rxns_types" => Dict(:id  =>  String, :pub => Float64,
                                       :plb => Float64, :nub => Float64,
                                       :nlb => Float64, :ap  => Float64,
                                       :an  => Float64));

"""
    Check the format of the given data. Throw an error if something is not right.
"""
function check_format(S, mets, rxns)
    #Mets
    # keys and types
    for k in gem_format["mets_keys"]
        if !haskey(mets,k)
            error(":$(string(k)) key is missing in mets!!!")
        end
        if eltype(mets[k]) != gem_format["mets_types"][k]
            error("mets :$(string(k)) must be of type $(gem_format["mets_types"][k])"*
                " got $(eltype(mets[k]))")
        end
    end

    # Size
    if size(mets,1) != size(S,1) error("Dimention dimensionMismatch, " *
            "metabolites number in mets and S row count are differents!!!"); end

    # Rxns
    #Mets
    # keys and types
    for k in gem_format["rxns_keys"]
        if !haskey(rxns,k)
            error(":$(string(k)) key is missing in rxns!!!")
        end
        if eltype(rxns[k]) != gem_format["rxns_types"][k]
            error("rxns :$(string(k)) must be of type $(gem_format["rxns_types"][k])"*
                " got $(eltype(rxns[k]))")
        end
    end

    # Size
    if size(rxns,1) != size(S,2) error("Dimention dimensionMismatch, " *
            "reaction number in rxns and S column count are differents!!!"); end

end
check_format(gem) = check_format(gem.S, gem.mets, gem.rxns);

function check_data_quality(S, mets, rxns)
    #S
    if isempty(S) error("S is empty!!") end;
    if !all(typeof.(S) .== Float64) error("S must contain Float64 elements.") end;
    if all(S .== 0.0) error("All elements in S are zeros.") end;
    m, n =size(S);
    if m > n error("Error m = $m > n = $n, the system can't be determined!!!") end

    #Mets
    # Data quality
    if !allunique(mets[:id]) error("mets contains repeated ids!!!"); end

    for (i, met) in enumerate(mets[:id])
        V, L, e, y, c = mets[:V][i], mets[:L][i], mets[:e][i],
            mets[:y][i], mets[:c][i];

        #Bounds
        if !isfinite(V) error("met[$(i)] $(met) :V = $(V) must be finite!!!"); end
        if !isfinite(L) error("met[$(i)] $(met) :L = $(L) must be finite!!!"); end
        if L > V error("met[$(i)] $(met) :V = $(V) must be"*
                " greater or equal to :L = $(L)!!!") end
        if !isfinite(e) error("met[$(i)] $(met) :e = $(e) must be finite!!!"); end
        if !isfinite(y) error("met[$(i)] $(met) :y = $(y) must be finite!!!"); end
        if c < 0.0 error("met[$(i)] $(met) :c = $(c) must be positive!!!") end
        if !isfinite(c) error("met[$(i)] $(met) :c = $(c) must be finite!!!"); end

    end

    #Rxns
    # Data quality
    if !allunique(rxns[:id]) error("rxns contains repeated ids!!!"); end

    for (i, rxn) in enumerate(rxns[:id])
        pub, plb, nub, nlb, an, ap = rxns[:pub][i],rxns[:plb][i],
            rxns[:nub][i], rxns[:nlb][i],rxns[:an][i], rxns[:ap][i];

        #Bounds
        if pub < 0.0 error("rxn[$(i)] $(rxn) :pub = $(pub) must be positive!!!"); end
        if !isfinite(pub) error("rxn $(i): $(rxn) :pub = $(pub) must be finite!!!"); end

        if plb < 0.0 error("rxn[$(i)] $(rxn) :plb = $(plb) must be positive!!!"); end
        if !isfinite(plb) error("rxn $(i)- $(rxn) :plb = $(plb) must be finite!!!"); end

        if plb > pub error("rxn[$(i)] $(rxn) :pub = $(pub) must be more"*
                " positive or equal than :plb = $(plb)!!!") end

        if nub > 0.0 error("rxn[$(i)] $(rxn) :nub = $(nub) must be negative!!!"); end
        if !isfinite(nub) error("rxn $(i): $(rxn) :nub = $(nub) must be finite!!!"); end

        if nlb > 0.0 error("rxn[$(i)] $(rxn) :nlb = $(nlb) must be negative!!!"); end
        if !isfinite(nlb) error("rxn $(i)- $(rxn) :nlb = $(nlb) must be finite!!!"); end

        if nlb < nub error("rxn[$(i)] $(rxn) :nub = $(nub) must be more"*
                " positive or equal than :nlb = $(nlb)!!!") end

        if plb != 0.0 && nlb != 0.0 error("rxn[$(i)] $(rxn) have incompatible bounds!!!"*
                " if plb != 0.0, plb = $(plb), nlb must be set to 0.0, nlb = $(nlb), to correctly"*
                " fix the reaction!!!") end

        if nlb != 0.0 && plb != 0.0 error("rxn[$(i)] $(rxn) have incompatible bounds!!!"*
                " if nlb = $(nlb) plb must be set to 0.0, plb = $(plb), to correctly"*
                " fix the reaction!!!") end

        #Costs
        if ap < 0.0 error("rxn[$(i)] $(rxn) :ap = $(ap) must be positive!!!"); end
        if !isfinite(ap) error("rxn $(i): $(rxn) :ap = $(ap) must be finite!!!"); end

        if an < 0.0 error("rxn[$(i)] $(rxn) :an = $(an) must be positive!!!"); end
        if !isfinite(an) error("rxn $(i): $(rxn) :an = $(an) must be finite!!!"); end

    end

    if !allunique([rxns[:id]; mets[:id]])
        error("mets and rxns must have differents ids!!!"); end
end
check_data_quality(gem) = check_data_quality(gem.S, gem.mets, gem.rxns);


end  # module GEMs
