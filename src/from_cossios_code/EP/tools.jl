# Tools
find_ep_flx(epres, flx::String) = findfirst(epres.rxnsid, flx);
find_ep_exch(epres, met::String) = find_ep_flx(epres, exch_prefix * met);
find_ep_met(epres, metid::String) = findfirst(epres.metsid, metid);

has_exch(epres, metid::String) = find_exch(epres, metid) != 0;

is_inner_rxn(rxn::String) = rxn != enz_mass_react && rxn != biomassid && !startswith(rxn, exch_prefix);
is_exch_rxn(rxn::String) = rxn != enz_mass_react && rxn != biomassid && startswith(rxn, exch_prefix);
is_met(met) = met != enz_mass_met;

get_inner_rxnid(rxnid) = replace(rxnid, rev_sufix => "");

function get_flxs_ave(epres, β)
    bioidx = find_ep_flx(epres, biomassid);
    α = spzeros(size(epres.Σ, 1));
    α[bioidx] = β;
    w = epres.v + epres.Σ * α
    Σnn = epres.d .* diag(epres.Σ) ./ (epres.d .- diag(epres.Σ));
    wn = (epres.d .* w - diag(epres.Σ) .* epres.a) ./ (epres.d .- diag(epres.Σ));
    fave = tnmean.(epres.lb, epres.ub, wn, Σnn);
end

function get_flxs_ave(epres, β, flx)
    return get_flxs_ave(epres, β)[find_ep_flx(epres, flx)];
end

get_expres(epress::Dict, β; description = "") = ExpRes(epress, β, description);
