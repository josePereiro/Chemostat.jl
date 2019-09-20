module ExpRess

using Chemostat;

const exp_fields = ["cs","ξs","GEM", "description", "units",
        "type", "extras", "metids", "rxnids", "β"];
const ξ_felds = ["rs","us","ss","μ","ϕ","Xv","D"];
const support_types = [:unknown, :fba, :exp, :ep];

struct ExpRes # Experiment result
    data::Dict;
    function ExpRes()
        return new(Dict{Any,Any}("ξs" => Vector{Float64}(), "β" => NaN,
        "GEM" => nothing, "description" => "Exp created at $(now())", "cs" => Dict(),
        "type" => :unknown, "extras" => nothing, "units" => Dict(),
        "metids" => Vector{Float64}(), "rxnids" => Vector{Float64}()));
    end
end

_expres_ = nothing;
set_working_expres(exp::ExpRes) = global _expres_ = exp;
clean_working_expres() = global _expres_ = nothing;
get_expres() = if _expres_ == nothing error("You must set the working expres first!!!")
else _expres_ end;

# Setters

add_key!(dict::Dict, k, kdata; kname = "") = haskey(dict, k) ?
            error("$(kname) $(k) already exist, you can't added!!!") : dict[k] = kdata;

function add_ξ!(exp::ExpRes, ξ::Float64)
    ξdata = Dict("rs" => Dict(), "us" => Dict(), "ss" => Dict(),
            "μ" => NaN, "Xv" => NaN, "ϕ" => NaN, "D" => NaN);
    data = exp.data;
    add_key!(data, ξ, ξdata, kname = "ξ");
    push!(data["ξs"], ξ);
    sort!(data["ξs"]);
end
add_ξ!(ξ::Float64) = add_ξ!(get_expres(), ξ);

set_s!(exp::ExpRes, ξ::Float64, met::String, sval::Float64) = exp.data[ξ]["ss"][met] = sval;
set_s!(ξ::Float64, met::String, sval::Float64) = set_s!(get_expres(),ξ,met,sval);

set_r!(exp::ExpRes, ξ::Float64, met::String, rval::Float64) = exp.data[ξ]["rs"][met] = rval;
set_r!(ξ::Float64, met::String, sval::Float64) = set_r!(get_expres(),ξ,met,sval);

set_u!(exp::ExpRes, ξ::Float64, met::String, uval::Float64) = exp.data[ξ]["us"][met] = uval;
set_u!(ξ::Float64, met::String, sval::Float64) = set_u!(get_expres(),ξ,met,sval);

set_c!(exp::ExpRes, met::String, cval::Float64) = exp.data["cs"][met] = cval;
set_c!(met::String, cval::Float64) = set_c!(get_expres(), met, cval);

set_μ!(exp::ExpRes, ξ::Float64, μ::Float64) = exp.data[ξ]["μ"] = μ;
set_μ!(ξ::Float64, μ::Float64) = set_μ!(get_expres(), ξ, μ);

set_Xv!(exp::ExpRes, ξ::Float64, Xv::Float64) = exp.data[ξ]["Xv"] = Xv;
set_Xv!(ξ::Float64, Xv::Float64) = set_Xv!(get_expres(), ξ, Xv);

set_D!(exp::ExpRes, ξ::Float64, D::Float64) = exp.data[ξ]["D"] = D;
set_D!(ξ::Float64, D::Float64) = set_D!(get_expres(), ξ, D);

set_ϕ!(exp::ExpRes, ξ::Float64, ϕ::Float64) = exp.data[ξ]["ϕ"] = ϕ;
set_ϕ!(ξ::Float64, ϕ::Float64) = set_ϕ!(get_expres(), ξ, ϕ);

set_GEM!(exp::ExpRes, gem) = exp.data["GEM"] = gem;
set_GEM!(gem) = set_GEM!(get_expres(), gem);

set_β!(exp::ExpRes, β::Float64) = exp.data["β"] = β;
set_β!(β::Float64) = set_β!(get_expres(), β);

set_metids!(exp::ExpRes, metids::Vector{String}) = exp.data["metids"] = metids;
set_metids!(metids::Vector{String}) = set_metids!(get_expres(), metids);

set_rxnids!(exp::ExpRes, metids::Vector{String}) = exp.data["rxnids"] = metids;
set_rxnids!(metids::Vector{String}) = set_rxnids!(get_expres(), metids);

set_description!(exp::ExpRes, descp::String) = exp.data["description"] = descp;
set_description!(descp::String) = set_description!(get_expres(), descp);

