function get_data(data, col, id, ids...)
    ids = parse_ider(data, id, ids...);
    return data[ids, col];
end
