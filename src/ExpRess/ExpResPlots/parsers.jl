function parse_params(express::Vector{Chemostat.ExpRess.ExpRes}, ids::Vector{String},
        res_fun, labels)
    params = Dict();
    params["express"] = express;
    params["ids"] = ids;
    params["res_funs"] = [res_fun for i in express];
    params["labels"] = labels;
    return params;
end

parse_params(expres::Chemostat.ExpRess.ExpRes,
        ids::Vector{String}, res_fun, labels) =
    parse_params([expres for i in ids], ids, res_fun, labels);

parse_params(express::Vector{Chemostat.ExpRess.ExpRes}, id::String,
        res_fun, labels) =
    parse_params(express, [id for i in express], res_fun, labels);

parse_params(expres::Chemostat.ExpRess.ExpRes, id::String,
        res_fun, label) =
    parse_params([expres], [id], res_fun, [label]);

parse_params(express::Dict{String, Chemostat.ExpRess.ExpRes},
        ids, res_fun, labels) =
    let ks = sort(collect(keys(express)))
        return parse_params([express[k] for k in ks], ids, res_fun, labels)
    end


function parse_params(express::Vector{Chemostat.ExpRess.ExpRes},
        res_fun, labels)
    params = Dict();
    params["express"] = express;
    params["res_funs"] = [res_fun for i in express];
    params["labels"] = labels;
    return params;
end
parse_params(expres::Chemostat.ExpRess.ExpRes, res_fun, label) =
    parse_params([expres], res_fun, [label]);
parse_params(express::Dict{String, Chemostat.ExpRess.ExpRes}, res_fun, labels) =
    let ks = sort(collect(keys(express)))
        return parse_params([express[k] for k in ks], res_fun, labels)
    end
