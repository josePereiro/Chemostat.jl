const exp_fields = ["cs","ξs","GEM", "description", "units",
        "type", "extras", "metids", "rxnids", "β"];
const ξ_felds = ["rs","us","ss","μ","ϕ","Xv","D"];

struct ExpRes # Experiment result
    data::Dict;
    function ExpRes()
        return new(Dict{Any,Any}("ξs" => Vector{Float64}(), "β" => NaN,
        "GEM" => nothing, "description" => "Exp created at $(now())", "cs" => Dict(),
        "type" => :unknown, "extras" => nothing, "units" => Dict(),
        "metids" => Vector{Float64}(), "rxnids" => Vector{Float64}()));
    end
end
