ξunits = "gDW hr/ L";
μunits = "gDW/ gDW hr";
Dunits = "1/ hr";
Cunits = "mM";
Runits = "mmol/ gDW hr";
Xunits = "gDW/ L";

ξlabel() = "ξ ($ξunits)";
μlabel() = "μ ($μunits)";
Dlabel() = "D ($Dunits)";
Clabel(met) = "c_$met ($Cunits)";
Clabel() = "c ($Cunits)";
Slabel(met) = "s_$met ($Cunits)";
Slabel() = "s ($Cunits)";
Rlabel(met) = "r_$met ($Runits)";
Rlabel() = "r ($Runits)";
Ulabel(met) = "u_$met ($Runits)";
Ulabel() = "u ($Runits)";
ϕlabel() = "ϕ";
Xvlabel() = "Xv ($Xunits)";

get_expres_label(expres) =
    "[$(ExpRess.get_type(expres))$(isnan(ExpRess.get_β(expres))?"":" β=$(ExpRess.get_β(expres))")]";
get_label(head::String , expres::Chemostat.ExpRess.ExpRes) =
    "$(head) $(get_expres_label(expres))";
get_label(head::String , express::Vector{Chemostat.ExpRess.ExpRes}) =
    ["$i: $(head) $(get_expres_label(express[i]))" for i in 1:length(express)];
get_label(head::String, express::Dict{String, Chemostat.ExpRess.ExpRes}) =
    let ks = ks = sort(collect(keys(express)))
        return [get_label(head, express[k]) * " $(k)" for k in ks];
    end

get_label(head::String , id::String, expres::Chemostat.ExpRess.ExpRes) =
    "$(head)($(id)) $(get_expres_label(expres))";
get_label(head::String , ids::Vector{String}, express::Vector{Chemostat.ExpRess.ExpRes}) =
    ["$i: $(head)($(ids[i])) $(get_expres_label(express[i]))" for i in 1:length(express)];
get_label(head::String , ids::Vector{String}, expres::Chemostat.ExpRess.ExpRes) =
    ["$i: $(head)($(ids[i])) $(get_expres_label(expres))" for i in 1:length(ids)];
get_label(head::String , id::String, express::Vector{Chemostat.ExpRess.ExpRes}) =
    ["$i: $(head)($(id)) $(get_expres_label(express[i]))" for i in 1:length(express)];
get_label(head::String, id::String, express::Dict{String, Chemostat.ExpRess.ExpRes}) =
    let ks = sort(collect(keys(express)))
        return [get_label(head, id, express[k]) * " $(k)" for k in ks];
    end
get_label(head::String, ids::Vector{String}, express::Dict{String, Chemostat.ExpRess.ExpRes}) =
    let ks = sort(collect(keys(express)))
        return [get_label(head, ids[i], express[ks[i]]) * " $(ks[i])"
            for i in 1:length(ks)];
    end
