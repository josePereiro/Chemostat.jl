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

consumable(mets_df) = find((V) -> V > 0.0, mets_df[:V]);
consumable() = consumable(Store.get_working_mets());

secretable(mets_df) = find((L) -> L < 0.0, mets_df[:L]);
secretable() = secretable(Store.get_working_mets());
