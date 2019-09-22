function set_data!(df::DataFrame, col, val, row, rows...)
    rows = parse_ider(df, row, rows);
    df[rows, col] = val;
end
