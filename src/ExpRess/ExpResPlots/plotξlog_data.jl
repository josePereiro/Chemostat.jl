function plotξlog_data!(p::Plots.Plot,
        express::Vector{Chemostat.ExpRess.ExpRes}, mets::Vector,
        ξ_lb::Number, ξ_ub::Number,
        res_funs::Vector{<:Function}, labels::Vector{String};
        color = :auto,
        lw = default_line_width)
    ξ_lb = Float64(ξ_lb);
    ξ_ub = Float64(ξ_ub);
    for i in 1:length(express)
        Xs = ExpRess.get_ξs(express[i]);
        Xsi = find(ξ_lb .<= Xs .<= ξ_ub);
        if length(Xs) <= 1 error("A single point can't be plot!!!") end
        Ys = res_funs[i](express[i], mets[i]);
        p = Plots.plot!(p, Xs[Xsi], Ys[Xsi], label = labels[i], xaxis = :log,
            lw = lw, color = resolve_color(color, i));
    end
    return p;
end

function plotξlog_data!(p::Plots.Plot,
        express::Vector{Chemostat.ExpRess.ExpRes},
        ξ_lb::Number, ξ_ub::Number,
        res_funs::Vector{<:Function}, labels::Vector{String};
        color = :auto,
        lw = default_line_width)
    ξ_lb = Float64(ξ_lb);
    ξ_ub = Float64(ξ_ub);
    for i in 1:length(express)
        Xs = ExpRess.get_ξs(express[i]);
        Xsi = find(ξ_lb .<= Xs .<= ξ_ub);
        if length(Xs) <= 1 error("A single point can't be plot!!!") end
        Ys = res_funs[i](express[i]);
        p = Plots.plot!(p, Xs[Xsi], Ys[Xsi], label = labels[i], xaxis = :log,
            lw = lw, color = resolve_color(color, i));
    end
    return p;
end
