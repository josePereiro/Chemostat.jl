# Parser
parse_rxn(rxns_df, rxn, rxns...) = Commons.parse_ider(rxns_df, rxn, rxns);
parse_rxn(gem::GEM, rxn, rxns) = parse_rxn(gem.rxns, rxn, rxns);
parse_rxn(rxn, rxns) = parse_rxn(Store.get_working_rxns(), rxn, rxns);
