set_data!(df::DataFrame, col, val, rxn, rxns...) =
    Commons.set_data!(df, col, val, rxn, rxns);
set_data!(gem::GEM, col, val, rxn, rxns) =
    set_data!(gem.rxns, col, val, rxn, rxns);
set_data!(col, val, rxn, rxns...) =
    set_data!(Store.get_working_rxns(), col, val, rxn, rxns);

function set_ap!(rxns_df::DataFrame, ap::Number, rxn, rxns...)
    ap < 0.0 && error("ap must be positive")
    set_data!(rxns_df, :ap, Float64(ap), rxn, rxns);
end
set_ap!(gem::GEM, ap, rxn, rxns...) = set_ap!(gem.rxns, ap, rxn, rxns);
set_ap!(ap, rxn, rxns...) = set_ap!(Store.get_working_rxns(), ap, rxn, rxns);

function set_an!(rxns_df::DataFrame, an::Number, rxn, rxns...)
    an < 0.0 && error("an must be positive")
    set_data!(rxns_df, :an, Float64(an), rxn, rxns);
end
set_an!(gem::GEM, an, rxn, rxns...) = set_an!(gem.rxns, an, rxn, rxns);
set_an!(an, rxn, rxns...) = set_an!(Store.get_working_rxns(), an, rxn, rxns);

function set_plb!(rxns_df::DataFrame, plb::Number, rxn, rxns...)
    set_data!(rxns_df, :plb, Float64(plb), rxn, rxns);
end
set_plb!(gem::GEM, plb, rxn, rxns...) = set_plb!(gem.rxns, plb, rxn, rxns);
set_plb!(plb, rxn, rxns...) = set_plb!(Store.get_working_rxns(), plb, rxn, rxns);

function set_pub!(rxns_df::DataFrame, pub::Number, rxn, rxns...)
    set_data!(rxns_df, :pub, Float64(pub), rxn, rxns);
end
set_pub!(gem::GEM, pub, rxn, rxns...) = set_pub!(gem.rxns, pub, rxn, rxns);
set_pub!(pub, rxn, rxns...) = set_pub!(Store.get_working_rxns(), pub, rxn, rxns);

function set_nlb!(rxns_df::DataFrame, nlb::Number, rxn, rxns...)
    set_data!(rxns_df, :nlb, Float64(nlb), rxn, rxns);
end
set_nlb!(gem::GEM, nlb, rxn, rxns...) = set_nlb!(gem.rxns, nlb, rxn, rxns);
set_nlb!(nlb, rxn, rxns...) = set_nlb!(Store.get_working_rxns(), nlb, rxn, rxns);

function set_nub!(rxns_df::DataFrame, nub::Number, rxn, rxns...)
    set_data!(rxns_df, :nub, Float64(nub), rxn, rxns);
end
set_nub!(gem::GEM, nub, rxn, rxns...) = set_nub!(gem.rxns, nub, rxn, rxns);
set_nub!(nub, rxn, rxns...) = set_nub!(Store.get_working_rxns(), nub, rxn, rxns);
