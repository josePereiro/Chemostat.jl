function show_info(df, keys...)

    println("size: ", size(df));

    for key in keys
        println("_______________");
        data = df[key];
        println(key, ": type ", eltype(data));
        println();

        println("unique elements");
        for v in sort(unique(data))
            println(v);
        end

    end

end
show_info(df) = show_info(df, keys(df)...);
