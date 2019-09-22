get_data(met_df::DataFrame, col, met, mets...) =
    Commons.get_data(met_df, col, met, mets);
get_data(gem::GEM, col, met, mets...) = get_data(gem.mets, col, met, mets);
get_data(col, met, mets...) = get_data(Store.get_working_mets(), col, met, mets);

get(mets_df::DataFrame, met, mets...) = mets_df[parse_met(mets_df, met, mets),:];
get(gem::GEM, met, mets...) = get(gem.mets, met, mets)
get(met, mets...) = get(Store.get_working_mets(), met, mets);
get() = Store.get_working_mets();

get_c(met_df::DataFrame, met, mets...) =
    get_data(met_df, :c, met, mets);
get_c(gem::GEM, met, mets...) = get_c(gem.mets, met, mets);
get_c(met, mets...) = get_c(Store.get_working_mets(), met, mets);

get_y(met_df::DataFrame, met, mets...) =
    get_data(met_df, :y, met, mets);
get_y(gem::GEM, met, mets...) = get_y(gem.mets, met, mets...);
get_y(met, mets...) = get_y(Store.get_working_mets(), met, mets...);

get_e(met_df::DataFrame, met, mets...) =
    get_data(met_df, :e, met, mets);
get_e(gem::GEM, met, mets...) = get_e(gem.mets, met, mets);
get_e(met, mets...) = get_e(Store.get_working_mets(), met, mets);

get_V(met_df::DataFrame, met, mets...) =
    get_data(met_df, :V, met, mets);
get_V(gem::GEM, met, mets...) = get_V(gem.mets, met, mets);
get_V(met, mets...) = get_V(Store.get_working_mets(), met, mets);

get_L(met_df::DataFrame, met, mets...) =
    get_data(met_df, :L, met, mets);
get_L(gem::GEM, met, mets...) = get_L(gem.mets, met, mets);
get_L(met, mets...) = get_L(Store.get_working_mets(), met, mets);

get_medium(met_df::DataFrame) = sparsevec(met_df[:c]).nzind;
get_medium(gem::GEM) = get_medium(gem.mets);
get_medium() = get_medium(Store.get_working_mets());

function get_medium_dict(mets_df::DataFrame)
    biomass = Dict();
    for meti in METS.get_medium(mets_df)
        biomass[Commons.id(mets_df, meti)] = get_c(mets_df, meti)
    end
    return biomass;
end
get_medium_dict(gem::GEM) = get_medium_dict(gem.mets);
get_medium_dict() = get_medium_dict(Store.get_working_mets());

get_biomass(met_df::DataFrame) = sparsevec(met_df[:y]).nzind;
get_biomass(gem::GEM) = get_biomass(gem.mets);
get_biomass() = get_biomass(Store.get_working_mets());

function get_biomass_dict(mets_df::DataFrame)
    biomass = Dict();
    for meti in METS.get_biomass(mets_df)
        biomass[Commons.id(mets_df, meti)] = METS.get_y(mets_df, meti)
    end
    return biomass;
end
get_biomass_dict(gem::GEM) = get_biomass_dict(gem.mets);
get_biomass_dict() = get_biomass_dict(Store.get_working_mets());

get_exchangeables(met_df::DataFrame) = find(((met_df[:V] .!= 0.0) .& (met_df[:c] .> 0)) .| (met_df[:L] .!= 0.0));
get_exchangeables(gem::GEM) = get_exchangeables(gem.mets);
get_exchangeables() = get_exchangeables(Store.get_working_mets());

get_count() = size(Store.get_working_S(),1);
