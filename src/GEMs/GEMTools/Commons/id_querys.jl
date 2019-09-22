id(df::DataFrame, ider) = df[parse_ider(df, ider), id_key];

id_equal_to(df::DataFrame, id::String) = parse_ider(df, id);

ids(df::DataFrame) = df[id_key];
ids(df::DataFrame, ider, iders...) = df[parse_ider(df, ider, iders), id_key];

ids_starting_with(df::DataFrame, s::String) = find((id) -> startswith(id,s), df[id_key]);
ids_starting_with(df, s,ss...) = get_union(df, ids_starting_with, s, ss);

ids_ending_with(df::DataFrame, s::String) = find((id) -> endswith(id,s), df[id_key]);
ids_ending_with(df, s,ss...) = get_union(df, ids_ending_with, s, ss);

ids_containing(df::DataFrame, s::String) = find((id) -> contains(id,s), df[id_key]);
ids_containing(df, s,ss...) = get_union(df, ids_containing, s, ss);

ids_equals_to(df::DataFrame, s::String) = [id_equal_to(df, s)];
ids_equals_to(df, s, ss...) = get_union(df, ids_equals_to, s, ss);

ids_not_starting_with(df::DataFrame, s::String) = find((id) -> !startswith(id,s), df[id_key]);
ids_not_starting_with(df, s,ss...) =  get_intersect(df, ids_not_starting_with, s, ss);

ids_not_ending_with(df::DataFrame, s::String) = find((id) -> !endswith(id,s), df[id_key]);
ids_not_ending_with(df, s,ss...) = get_intersect(df, ids_not_ending_with, s, ss);

ids_not_containing(df::DataFrame, s::String) = find((id) -> !contains(id,s), df[id_key]);
ids_not_containing(df, s,ss...) = get_intersect(df, ids_not_containing, s, ss);

ids_not_equals_to(df::DataFrame, s::String) = find(!isequal(s), df[id_key]);
ids_not_equals_to(df, s,ss...) = get_intersect(df, ids_not_equals_to, s, ss);
