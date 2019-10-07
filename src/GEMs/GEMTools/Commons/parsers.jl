"""
    Parse any identifier to index!!!
"""
parse_ider(df, indx::Int) = indx;
parse_ider(df, id::String) = begin indx = findfirst(df[id_key], id);
    indx == 0 ? error("Id '$(id)' not found!!!"): indx;
end;

function parse_ider(df, ider, iders...)
    iders = [parse_ider(df, i) for i in collect_iders(ider, iders)];
    if length(iders) == 1 return first(iders) else iders end;
end
