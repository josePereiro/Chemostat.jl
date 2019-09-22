set_data!(df::DataFrame, col, val, met, mets...) =
    Commons.set_data!(df, col, val, met, mets);
set_data!(gem::GEM, col, val, met, mets...) =
    set_data!(gem.mets, col, val, met, mets);
set_data!(col, val, met, mets...) =
    set_data!(Store.get_working_mets(), col, val, met, mets);

function set_c!(mets_df::DataFrame, c::Number, met, mets...)
    c < 0.0 && error("c must be positive")
    set_data!(mets_df, :c, Float64(c), met, mets);
end
set_c!(gem::GEM, c, met, mets...) = set_c!(gem.mets, c, met, mets);
# set_c!(c, met, mets...) = set_c!(Store.get_working_mets(), c, met, mets);

set_y!(mets_df::DataFrame, y::Number, met, mets...) =
    set_data!(mets_df, :y, Float64(y), met, mets);
set_y!(gem::GEM, y, met, mets...) = set_y!(gem.mets, y, met, mets);
set_y!(y, met, mets...) = set_y!(Store.get_working_mets(), y, met, mets);

set_e!(mets_df::DataFrame, e::Number, met, mets...) =
    set_data!(mets_df, :e, Float64(e), met, mets);
set_e!(gem::GEM, e, met, mets...) = set_e!(gem.mets, e, met, mets);
set_e!(e, met, mets...) = set_e!(Store.get_working_mets(), e, met, mets);

set_V!(mets_df::DataFrame, V::Number, met, mets...) =
    set_data!(mets_df, :V, Float64(V), met, mets);
set_V!(gem::GEM, V, met, mets...) = set_V!(gem.mets, V, met, mets);
set_V!(V, met, mets...) = set_V!(Store.get_working_mets(), V, met, mets);

set_L!(mets_df::DataFrame, L::Number, met, mets...) =
    set_data!(mets_df, :L, Float64(L), met, mets);
set_L!(gem::GEM, L, met, mets...) = set_L!(gem.mets, L, met, mets);
set_L!(L, met, mets...) = set_L!(Store.get_working_mets(), L, met, mets);

function set_medium!(mets_df::DataFrame, mets::Vector, cs::Vector)
    for (i,met) in enumerate(mets)
        set_c!(mets_df, met, cs[i])
    end
end
set_medium!(gem::GEM,mets::Vector, cs::Vector) = set_medium!(gem.mets, mets, cs);
set_medium!(mets::Vector, cs::Vector) = set_medium!(Store.get_working_mets(), mets, cs);
