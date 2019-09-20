# s
function plot_ξ_vs_s(express, mets, ξ_lb = -Inf, ξ_ub = Inf;
        title = "ξ vs s", labels = get_label("s", mets, express),
        color = :auto,
        lw = default_line_width)
    params = parse_params(express, mets, ExpRess.get_ss, labels);
    plotξlog_data!(Plots.plot(title = title, xlabel = ξlabel(), ylabel = Slabel()),
            params["express"], params["ids"], ξ_lb, ξ_ub,
            params["res_funs"], params["labels"],
            lw = lw, color = color);
end

# u
function plot_ξ_vs_u(express, mets, ξ_lb = -Inf, ξ_ub = Inf;
        title = "ξ vs u", labels = get_label("u", mets, express),
        color = :auto,
        lw = default_line_width)
    params = parse_params(express, mets, ExpRess.get_us, labels);
    plotξlog_data!(Plots.plot(title = title, xlabel = ξlabel(), ylabel = Ulabel()),
            params["express"], params["ids"], ξ_lb, ξ_ub,
            params["res_funs"], params["labels"],
            lw = lw, color = color);
end

# r
function plot_ξ_vs_r(express, mets, ξ_lb = -Inf, ξ_ub = Inf;
        title = "ξ vs r", labels = get_label("r", mets, express),
        color = :auto,
        lw = default_line_width)
    params = parse_params(express, mets, ExpRess.get_rs, labels);
    plotξlog_data!(Plots.plot(title = title, xlabel = ξlabel(), ylabel = Rlabel()),
            params["express"], params["ids"], ξ_lb, ξ_ub,
            params["res_funs"], params["labels"],
            lw = lw, color = color);
end

# μ
function plot_ξ_vs_μ(express, ξ_lb = -Inf, ξ_ub = Inf;
        title::String = "ξ vs μ",
        labels = get_label("μ", express),
        color = :auto,
        lw = default_line_width)
    params = parse_params(express, ExpRess.get_μs, labels)
    plotξlog_data!(Plots.plot(title = title, xlabel = ξlabel(), ylabel = μlabel()),
        params["express"], ξ_lb, ξ_ub,
        params["res_funs"], params["labels"],
        lw = lw, color = color);
end

# D
function plot_ξ_vs_D(express, ξ_lb = -Inf, ξ_ub = Inf;
        title::String = "ξ vs D",
        labels = get_label("D", express),
        color = :auto,
        lw = default_line_width)
    params = parse_params(express, ExpRess.get_Ds, labels)
    plotξlog_data!(Plots.plot(title = title, xlabel = ξlabel(), ylabel = Dlabel()),
        params["express"], ξ_lb, ξ_ub,
        params["res_funs"], params["labels"],
        lw = lw, color = color);
end

# Xv
function plot_ξ_vs_Xv(express, ξ_lb = -Inf, ξ_ub = Inf;
        title::String = "ξ vs Xv",
        labels = get_label("Xv", express),
        color = :auto,
        lw = default_line_width)
    params = parse_params(express, ExpRess.get_Xvs, labels)
    plotξlog_data!(Plots.plot(title = title, xlabel = ξlabel(), ylabel = Xvlabel()),
        params["express"], ξ_lb, ξ_ub,
        params["res_funs"], params["labels"],
        lw = lw, color = color);
end

# ϕ
function plot_ξ_vs_ϕ(express, ξ_lb = -Inf, ξ_ub = Inf;
        title::String = "ξ vs ϕ",
        labels = get_label("ϕ", express),
        color = :auto,
        lw = default_line_width)
    params = parse_params(express, ExpRess.get_ϕs, labels)
    plotξlog_data!(Plots.plot(title = title, xlabel = ξlabel(), ylabel = ϕlabel()),
        params["express"], ξ_lb, ξ_ub,
        params["res_funs"], params["labels"],
        lw = lw, color = color);
end