set_type!(exp::ExpRes, t::Symbol) = exp.data["type"] = t;
set_type!(t::Symbol) = set_type!(get_expres(), t);

set_extra!(exp::ExpRes, extras) = exp.data["extras"] = extras;
set_extra!(extras) = set_extra!(get_expres(), extras);

# Getters

# cs

get_c(exp::ExpRes, met::String) = exp.data["cs"][met];
get_c(met::String) = get_c(get_expres(), met);

get_cs(exp::ExpRes, mets::Vector{String}) = [get_c(exp, met) for met in mets];
get_cs(mets::Vector{String}) = get_cs(get_expres(), mets);

get_cs(exp::ExpRes) = get_cs(exp, get_mets_ids());
get_cs() = get_cs(get_expres());


# ss
get_s(exp::ExpRes, ξ::Float64, met::String) = exp.data[ξ]["ss"][met];
get_s(exp::ExpRes, ξi::Int, met::String) = get_s(exp, get_ξ(exp, ξi), met);
get_s(ξ, met::String) = get_s(get_expres(), ξ, met);

get_ss(exp::ExpRes, ξs::Vector, met::String) = [get_s(exp, ξ, met) for ξ in ξs]
get_ss(ξs::Vector, met::String) = get_ss(get_expres(), ξs, met);

get_ss(exp::ExpRes, met::String) = get_ss(exp, get_ξs(exp), met);
get_ss(met::String) = get_ss(get_expres(), met);

get_ss(exp::ExpRes, ξ, mets::Vector{String}) = [get_s(exp, ξ, met) for met in mets];
get_ss(ξ, mets::Vector{String}) = get_ss(get_expres(), ξ, mets);

get_ss(exp::ExpRes, ξs::Vector, mets::Vector{String}) =
    vcat([get_ss(exp, ξ, mets) for ξ in ξs]...);
get_ss(ξs::Vector, mets::Vector{String}) = get_ss(get_expres(), ξs, mets);

get_ss(exp::ExpRes) = get_ss(exp, get_ξs(exp), get_mets_ids());
get_ss() = get_ss(get_expres());

get_ss(exp::ExpRes, ξ) = [get_s(exp, ξ, met) for met in get_mets_ids()];
get_ss(ξ) = get_ss(get_expres(), ξ);

# us

get_u(exp::ExpRes, ξ::Float64, met::String) = exp.data[ξ]["us"][met];
get_u(exp::ExpRes, ξi::Int, met::String) = get_u(exp, get_ξ(exp, ξi), met);
get_u(ξ, met::String) = get_u(get_expres(), ξ, met);

get_us(exp::ExpRes, ξs::Vector, met::String) = [get_u(exp, ξ, met) for ξ in ξs]
get_us(ξs::Vector, met::String) = get_us(get_expres(), ξs, met);

get_us(exp::ExpRes, met::String) = get_us(exp, get_ξs(exp), met);
get_us(met::String) = get_us(get_expres(), met);

get_us(exp::ExpRes, ξ, mets::Vector{String}) = [get_u(exp, ξ, met) for met in mets];
get_us(ξ, mets::Vector{String}) = get_us(get_expres(), ξ, mets);

get_us(exp::ExpRes, ξs::Vector, mets::Vector{String}) =
    vcat([get_us(exp, ξ, mets) for ξ in ξs]...);
get_us(ξs::Vector, mets::Vector{String}) = get_us(get_expres(), ξs, mets);

get_us(exp::ExpRes) = get_us(exp, get_ξs(exp), get_mets_ids());
get_us() = get_us(get_expres());

get_us(exp::ExpRes, ξ) = [get_u(exp, ξ, met) for met in get_mets_ids()];
get_us(ξ) = get_us(get_expres(), ξ);

# rs

get_r(exp::ExpRes, ξ::Float64, rxn::String) = exp.data[ξ]["rs"][rxn];
get_r(exp::ExpRes, ξi::Int, rxn::String) = get_r(exp, get_ξ(exp, ξi), rxn);
get_r(ξ, rxn::String) = get_r(get_expres(), ξ, rxn);

get_rs(exp::ExpRes, ξs::Vector, rxn::String) = [get_r(exp, ξ, rxn) for ξ in ξs]
get_rs(ξs::Vector, rxn::String) = get_rs(get_expres(), ξs, rxn);

get_rs(exp::ExpRes, rxn::String) = get_rs(exp, get_ξs(exp), rxn);
get_rs(rxn::String) = get_rs(get_expres(), rxn);

