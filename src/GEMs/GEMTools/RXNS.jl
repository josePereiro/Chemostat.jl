module RXNS

using Chemostat.GEMTools.Store;
using Chemostat.GEMTools.Commons;
using Chemostat.GEMTools.METS;
using Chemostat.GEMs.GEM;
using DataFrames;


# Ids
id(ider) = Commons.id(Store.get_rxns(), ider)
id_equal_to(id::String) = Commons.id_equal_to(Store.get_rxns(), id);

ids() = Commons.ids(Store.get_rxns());
ids(gem::GEM, id) = Commons.ids(gem.rxns, id);
ids(ider, iders...) = Commons.ids(Store.get_rxns(), ider, iders...);

ids_starting_with(s,ss...) = Commons.ids_starting_with(Store.get_rxns(), s,ss...);
ids_ending_with(s,ss...) = Commons.ids_ending_with(Store.get_rxns(), s,ss...);
ids_containing(s,ss...) = Commons.ids_containing(Store.get_rxns(), s,ss...);
ids_equals_to(s,ss...) = Commons.ids_equals_to(Store.get_rxns(), s,ss...);
ids_not_starting_with(s,ss...) = Commons.ids_not_starting_with(Store.get_rxns(), s,ss...);
ids_not_ending_with(s,ss...) = Commons.ids_not_ending_with(Store.get_rxns(), s,ss...);
ids_not_containing(s,ss...) = Commons.ids_not_containing(Store.get_rxns(), s,ss...);
ids_not_equals_to(s,ss...) = Commons.ids_not_equals_to(Store.get_rxns(), s,ss...);


# GEMTools
all_mets(rxn::Commons.Ider_type) = Store.get_S(:, rxn).nzind;
all_mets(rxn, rxns...) = union([all_mets(r) for r in Commons.collect_iders(rxn, rxns)]...);
common_mets(rxn, rxns...) = intersect([all_mets(r) for r in Commons.collect_iders(rxn, rxns)]...);

with_mets(met::Commons.Ider_type) = Store.get_S(met, :).nzind;
with_mets(met, mets...) = intersect([with_mets(m) for m in Commons.collect_iders(rxn, rxns)]...);

all_reacts(rxn::Commons.Ider_type) = filter((met) -> Store.get_S(met,rxn) < 0 , all_mets(rxn));
all_reacts(rxn,rxns...) = union([all_reacts(r) for r in Commons.collect_iders(rxn, rxns)]...);
common_reacts(rxn, rxns...) = intersect([all_reacts(r) for r in Commons.collect_iders(rxn, rxns)]...);

with_reacts(met::Commons.Ider_type) = filter((rxn) -> Store.get_S(met,rxn) < 0, with_mets(met));
with_reacts(met, mets...) = intersect([with_reacts(m) for m in Commons.collect_iders(met, mets)]...);

all_prods(rxn::Commons.Ider_type) = filter((met) -> Store.get_S(met,rxn) > 0 , all_mets(rxn));
all_prods(rxn,rxns...) = union([all_prods(r) for r in Commons.collect_iders(rxn, rxns)]...);
common_prods(rxn, rxns...) = intersect([all_prods(r) for r in Commons.collect_iders(rxn, rxns)]...);

with_prods(met::Commons.Ider_type) = filter((rxn) -> Store.get_S(met,rxn) > 0, with_mets(met));
with_prods(met, mets...) = intersect([with_prods(m) for m in Commons.collect_iders(rxn, rxns)]...);

has_prods_only(rxn::Commons.Ider_type) = length(all_reacts(rxn)) == 0 && length(all_prods(rxn)) > 0;
has_reacts_only(rxn::Commons.Ider_type) = length(all_reacts(rxn)) > 0 && length(all_prods(rxn)) == 0;

is_external(rxn::Commons.Ider_type) = has_reacts_only(rxn) || has_prods_only(rxn);
is_internal(rxn::Commons.Ider_type) = !is_external(rxn);

externals() = find(is_external, 1:get_count());
internals() = find(is_internal, 1:get_count());

is_rev(rxn::Commons.Ider_type) = let rxn_data = Store.get_rxns(rxn)
    return rxn_data[1,:pub] != 0.0 && rxn_data[1,:nub] != 0.0; end
revs() = find(is_rev, 1:get_count());

is_not_rev(rxn::Commons.Ider_type) = !is_rev(rxn);
not_revs() = find(is_not_rev, 1:get_count());


is_blocked(rxn::Commons.Ider_type) = let rxn_data = Store.get_rxns(rxn)
    return rxn_data[1,:pub] == 0.0 && rxn_data[1,:nub] == 0.0; end
blocked() = find(is_blocked, 1:get_count());

is_not_blocked(rxn::Commons.Ider_type) = !is_blocked(rxn);
not_blocked() = find(is_not_blocked, 1:get_count());

is_fixxed(rxn::Commons.Ider_type) = let rxn_data = Store.get_rxns(rxn)
    return ((rxn_data[1,:pub] == rxn_data[1,:plb] && rxn_data[1,:nub] == rxn_data[1,:nlb] == 0.0) ||
        (rxn_data[1,:pub] == rxn_data[1,:plb] == 0.0 && rxn_data[1,:nub] == rxn_data[1,:nlb])); end
fixxed() = find(is_fixxed, 1:get_count());

is_not_fixxed(rxn::Commons.Ider_type) = !is_fixxed(rxn);
not_fixxed() = find(is_not_fixxed, 1:get_count());

is_fwd_only(rxn::Commons.Ider_type) = let rxn_data = Store.get_rxns(rxn)
    return rxn_data[1,:pub] != 0.0 && rxn_data[1,:nub] == 0.0; end
fwd_only() = find(is_fwd_only, 1:get_count());

is_bkwd_only(rxn::Commons.Ider_type) = let rxn_data = Store.get_rxns(rxn)
    return rxn_data[1,:pub] == 0.0 && rxn_data[1,:nub] != 0.0; end
bkwd_only() = find(is_bkwd_only, 1:get_count());

# Getters

get() = Store.get_rxns();
get(rxn::Commons.Ider_type) = Store.get_rxns(rxn);
get(rxn, rxns...) = Store.get_rxns([rxn; rxns]);

get_name(rxn_df::DataFrame, rxn::Commons.Ider_type) =
    Commons.get_data(rxn_df, rxn, :name);
get_name(gem::GEM, rxn::Commons.Ider_type) = get_name(gem.rxns, rxn);
get_name(rxn::Commons.Ider_type) = get_name(Store.get_rxns(), rxn);

get_equation(rxn::Commons.Ider_type) = begin
    string([string((i != 1)?" + ":"","(" * string(-Store.get_S(react, rxn)) * ") " * METS.id(react))
        for (i,react) in enumerate(all_reacts(rxn))]...,
        is_rev(rxn)?" <==> ":is_fwd_only(rxn)? " ==> ":is_bkwd_only(rxn)?" <== ":" >< ",
        [string((i != 1)?" + ":"","(" * string(Store.get_S(prod, rxn)) * ") " * METS.id(prod))
        for (i,prod) in enumerate(all_prods(rxn))]...
    ); end
get_equation(rxn, rxns...) = [get_equation(r) for r in Commons.collect_iders(rxn, rxns)];
get_equation() = get_equation(1:get_count());

get_count() = size(Store.get_S(),2);

end # module RXNS
