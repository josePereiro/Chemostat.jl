module Commons

using DataFrames;

"""
    Type of the identifiers
"""
Ider_type = Union{String, Int};

"""
    Collect recursivelly all the T elements of the give parameters.
    If any other eltype if found, it rise an error!!!
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

"""
    Parse any identifier to index!!!
"""
parse_ider(data, indx::Int) = indx;
parse_ider(data, id::String) = begin indx = findfirst(data[:id], id);
    indx == 0 ? error("Id $(id) not found!!!"): indx;
end;
parse_ider(data, ider, iders...) = [parse_ider(data, i)
    for i in collect_iders(ider, iders)];

get_union(data, fun, s, ss) = union([fun(data, i) for i in deep_collect(String, s, ss)]...);
get_intersect(data, fun, s, ss) = intersect([fun(data, i) for i in deep_collect(String, s, ss)]...);

id(data, ider) = data[:id][parse_ider(data, ider)];
id_equal_to(data, id::String) = parse_ider(data, id);
ids(data) = data[:id];
ids(data, ider, iders...) = ids()[parse_ider(data, ider, iders)];


ids_starting_with(data, s::String) = find((id) -> startswith(id,s), data[:id]);
ids_starting_with(data, s,ss...) = get_union(data, ids_starting_with, s, ss);

ids_ending_with(data, s::String) = find((id) -> endswith(id,s), data[:id]);
ids_ending_with(data, s,ss...) = get_union(data, ids_ending_with, s, ss);

ids_containing(data, s::String) = find((id) -> contains(id,s), data[:id]);
ids_containing(data, s,ss...) = get_union(data, ids_containing, s, ss);

ids_equals_to(data, s::String) = [id_equal_to(data, s)];
ids_equals_to(data, s, ss...) = get_union(data, ids_equals_to, s, ss);

ids_not_starting_with(data, s::String) = find((id) -> !startswith(id,s), data[:id]);
ids_not_starting_with(data, s,ss...) =  get_intersect(data, ids_not_starting_with, s, ss);

ids_not_ending_with(data, s::String) = find((id) -> !endswith(id,s), data[:id]);
ids_not_ending_with(data, s,ss...) = get_intersect(data, ids_not_ending_with, s, ss);

ids_not_containing(data, s::String) = find((id) -> !contains(id,s), data[:id]);
ids_not_containing(data, s,ss...) = get_intersect(data, ids_not_containing, s, ss);

ids_not_equals_to(data, s::String) = find(!isequal(s), data[:id]);
ids_not_equals_to(data, s,ss...) = get_intersect(data, ids_not_equals_to, s, ss);


# Setters

function set_data!(data, row, col, val)
    row = parse_ider(data, row);
    data[row, col] = val;
end

# Getters

function get_data(data, row, col)
    row = parse_ider(data, row);
    return data[row, col];
end

end
