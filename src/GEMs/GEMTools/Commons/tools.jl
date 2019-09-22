"""
    Collect recursivelly all the T elements of the give parameters.
    If any other eltype if found, it rised an error!!!
"""
function deep_collect(T::Type, o)::Tuple{Vararg{T}}
    col = [];
    # Base
    if isa(o,T)
        return tuple(o);
    elseif typeof(o) != eltype(o)
        for e in o
            push!(col,deep_collect(T,e)...)
        end
    else
        error("Uncompatible type $(eltype(o)), expected $(T)!!!");
    end
    return tuple(col...);
end
deep_collect(T::Type, oo...) = deep_collect(T,oo);
collect_iders(ider, iders...) = deep_collect(Ider_type, ider, iders...);

get_union(data, fun, s, ss) = union([fun(data, i) for i in deep_collect(String, s, ss)]...);
get_intersect(data, fun, s, ss) = intersect([fun(data, i) for i in deep_collect(String, s, ss)]...);
