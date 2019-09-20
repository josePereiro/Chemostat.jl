resolve_color(colors::Symbol, i) = colors;
resolve_color(colors::Vector, i) = length(colors) >= i > 0 ?
        colors[i] : :auto;
resolve_color(colors::ColorTypes.RGB) = colors;
