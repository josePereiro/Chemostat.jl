module Tools

using DataFrames;

function ids_contains(ids, id; casesen = false)
    return ids[idsindx_contains(ids, id; casesen = casesen)];
end
function ids_endswith(ids, id; casesen = false)
    return ids[idsindx_endswith(ids, id; casesen = casesen)]
end
function idsindx_contains(ids, id; casesen = false)
    if casesen
        return find((rid) -> contains(rid, id), ids);
    end
    id = uppercase(id);
    return find((rid) -> contains(uppercase(rid),id), ids);
end
function idsindx_endswith(ids, id; casesen = false)
    if casesen
        return find((rid) -> contains(rid, id), ids);
    end
    id = uppercase(id);
    return find((rid) -> contains(uppercase(rid),id), ids);
end
function fluxes_nz(fvs, fids)
    @assert length(fvs) == length(fids)
    nz = find((fv) -> fv != 0, fvs);
    return [(nzi ,fids[nzi], fvs[nzi]) for nzi in nz];
end
function printlnall(col)
    for c in col
        println(c);
    end
end
function logrange(si::Int, ei; base = collect(1:9))
    col = [];
    for i in si:(ei - 1)
        push!(col, ((base)*(10.0 ^ i))...);
    end
    return col;
end

function printlnall(col, info; f = 40)
    for i in 1:length(col)
        if i == 1
            println(info);
        elseif i % f == 0
            println();
            println(info);
        end
        println(col[i]);
    end
end

export indexof;
function indexof(df::DataFrame, id)
    for i in 1:size(df,1)
        if df[:id][i] == id
            return i;
        end
    end
    return -1;
end

function findfiles(fun, dir)::Vector{AbstractString}

    # Results
    res = Vector{AbstractString}();

    # dir files
    fs = files(dir);
    for f in fs
        if fun(f)
            push!(res, f);
        end
    end

    # sub dirs
    sds = subdirs(dir);
    for sd in sds
        push!(res, findfiles(fun, sd)...);
    end

    return res;
end

function finddirs(fun, dir)::Vector{AbstractString}

    # Results
    res = Vector{AbstractString}();

    # sub dirs
    sds = subdirs(dir);
    for sd in sds
        if fun(sd)
            push!(res, sd)
        end
        push!(res, finddirs(fun, sd)...);
    end

    return res;
end

function subdirs(dir)
    return filter((name) -> isdir(name), joinpath.(dir,readdir(dir)));
end
function files(dir)
    return filter((name) -> isfile(name), joinpath.(dir,readdir(dir)));
end

end
