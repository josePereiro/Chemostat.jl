# rxns involved
"""
    rxns(mindx::Int)
    rxns(mid::String)

    Returns the indexes of all the reactions where the given metabolite participate.
"""
rxns_involved(met::Commons.Ider_type) = Store.get_working_S(met, :).nzind;
is_involved_in(met::Commons.Ider_type, rxn::Commons.Ider_type) = Store.get_working_S(met, rxn) != 0;

rxns_as_react(met::Commons.Ider_type) = filter((rxn) -> is_reactant_in(met,rxn), rxns_involved(met));
is_reactant_in(met::Commons.Ider_type, rxn::Commons.Ider_type) = Store.get_working_S(met, rxn) < 0.0;

rxns_as_prod(met::Commons.Ider_type) = filter((rxn) -> is_product_in(met,rxn), rxns_involved(met));
is_product_in(met::Commons.Ider_type, rxn::Commons.Ider_type) = Store.get_working_S(met, rxn) > 0.0;

consumable(mets_df) = find((row) -> row[:V] > 0.0 && row[:c] > 0.0, eachrow(mets_df));
consumable() = consumable(Store.get_working_mets());

secretable(mets_df) = find((L) -> L < 0.0, mets_df[:L]);
secretable() = secretable(Store.get_working_mets());

exchangeable(mets_df) = find((row) -> row[:L] < 0.0 &&
    row[:V] > 0.0 && row[:c] > 0.0, eachrow(mets_df));
exchangeable() = exchangeable(Store.get_working_mets());
