module Store

using Chemostat.GEMs;
using Chemostat.GEMTools.Commons;

working_gem = nothing;
working_mets = nothing;
working_rxns = nothing;
working_S = nothing;
function set_working_gem(gem::GEM)
    global working_gem = gem;
    global working_mets = working_gem.mets;
    global working_rxns = working_gem.rxns;
    global working_S = working_gem.S;
end

function clear_working_gem()
    global working_gem = nothing;
    global working_mets = nothing;
    global working_rxns = nothing;
    global working_S = nothing;
end


set_working_mets(mets) = begin
    warn("This method set the working mets data without checking its " *
            "format or data quality!!! Use with precaution!!!")
    global working_mets = mets;
end

clear_working_mets() = global working_mets = nothing;

set_working_rxns(rxns) = begin
    warn("This method set the working rxns data without checking its " *
            "format or data quality!!! Use with precaution!!!")
    global working_rxns = rxns;
end

clear_working_rxns() = global working_rxns = nothing;

force_S(S) = begin
    warn("This method set the working S data without checking its " *
            "format!!! Use with precaution!!!")
    global working_S = S;
end

clean_S() = global working_S = nothing;

get_working_gem() = working_gem == nothing ? error("You must first set the working GEM!!!") : working_gem;

get_working_mets() = working_mets == nothing ? error("You must first set the working GEM!!!") : working_mets;
get_working_mets(met) = get_working_mets()[Commons.parse_ider(working_mets, met),:];

get_working_rxns() = working_rxns == nothing ? error("You must first set the working GEM!!!") : working_rxns;
get_working_rxns(rxn) = get_working_rxns()[Commons.parse_ider(working_rxns, rxn),:];

get_working_S() = working_S == nothing ? error("You must first set the working GEM!!!") : working_S;
get_working_S(met, rxn) =
    get_working_S()[Commons.parse_ider(working_mets, met), Commons.parse_ider(working_rxns, rxn)];
get_working_S(::Colon, rxn) = get_working_S()[:, Commons.parse_ider(working_rxns, rxn)];
get_working_S(met, ::Colon) = get_working_S()[Commons.parse_ider(working_mets, met),:];

include("Backup.jl")


end
