# Ids
id(rxns_id::DataFrame, rxn) = Commons.id(rxns_id, rxn);
id(gem::GEM, rxn) = id(gem.rxns, rxn);
id(rxn) = id(Store.get_working_rxns(), rxn);

ids() = Commons.ids(Store.get_working_rxns());
ids(rxns_df::DataFrame, rxn, rxns...) = Commons.ids(rxns_df::DataFrame, rxn, rxns);
ids(gem::GEM, rxn, rxns...) = ids(gem.rxns, rxn, rxns);
ids(rxn, rxns...) = ids(Store.get_working_rxns(), rxn, rxns);

id_equal_to(rxns_df, id::String) = Commons.id_equal_to(rxns_df, id);
id_equal_to(gem::GEM, id::String) = id_equal_to(gem.rxns, id);
id_equal_to(id::String) = id_equal_to(Store.get_working_rxns(), id);

ids_starting_with(rxns_df::DataFrame, s,ss...) = Commons.ids_starting_with(rxns_df::DataFrame, s, ss);
ids_starting_with(gem::GEM, s,ss...) = ids_starting_with(gem.rxns, s, ss);
ids_starting_with(s,ss...) = ids_starting_with(Store.get_working_rxns(), s, ss);

ids_ending_with(rxns_df::DataFrame, s,ss...) = Commons.ids_ending_with(rxns_df::DataFrame, s, ss);
ids_ending_with(gem::GEM, s,ss...) = ids_ending_with(gem.rxns, s, ss);
ids_ending_with(s,ss...) = ids_ending_with(Store.get_working_rxns(), s, ss);

ids_containing(rxns_df::DataFrame, s,ss...) = Commons.ids_containing(rxns_df::DataFrame, s, ss);
ids_containing(gem::GEM, s,ss...) = ids_containing(gem.rxns, s, ss);
ids_containing(s,ss...) = ids_containing(Store.get_working_rxns(), s, ss);

ids_equals_to(rxns_df::DataFrame, s,ss...) = Commons.ids_equals_to(rxns_df::DataFrame, s, ss);
ids_equals_to(gem::GEM, s,ss...) = ids_equals_to(gem.rxns, s, ss);
ids_equals_to(s,ss...) = ids_equals_to(Store.get_working_rxns(), s, ss);

ids_not_starting_with(rxns_df::DataFrame, s,ss...) = Commons.ids_not_starting_with(rxns_df::DataFrame, s, ss);
ids_not_starting_with(gem::GEM, s,ss...) = ids_not_starting_with(gem.rxns, s, ss);
ids_not_starting_with(s,ss...) = ids_not_starting_with(Store.get_working_rxns(), s, ss);

ids_not_ending_with(rxns_df::DataFrame, s,ss...) = Commons.ids_not_ending_with(rxns_df::DataFrame, s, ss);
ids_not_ending_with(gem::GEM, s,ss...) = ids_not_ending_with(gem.rxns, s, ss);
ids_not_ending_with(s,ss...) = ids_not_ending_with(Store.get_working_rxns(), s, ss);

ids_not_containing(rxns_df::DataFrame, s,ss...) = Commons.ids_not_containing(rxns_df::DataFrame, s, ss);
ids_not_containing(gem::GEM, s,ss...) = ids_not_containing(gem.rxns, s, ss);
ids_not_containing(s,ss...) = ids_not_containing(Store.get_working_rxns(), s, ss);

ids_not_equals_to(rxns_df::DataFrame, s,ss...) = Commons.ids_not_equals_to(rxns_df::DataFrame, s, ss);
ids_not_equals_to(gem::GEM, s,ss...) = ids_not_equals_to(gem.rxns, s, ss);
ids_not_equals_to(s,ss...) = ids_not_equals_to(Store.get_working_rxns(), s, ss);
