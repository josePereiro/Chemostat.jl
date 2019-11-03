# cs
get_c(exp::ExpRes, met::String) = exp.data["cs"][met];
get_c(met::String) = get_c(get_working_expres(), met);

get_cs(exp::ExpRes, mets::Vector{String}) = [get_c(exp, met) for met in mets];
get_cs(mets::Vector{String}) = get_cs(get_working_expres(), mets);

get_cs(exp::ExpRes) = get_cs(exp, get_mets_ids());
get_cs() = get_cs(get_working_expres());


# ss
get_s(exp::ExpRes, ξ::Float64, met::String) = exp.data[ξ]["ss"][met];
get_s(exp::ExpRes, ξi::Int, met::String) = get_s(exp, get_ξ(exp, ξi), met);
get_s(ξ, met::String) = get_s(get_working_expres(), ξ, met);

get_ss(exp::ExpRes, ξs::Vector, met::String) = [get_s(exp, ξ, met) for ξ in ξs]
get_ss(ξs::Vector, met::String) = get_ss(get_working_expres(), ξs, met);

get_ss(exp::ExpRes, met::String) = get_ss(exp, get_ξs(exp), met);
get_ss(met::String) = get_ss(get_working_expres(), met);

get_ss(exp::ExpRes, ξ, mets::Vector{String}) = [get_s(exp, ξ, met) for met in mets];
get_ss(ξ, mets::Vector{String}) = get_ss(get_working_expres(), ξ, mets);

get_ss(exp::ExpRes, ξs::Vector, mets::Vector{String}) =
    vcat([get_ss(exp, ξ, mets) for ξ in ξs]...);
get_ss(ξs::Vector, mets::Vector{String}) = get_ss(get_working_expres(), ξs, mets);

get_ss(exp::ExpRes) = get_ss(exp, get_ξs(exp), get_mets_ids());
get_ss() = get_ss(get_working_expres());

get_ss(exp::ExpRes, ξ) = [get_s(exp, ξ, met) for met in get_mets_ids()];
get_ss(ξ) = get_ss(get_working_expres(), ξ);

# us

get_u(exp::ExpRes, ξ::Float64, met::String) = exp.data[ξ]["us"][met];
get_u(exp::ExpRes, ξi::Int, met::String) = get_u(exp, get_ξ(exp, ξi), met);
get_u(ξ, met::String) = get_u(get_working_expres(), ξ, met);

get_us(exp::ExpRes, ξs::Vector, met::String) = [get_u(exp, ξ, met) for ξ in ξs]
get_us(ξs::Vector, met::String) = get_us(get_working_expres(), ξs, met);

get_us(exp::ExpRes, met::String) = get_us(exp, get_ξs(exp), met);
get_us(met::String) = get_us(get_working_expres(), met);

get_us(exp::ExpRes, ξ, mets::Vector{String}) = [get_u(exp, ξ, met) for met in mets];
get_us(ξ, mets::Vector{String}) = get_us(get_working_expres(), ξ, mets);

get_us(exp::ExpRes, ξs::Vector, mets::Vector{String}) =
    vcat([get_us(exp, ξ, mets) for ξ in ξs]...);
get_us(ξs::Vector, mets::Vector{String}) = get_us(get_working_expres(), ξs, mets);

get_us(exp::ExpRes) = get_us(exp, get_ξs(exp), get_mets_ids());
get_us() = get_us(get_working_expres());

get_us(exp::ExpRes, ξ) = [get_u(exp, ξ, met) for met in get_mets_ids()];
get_us(ξ) = get_us(get_working_expres(), ξ);

# rs

get_r(exp::ExpRes, ξ::Float64, rxn::String) = exp.data[ξ]["rs"][rxn];
get_r(exp::ExpRes, ξi::Int, rxn::String) = get_r(exp, get_ξ(exp, ξi), rxn);
get_r(ξ, rxn::String) = get_r(get_working_expres(), ξ, rxn);

get_rs(exp::ExpRes, ξs::Vector, rxn::String) = [get_r(exp, ξ, rxn) for ξ in ξs]
get_rs(ξs::Vector, rxn::String) = get_rs(get_working_expres(), ξs, rxn);

get_rs(exp::ExpRes, rxn::String) = get_rs(exp, get_ξs(exp), rxn);
get_rs(rxn::String) = get_rs(get_working_expres(), rxn);

get_rs(exp::ExpRes, ξ, rxns::Vector{String}) = [get_r(exp, ξ, rxn) for rxn in rxns];
get_rs(ξ, rxns::Vector{String}) = get_rs(get_working_expres(), ξ, rxns);