get_rs(exp::ExpRes, ξ, rxns::Vector{String}) = [get_r(exp, ξ, rxn) for rxn in rxns];
get_rs(ξ, rxns::Vector{String}) = get_rs(get_expres(), ξ, rxns);

get_rs(exp::ExpRes, ξs::Vector, rxns::Vector{String}) =
    vcat([get_rs(exp, ξ, rxns) for ξ in ξs]...);
get_rs(ξs::Vector, rxns::Vector{String}) = get_rs(get_expres(), ξs, rxns);

get_rs(exp::ExpRes) = get_rs(exp, get_ξs(exp), get_rxns_ids());
get_rs() = get_rs(get_expres());

get_rs(exp::ExpRes, ξ) = [get_r(exp, ξ, rxn) for rxn in get_rxns_ids()];
get_rs(ξ) = get_rs(get_expres(), ξ);

# μ

get_μ(exp::ExpRes, ξ::Float64) = exp.data[ξ]["μ"];
get_μ(exp::ExpRes, ξi::Int) = get_μ(exp, get_ξ(exp, ξi));
get_μ(ξ) = get_μ(get_expres(), ξ);

get_μs(exp::ExpRes, ξs::Vector) = [get_μ(exp, ξ) for ξ in ξs];
get_μs(ξs::Vector) = get_μs(get_expres(), ξs);

get_μs(exp::ExpRes) = get_μs(exp, get_ξs(exp));
get_μs() = get_μs(get_expres());

# Xv

get_Xv(exp::ExpRes, ξ::Float64) = exp.data[ξ]["Xv"];
get_Xv(exp::ExpRes, ξi::Int) = get_Xv(exp, get_ξ(exp, ξi));
get_Xv(ξ) = get_Xv(get_expres(), ξ);

get_Xvs(exp::ExpRes, ξs::Vector) = [get_Xv(exp, ξ) for ξ in ξs];
get_Xvs(ξs::Vector) = get_Xvs(get_expres(), ξs);

get_Xvs(exp::ExpRes) = get_Xvs(exp, get_ξs(exp));
get_Xvs() = get_Xvs(get_expres());

# D

get_D(exp::ExpRes, ξ::Float64) = exp.data[ξ]["D"];
get_D(exp::ExpRes, ξi::Int) = get_D(exp, get_ξ(exp, ξi));
get_D(ξ) = get_D(get_expres(), ξ);

get_Ds(exp::ExpRes, ξs::Vector) = [get_D(exp, ξ) for ξ in ξs];
get_Ds(ξs::Vector) = get_Ds(get_expres(), ξs);

get_Ds(exp::ExpRes) = get_Ds(exp, get_ξs(exp));
get_Ds() = get_Ds(get_expres());

# ϕ

get_ϕ(exp::ExpRes, ξ::Float64) = exp.data[ξ]["ϕ"];
get_ϕ(exp::ExpRes, ξi::Int) = get_ϕ(exp, get_ξ(exp, ξi));
get_ϕ(ξ) = get_ϕ(get_expres(), ξ);

get_ϕs(exp::ExpRes, ξs::Vector) = [get_ϕ(exp, ξ) for ξ in ξs];
get_ϕs(ξs::Vector) = get_ϕs(get_expres(), ξs);

get_ϕs(exp::ExpRes) = get_ϕs(exp, get_ξs(exp));
get_ϕs() = get_ϕs(get_expres());

# GEM

get_GEM(exp::ExpRes) = exp.data["GEM"];
get_GEM() = get_GEM(get_expres());

# β

get_β(exp::ExpRes) = exp.data["β"];
get_β() = get_β(get_expres());

# Mets

get_mets_ids(exp::ExpRes) = exp.data["metids"];
get_mets_ids() = get_mets_ids(get_expres());

# Rxns

get_rxns_ids(exp::ExpRes) = exp.data["rxnids"];
get_rxns_ids() = get_rxns_ids(get_expres());

# ξs

get_ξ(exp::ExpRes, i::Int) = get_ξs(exp)[i];
get_ξ(i::Int) = get_ξ(get_expres(),i);

get_ξs(exp::ExpRes, i) = get_ξs(exp)[i];
get_ξs(i) = get_ξs(get_expres())[i];

get_ξs(exp::ExpRes) =  exp.data["ξs"];
get_ξs() =  get_ξs(get_expres());

# Description

get_description(exp::ExpRes) = exp.data["description"];
get_description() = get_description(get_expres());

# Type

get_type(exp::ExpRes) = exp.data["type"];
get_type() = get_type(get_expres());





end
