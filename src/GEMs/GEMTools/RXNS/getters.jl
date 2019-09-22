get_data(rxn_df::DataFrame, col, rxn, rxns...) =
    Commons.get_data(rxn_df, col, rxn, rxns);
get_data(gem::GEM, col, rxn, rxns...) = get_data(gem.rxns, col, rxn, rxns);
get_data(col, rxn, rxns...) = get_data(Store.get_working_rxns(), col, rxn, rxns);

get(rxns_df::DataFrame, rxn, rxns...) = rxns_df[parse_rxn(rxns_df, rxn, rxns),:];
get(gem::GEM, rxn, rxns...) = get(gem.rxns, rxn, rxns)
get(rxn, rxns...) = get(Store.get_working_rxns(), rxn, rxns);
get() = Store.get_working_rxns();

get_ap(rxn_df::DataFrame, rxn, rxns...) =
    get_data(rxn_df, :ap, rxn, rxns);
get_ap(gem::GEM, rxn, rxns...) = get_ap(gem.rxns, rxn, rxns...);
get_ap(rxn, rxns...) = get_ap(Store.get_working_rxns(), rxn, rxns...);

get_an(rxn_df::DataFrame, rxn, rxns...) =
    get_data(rxn_df, :an, rxn, rxns);
get_an(gem::GEM, rxn, rxns...) = get_an(gem.rxns, rxn, rxns...);
get_an(rxn, rxns...) = get_an(Store.get_working_rxns(), rxn, rxns...);

get_nub(rxn_df::DataFrame, rxn, rxns...) =
    get_data(rxn_df, :nub, rxn, rxns);
get_nub(gem::GEM, rxn, rxns...) = get_nub(gem.rxns, rxn, rxns...);
get_nub(rxn, rxns...) = get_nub(Store.get_working_rxns(), rxn, rxns...);

get_nlb(rxn_df::DataFrame, rxn, rxns...) =
    get_data(rxn_df, :nlb, rxn, rxns);
get_nlb(gem::GEM, rxn, rxns...) = get_nlb(gem.rxns, rxn, rxns...);
get_nlb(rxn, rxns...) = get_nlb(Store.get_working_rxns(), rxn, rxns...);

get_pub(rxn_df::DataFrame, rxn, rxns...) =
    get_data(rxn_df, :pub, rxn, rxns);
get_pub(gem::GEM, rxn, rxns...) = get_pub(gem.rxns, rxn, rxns...);
get_pub(rxn, rxns...) = get_pub(Store.get_working_rxns(), rxn, rxns...);

get_plb(rxn_df::DataFrame, rxn, rxns...) =
    get_data(rxn_df, :plb, rxn, rxns);
get_plb(gem::GEM, rxn, rxns...) = get_plb(gem.rxns, rxn, rxns...);
get_plb(rxn, rxns...) = get_plb(Store.get_working_rxns(), rxn, rxns...);

get_equation(rxn::Commons.Ider_type) = begin
    string([string((i != 1)?" + ":"","(" * string(-Store.get_working_S(react, rxn)) * ") " * METS.id(react))
        for (i,react) in enumerate(all_reacts(rxn))]...,
        is_rev(rxn)?" <==> ":is_fwd_only(rxn)? " ==> ":is_bkwd_only(rxn)?" <== ":" >< ",
        [string((i != 1)?" + ":"","(" * string(Store.get_working_S(prod, rxn)) * ") " * METS.id(prod))
        for (i,prod) in enumerate(all_prods(rxn))]...
    ); end
get_equation(rxn, rxns...) = [get_equation(r) for r in Commons.collect_iders(rxn, rxns)];
get_equation() = get_equation(1:get_count());

get_count() = size(Store.get_working_S(),2);
