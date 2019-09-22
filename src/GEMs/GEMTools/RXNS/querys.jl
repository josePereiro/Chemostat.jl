all_mets(rxn::Commons.Ider_type) = Store.get_working_S(:, rxn).nzind;
all_mets(rxn, rxns...) = union([all_mets(r) for r in Commons.collect_iders(rxn, rxns)]...);
common_mets(rxn, rxns...) = intersect([all_mets(r) for r in Commons.collect_iders(rxn, rxns)]...);

with_mets(met::Commons.Ider_type) = Store.get_working_S(met, :).nzind;
with_mets(met, mets...) = intersect([with_mets(m) for m in Commons.collect_iders(rxn, rxns)]...);

all_reacts(rxn::Commons.Ider_type) = filter((met) -> Store.get_working_S(met,rxn) < 0 , all_mets(rxn));
all_reacts(rxn,rxns...) = union([all_reacts(r) for r in Commons.collect_iders(rxn, rxns)]...);
common_reacts(rxn, rxns...) = intersect([all_reacts(r) for r in Commons.collect_iders(rxn, rxns)]...);

with_reacts(met::Commons.Ider_type) = filter((rxn) -> Store.get_working_S(met,rxn) < 0, with_mets(met));
with_reacts(met, mets...) = intersect([with_reacts(m) for m in Commons.collect_iders(met, mets)]...);

all_prods(rxn::Commons.Ider_type) = filter((met) -> Store.get_working_S(met,rxn) > 0 , all_mets(rxn));
all_prods(rxn,rxns...) = union([all_prods(r) for r in Commons.collect_iders(rxn, rxns)]...);
common_prods(rxn, rxns...) = intersect([all_prods(r) for r in Commons.collect_iders(rxn, rxns)]...);

with_prods(met::Commons.Ider_type) = filter((rxn) -> Store.get_working_S(met,rxn) > 0, with_mets(met));
with_prods(met, mets...) = intersect([with_prods(m) for m in Commons.collect_iders(rxn, rxns)]...);

has_prods_only(rxn::Commons.Ider_type) = length(all_reacts(rxn)) == 0 && length(all_prods(rxn)) > 0;
has_reacts_only(rxn::Commons.Ider_type) = length(all_reacts(rxn)) > 0 && length(all_prods(rxn)) == 0;

is_external(rxn::Commons.Ider_type) = has_reacts_only(rxn) || has_prods_only(rxn);
is_internal(rxn::Commons.Ider_type) = !is_external(rxn);

externals() = find(is_external, 1:get_count());
internals() = find(is_internal, 1:get_count());

is_rev(rxn::Commons.Ider_type) = let rxn_data = Store.get_working_rxns(rxn)
    return rxn_data[1,:pub] != 0.0 && rxn_data[1,:nub] != 0.0; end
revs() = find(is_rev, 1:get_count());

is_not_rev(rxn::Commons.Ider_type) = !is_rev(rxn);
not_revs() = find(is_not_rev, 1:get_count());


is_blocked(rxn::Commons.Ider_type) = let rxn_data = Store.get_working_rxns(rxn)
    return rxn_data[1,:pub] == 0.0 && rxn_data[1,:nub] == 0.0; end
blocked() = find(is_blocked, 1:get_count());

is_not_blocked(rxn::Commons.Ider_type) = !is_blocked(rxn);
not_blocked() = find(is_not_blocked, 1:get_count());

is_fixxed(rxn::Commons.Ider_type) = let rxn_data = Store.get_working_rxns(rxn)
    return ((rxn_data[1,:pub] == rxn_data[1,:plb] && rxn_data[1,:nub] == rxn_data[1,:nlb] == 0.0) ||
        (rxn_data[1,:pub] == rxn_data[1,:plb] == 0.0 && rxn_data[1,:nub] == rxn_data[1,:nlb])); end
fixxed() = find(is_fixxed, 1:get_count());

is_not_fixxed(rxn::Commons.Ider_type) = !is_fixxed(rxn);
not_fixxed() = find(is_not_fixxed, 1:get_count());

is_fwd_only(rxn::Commons.Ider_type) = let rxn_data = Store.get_working_rxns(rxn)
    return rxn_data[1,:pub] != 0.0 && rxn_data[1,:nub] == 0.0; end
fwd_only() = find(is_fwd_only, 1:get_count());

is_bkwd_only(rxn::Commons.Ider_type) = let rxn_data = Store.get_working_rxns(rxn)
    return rxn_data[1,:pub] == 0.0 && rxn_data[1,:nub] != 0.0; end
bkwd_only() = find(is_bkwd_only, 1:get_count());
