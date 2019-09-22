# Ids
id(mets_id::DataFrame, met) = Commons.id(mets_id, met);
id(gem::GEM, met) = id(gem.mets, met);
id(met) = id(Store.get_working_mets(), met);

ids() = Commons.ids(Store.get_working_mets());
ids(mets_df::DataFrame, met, mets...) = Commons.ids(mets_df::DataFrame, met, mets);
ids(gem::GEM, met, mets...) = ids(gem.mets, met, mets);
ids(met, mets...) = ids(Store.get_working_mets(), met, mets);

id_equal_to(mets_df, id::String) = Commons.id_equal_to(mets_df, id);
id_equal_to(gem::GEM, id::String) = id_equal_to(gem.mets, id);
id_equal_to(id::String) = id_equal_to(Store.get_working_mets(), id);

ids_starting_with(mets_df::DataFrame, s,ss...) = Commons.ids_starting_with(mets_df::DataFrame, s, ss);
ids_starting_with(gem::GEM, s,ss...) = ids_starting_with(gem.mets, s, ss);
ids_starting_with(s,ss...) = ids_starting_with(Store.get_working_mets(), s, ss);

ids_ending_with(mets_df::DataFrame, s,ss...) = Commons.ids_ending_with(mets_df::DataFrame, s, ss);
ids_ending_with(gem::GEM, s,ss...) = ids_ending_with(gem.mets, s, ss);
ids_ending_with(s,ss...) = ids_ending_with(Store.get_working_mets(), s, ss);

ids_containing(mets_df::DataFrame, s,ss...) = Commons.ids_containing(mets_df::DataFrame, s, ss);
ids_containing(gem::GEM, s,ss...) = ids_containing(gem.mets, s, ss);
ids_containing(s,ss...) = ids_containing(Store.get_working_mets(), s, ss);

ids_equals_to(mets_df::DataFrame, s,ss...) = Commons.ids_equals_to(mets_df::DataFrame, s, ss);
ids_equals_to(gem::GEM, s,ss...) = ids_equals_to(gem.mets, s, ss);
ids_equals_to(s,ss...) = ids_equals_to(Store.get_working_mets(), s, ss);

ids_not_starting_with(mets_df::DataFrame, s,ss...) = Commons.ids_not_starting_with(mets_df::DataFrame, s, ss);
ids_not_starting_with(gem::GEM, s,ss...) = ids_not_starting_with(gem.mets, s, ss);
ids_not_starting_with(s,ss...) = ids_not_starting_with(Store.get_working_mets(), s, ss);

ids_not_ending_with(mets_df::DataFrame, s,ss...) = Commons.ids_not_ending_with(mets_df::DataFrame, s, ss);
ids_not_ending_with(gem::GEM, s,ss...) = ids_not_ending_with(gem.mets, s, ss);
ids_not_ending_with(s,ss...) = ids_not_ending_with(Store.get_working_mets(), s, ss);

ids_not_containing(mets_df::DataFrame, s,ss...) = Commons.ids_not_containing(mets_df::DataFrame, s, ss);
ids_not_containing(gem::GEM, s,ss...) = ids_not_containing(gem.mets, s, ss);
ids_not_containing(s,ss...) = ids_not_containing(Store.get_working_mets(), s, ss);

ids_not_equals_to(mets_df::DataFrame, s,ss...) = Commons.ids_not_equals_to(mets_df::DataFrame, s, ss);
ids_not_equals_to(gem::GEM, s,ss...) = ids_not_equals_to(gem.mets, s, ss);
ids_not_equals_to(s,ss...) = ids_not_equals_to(Store.get_working_mets(), s, ss);
