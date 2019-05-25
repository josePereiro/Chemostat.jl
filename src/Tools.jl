module Tools

using DataFrames;

function logrange(s,b,e)
    r = Vector{Float64}();
    v = s;
    i = 0;
    while v < e
        push!(r, collect(b^i:b^i:b^(i+1))...);
        v = pop!(r)*s;
        i += 1;
    end
    r = r * s;

    rr = Vector{Float64}();
    for i in 1:length(r)
        if r[i] <= e
            push!(rr,r[i])
        end
    end
    last(rr) != e && push!(rr,e)
    return rr;
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
