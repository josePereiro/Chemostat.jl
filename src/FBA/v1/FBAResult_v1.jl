export FBAResult_v1;
struct FBAResult_v1
    ξ::Float64
    model::JuMP.Model
    pfluxes::Vector{JuMP.Variable}
    nfluxes::Vector{JuMP.Variable}
    obj::JuMP.Variable
    ϕ::JuMP.Variable
    # main_dem::JuMP.Variable
    S::SparseMatrixCSC
    rxns::DataFrame
    mets::DataFrame

    function FBAResult_v1(ξ, model, pfluxes, nfluxes, obj, ϕ, S, rxns, mets)
        @assert ξ > 0;
        @assert allunique([rxns[:id];mets[:id]])
        return new(ξ, model, pfluxes, nfluxes, obj, ϕ, S, rxns, mets);
    end

end

function Base.convert(::Type{DataFrames.DataFrame}, vars::Array{JuMP.Variable,1})::DataFrame
    df = DataFrames.DataFrame();
    df[:id] = string.(vars);
    df[:v] = Float64.(getvalue.(vars))
    return df;
end
function Base.convert(::Type{DataFrames.DataFrame}, fbares::FBAResult_v1)::DataFrame
    df = DataFrames.DataFrame();
    df[:id] = [string.(fbares.pfluxes) ; string.(fbares.nfluxes)]
    df[:v] = [Float64.(getvalue.(fbares.pfluxes)) ; Float64.(getvalue.(fbares.nfluxes))];
    return df;
end

export objv,mainv,costv,pfluxesdf,nfluxesdf,xi,indexof,flux;

objv(fbares::FBAResult_v1) = JuMP.getvalue(fbares.obj);
costv(fbares::FBAResult_v1) = JuMP.getvalue(fbares.ϕ);
pfluxesdf(fbares::FBAResult_v1) = convert(fbares.pfluxes);
nfluxesdf(fbares::FBAResult_v1) = convert(fbares.nfluxes);
xi(fbares::FBAResult_v1) = fbares.ξ;

function indexof(fbares::FBAResult_v1, id)

    rxnindx = Tools.indexof(fbares.rxns, id);
    rxnindx != -1 && return rxnindx;
    metindx = Tools.indexof(fbares.mets, id);
    metindx != -1 && return metindx;
    return -1;
end
function flux(fbares::FBAResult_v1, fluxidx::Int)
    return getvalue(fbares.pfluxes[fluxidx]) - getvalue(fbares.nfluxes[fluxidx]);
end
flux(fbares::FBAResult_v1, id::String) = flux(fbares, indexof(fbares, id));
