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
add_ξ!(ξ::Float64) = add_ξ!(get_working_expres(), ξ);

set_s!(exp::ExpRes, ξ::Float64, met::String, sval::Float64) = exp.data[ξ]["ss"][met] = sval;
set_s!(ξ::Float64, met::String, sval::Float64) = set_s!(get_working_expres(),ξ,met,sval);

set_r!(exp::ExpRes, ξ::Float64, met::String, rval::Float64) = exp.data[ξ]["rs"][met] = rval;
set_r!(ξ::Float64, met::String, sval::Float64) = set_r!(get_working_expres(),ξ,met,sval);

set_u!(exp::ExpRes, ξ::Float64, met::String, uval::Float64) = exp.data[ξ]["us"][met] = uval;
set_u!(ξ::Float64, met::String, sval::Float64) = set_u!(get_working_expres(),ξ,met,sval);

set_c!(exp::ExpRes, met::String, cval::Float64) = exp.data["cs"][met] = cval;
set_c!(met::String, cval::Float64) = set_c!(get_working_expres(), met, cval);

set_μ!(exp::ExpRes, ξ::Float64, μ::Float64) = exp.data[ξ]["μ"] = μ;
set_μ!(ξ::Float64, μ::Float64) = set_μ!(get_working_expres(), ξ, μ);

set_Xv!(exp::ExpRes, ξ::Float64, Xv::Float64) = exp.data[ξ]["Xv"] = Xv;
set_Xv!(ξ::Float64, Xv::Float64) = set_Xv!(get_working_expres(), ξ, Xv);

set_D!(exp::ExpRes, ξ::Float64, D::Float64) = exp.data[ξ]["D"] = D;
set_D!(ξ::Float64, D::Float64) = set_D!(get_working_expres(), ξ, D);

set_ϕ!(exp::ExpRes, ξ::Float64, ϕ::Float64) = exp.data[ξ]["ϕ"] = ϕ;
set_ϕ!(ξ::Float64, ϕ::Float64) = set_ϕ!(get_working_expres(), ξ, ϕ);

set_GEM!(exp::ExpRes, gem) = exp.data["GEM"] = gem;
set_GEM!(gem) = set_GEM!(get_working_expres(), gem);

set_β!(exp::ExpRes, β::Float64) = exp.data["β"] = β;
set_β!(β::Float64) = set_β!(get_working_expres(), β);

set_metids!(exp::ExpRes, metids::Vector{String}) = exp.data["metids"] = metids;
set_metids!(metids::Vector{String}) = set_metids!(get_working_expres(), metids);

set_rxnids!(exp::ExpRes, metids::Vector{String}) = exp.data["rxnids"] = metids;
set_rxnids!(metids::Vector{String}) = set_rxnids!(get_working_expres(), metids);

set_description!(exp::ExpRes, descp::String) = exp.data["description"] = descp;
set_description!(descp::String) = set_description!(get_working_expres(), descp);

set_type!(exp::ExpRes, t::Symbol) = exp.data["type"] = t;
set_type!(t::Symbol) = set_type!(get_working_expres(), t);

set_extra!(exp::ExpRes, extras) = exp.data["extras"] = extras;
set_extra!(extras) = set_extra!(get_working_expres(), extras);
