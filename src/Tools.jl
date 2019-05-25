module Tools

using DataFrames;

function log10interval(s::Int,e::Int)::Vector{Float64}
    @assert s < e;
    base = collect(1:9);
    its = log10(e) - s;
    r = base;
    for i in 1:its
        push!(r, (base*(10.0^i))...)
    end
    return r * 10.0^s;
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

end
