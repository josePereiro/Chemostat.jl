module METS

using Chemostat.GEMTools.Store;
using Chemostat.GEMTools.Commons;
using Chemostat.GEMs.GEM;
using DataFrames;

# Parser
parse_met(mets_df, met) = Commons.parse_ider(mets_df, met);
parse_met(gem::GEM, met) = Commons.parse_ider(gem.mets, met);
parse_met(met) = Commons.parse_ider(Store.get_mets(), met);


# Ids
id(ider) = Commons.id(Store.get_mets(), ider)
id_equal_to(gem::GEM, id) = Commons.id_equal_to(gem.mets, id);
id_equal_to(id::String) = Commons.id_equal_to(Store.get_mets(), id);

ids() = Commons.ids(Store.get_mets());
ids(gem::GEM, id) = Commons.ids(gem.mets, id);
ids(ider, iders...) = Commons.ids(Store.get_mets(), ider, iders...);

ids_starting_with(s,ss...) = Commons.ids_starting_with(Store.get_mets(), s,ss...);
ids_ending_with(s,ss...) = Commons.ids_ending_with(Store.get_mets(), s,ss...);
ids_containing(s,ss...) = Commons.ids_containing(Store.get_mets(), s,ss...);
ids_equals_to(s,ss...) = Commons.ids_equals_to(Store.get_mets(), s,ss...);
ids_not_starting_with(s,ss...) = Commons.ids_not_starting_with(Store.get_mets(), s,ss...);
ids_not_ending_with(s,ss...) = Commons.ids_not_ending_with(Store.get_mets(), s,ss...);
ids_not_containing(s,ss...) = Commons.ids_not_containing(Store.get_mets(), s,ss...);
ids_not_equals_to(s,ss...) = Commons.ids_not_equals_to(Store.get_mets(), s,ss...);

# GEMTools
# rxns involved
"""
    rxns(mindx::Int)
    rxns(mid::String)

    Returns the indexes of all the reactions where the given metabolite participate.
"""
rxns_involved(met::Commons.Ider_type) = Store.get_S(met, :).nzind;
is_involved_in(met::Commons.Ider_type, rxn::Commons.Ider_type) = Store.get_S(met, rxn) != 0;

rxns_as_react(met::Commons.Ider_type) = filter((rxn) -> is_reactant_in(met,rxn), rxns_involved(met));
is_reactant_in(met::Commons.Ider_type, rxn::Commons.Ider_type) = Store.get_S(met, rxn) < 0.0;

rxns_as_prod(met::Int) = filter((rxn) -> is_product_in(met,rxn), rxns_involved(met));;
is_product_in(met::Commons.Ider_type, rxn::Commons.Ider_type) = Store.get_S(met, rxn) > 0.0;

# Setters

function set_c!(mets_df, met::Commons.Ider_type, c)
    c < 0.0 && error("c must be positive")
    Commons.set_data!(mets_df, met, :c, Float64(c));
end
set_c!(gem::GEM, met::Commons.Ider_type, c) = set_c!(gem.mets, met, c);
set_c!(met::Commons.Ider_type, c) = set_c!(Store.get_mets(), met, c);

set_y!(mets_df, met::Commons.Ider_type, y) =
    Commons.set_data!(mets_df, met, :y, Float64(y));
set_y!(gem::GEM, met::Commons.Ider_type, y) = set_y!(gem.mets, met, y);
set_y!(met::Commons.Ider_type, y) = set_y!(Store.get_mets(), met, y);


set_e!(mets_df, met::Commons.Ider_type, e) =
    Commons.set_data!(mets_df, met, :e, Float64(e));
set_e!(gem::GEM, met::Commons.Ider_type, e) = set_e!(gem.mets, met, e);
set_e!(met::Commons.Ider_type, e) = set_e!(Store.get_mets(), met, e);


function set_medium!(mets_df::DataFrame, mets::Vector, cs::Vector)
    for (i,met) in enumerate(mets)
        set_c!(mets_df, met, cs[i])
    end
end
set_medium!(gem::GEM,mets::Vector, cs::Vector) = set_medium!(gem.mets, mets, cs);
set_medium!(mets::Vector, cs::Vector) = set_medium!(Store.get_mets(), mets, cs);

# Getters

get() = Store.get_mets();
get(met::Commons.Ider_type) = Store.get_mets(met);
get(met, mets...) = Store.get_mets([met; mets]);

get_c(met_df::DataFrame, met::Commons.Ider_type) =
    Commons.get_data(met_df, met, :c);
get_c(gem::GEM, met::Commons.Ider_type) = get_c(gem.mets, met);
get_c(met::Commons.Ider_type) = get_c(Store.get_mets(), met);

get_name(met_df::DataFrame, met::Commons.Ider_type) =
    Commons.get_data(met_df, met, :name);
get_name(gem::GEM, met::Commons.Ider_type) = get_name(gem.mets, met);
get_name(met::Commons.Ider_type) = get_name(Store.get_mets(), met);

get_y(met_df::DataFrame, met::Commons.Ider_type) =
    Commons.get_data(met_df, met, :y);
get_y(gem::GEM, met::Commons.Ider_type) = get_y(gem.mets, met);
get_y(met::Commons.Ider_type) = get_y(Store.get_mets(), met);

get_e(met_df::DataFrame, met::Commons.Ider_type) =
    Commons.get_data(met_df, met, :e);
get_e(gem::GEM, met::Commons.Ider_type) = get_e(gem.mets, met);
get_e(met::Commons.Ider_type) = get_e(Store.get_mets(), met);

get_medium(met_df::DataFrame) = sparsevec(met_df[:c]).nzind;
get_medium(gem::GEM) = get_medium(gem.mets);
get_medium() = get_medium(Store.get_mets());

function get_medium_dict(mets_df::DataFrame)
    biomass = Dict();
    for meti in METS.get_medium(mets_df)
        biomass[Commons.id(mets_df, meti)] = get_c(mets_df, meti)
    end
    return biomass;
end
get_medium_dict(gem::GEM) = get_medium_dict(gem.mets);
get_medium_dict() = get_medium_dict(Store.get_mets());

get_biomass(met_df::DataFrame) = sparsevec(met_df[:y]).nzind;
get_biomass(gem::GEM) = get_biomass(gem.mets);
get_biomass() = get_biomass(Store.get_mets());

get_exchangeables(met_df::DataFrame) = find(((met_df[:V] .!= 0.0) .& (met_df[:c] .> 0)) .| (met_df[:L] .!= 0.0));
get_exchangeables(gem::GEM) = get_exchangeables(gem.mets);
get_exchangeables() = get_exchangeables(Store.get_mets());


function get_biomass_dict(mets_df::DataFrame)
    biomass = Dict();
    for meti in METS.get_biomass(mets_df)
        biomass[Commons.id(mets_df, meti)] = METS.get_y(mets_df, meti)
    end
    return biomass;
end
get_biomass_dict(gem::GEM) = get_biomass_dict(gem.mets);
get_biomass_dict() = get_biomass_dict(Store.get_mets());

count() = size(Store.get_S(),1);

end