get_rs(exp::ExpRes, ξs::Vector, rxns::Vector{String}) =
    vcat([get_rs(exp, ξ, rxns) for ξ in ξs]...);
get_rs(ξs::Vector, rxns::Vector{String}) = get_rs(get_working_expres(), ξs, rxns);

get_rs(exp::ExpRes) = get_rs(exp, get_ξs(exp), get_rxns_ids());
get_rs() = get_rs(get_working_expres());

get_rs(exp::ExpRes, ξ) = [get_r(exp, ξ, rxn) for rxn in get_rxns_ids()];
get_rs(ξ) = get_rs(get_working_expres(), ξ);

# μ

get_μ(exp::ExpRes, ξ::Float64) = exp.data[ξ]["μ"];
get_μ(exp::ExpRes, ξi::Int) = get_μ(exp, get_ξ(exp, ξi));
get_μ(ξ) = get_μ(get_working_expres(), ξ);

get_μs(exp::ExpRes, ξs::Vector) = [get_μ(exp, ξ) for ξ in ξs];
get_μs(ξs::Vector) = get_μs(get_working_expres(), ξs);

get_μs(exp::ExpRes) = get_μs(exp, get_ξs(exp));
get_μs() = get_μs(get_working_expres());

# Xv

get_Xv(exp::ExpRes, ξ::Float64) = exp.data[ξ]["Xv"];
get_Xv(exp::ExpRes, ξi::Int) = get_Xv(exp, get_ξ(exp, ξi));
get_Xv(ξ) = get_Xv(get_working_expres(), ξ);

get_Xvs(exp::ExpRes, ξs::Vector) = [get_Xv(exp, ξ) for ξ in ξs];
get_Xvs(ξs::Vector) = get_Xvs(get_working_expres(), ξs);

get_Xvs(exp::ExpRes) = get_Xvs(exp, get_ξs(exp));
get_Xvs() = get_Xvs(get_working_expres());

# D

get_D(exp::ExpRes, ξ::Float64) = exp.data[ξ]["D"];
get_D(exp::ExpRes, ξi::Int) = get_D(exp, get_ξ(exp, ξi));
get_D(ξ) = get_D(get_working_expres(), ξ);

get_Ds(exp::ExpRes, ξs::Vector) = [get_D(exp, ξ) for ξ in ξs];
get_Ds(ξs::Vector) = get_Ds(get_working_expres(), ξs);

get_Ds(exp::ExpRes) = get_Ds(exp, get_ξs(exp));
get_Ds() = get_Ds(get_working_expres());

# ϕ

get_ϕ(exp::ExpRes, ξ::Float64) = exp.data[ξ]["ϕ"];
get_ϕ(exp::ExpRes, ξi::Int) = get_ϕ(exp, get_ξ(exp, ξi));
get_ϕ(ξ) = get_ϕ(get_working_expres(), ξ);

get_ϕs(exp::ExpRes, ξs::Vector) = [get_ϕ(exp, ξ) for ξ in ξs];
get_ϕs(ξs::Vector) = get_ϕs(get_working_expres(), ξs);

get_ϕs(exp::ExpRes) = get_ϕs(exp, get_ξs(exp));
get_ϕs() = get_ϕs(get_working_expres());

# GEM

get_GEM(exp::ExpRes) = exp.data["GEM"];
get_GEM() = get_GEM(get_working_expres());

# β

get_β(exp::ExpRes) = exp.data["β"];
get_β() = get_β(get_working_expres());

# Mets

get_mets_ids(exp::ExpRes) = exp.data["metids"];
get_mets_ids() = get_mets_ids(get_working_expres());

# Rxns

get_rxns_ids(exp::ExpRes) = exp.data["rxnids"];
get_rxns_ids() = get_rxns_ids(get_working_expres());

# ξs

get_ξ(exp::ExpRes, i::Int) = get_ξs(exp)[i];
get_ξ(i::Int) = get_ξ(get_working_expres(),i);

get_ξs(exp::ExpRes, i) = get_ξs(exp)[i];
get_ξs(i) = get_ξs(get_working_expres())[i];

get_ξs(exp::ExpRes) =  exp.data["ξs"];
get_ξs() =  get_ξs(get_working_expres());

# Description

get_description(exp::ExpRes) = exp.data["description"];
get_description() = get_description(get_working_expres());

# Type

get_type(exp::ExpRes) = exp.data["type"];
get_type() = get_type(get_working_expres());
