function fba_chemostat(S, mets, rxns, ξ; ϕub = 1.0,
    multi_obj_factor = 10^5,
    verbose = false)
    @assert all(size(S) .== (size(mets,1),size(rxns,1)));
    @assert allunique(rxns[:id]);
    @assert allunique(mets[:id]);
    m, n = size(S);

    #Model
    model = JuMP.Model();
    if verbose
        JuMP.setsolver(model, Gurobi.GurobiSolver());
    else
        JuMP.setsolver(model, Gurobi.GurobiSolver(OutputFlag = 0));
    end

    #variables x [r+, r-, u+, u-, z, ϕ]
    x = Vector{JuMP.Variable}();
    pinflxs = Vector{JuMP.Variable}();#rs+
    ninflxs = Vector{JuMP.Variable}();#rs-
    for i in 1:n
        var = @variable(model, basename = "p_$(rxns[:id][i])");
        push!(pinflxs, var);
        push!(x, var);
        var = @variable(model, basename = "n_$(rxns[:id][i])");
        push!(ninflxs, var);
        push!(x, var);
    end
    poutflxs = Vector{JuMP.Variable}();#us+
    noutflxs = Vector{JuMP.Variable}();#us+
    for i in 1:m
        var = @variable(model, basename = "p_$(mets[:id][i])t");
        push!(poutflxs, var);
        push!(x, var);
        var = @variable(model, basename = "n_$(mets[:id][i])t");
        push!(noutflxs, var);
        push!(x, var);
    end
    z = @variable(model, basename = "z");#z
    push!(x, z);
    ϕ = @variable(model, basename = "ϕ");#ϕ
    push!(x, ϕ);

    #Mass Balance constraints
    W = [S            -S             speye(m)   -speye(m)    mets[:y]   spzeros(m)
         rxns[:ap]'    rxns[:an]'    zeros(m)'   zeros(m)'   0          -1        ];
    b = [mets[:e] ;0];
    for i in 1:m + 1
        @constraint(model, W[i,:]' * x == b[i]);
    end

    #Bound contraints
    for i in 1:n
        @constraint(model, pinflxs[i] >= 0);
        @constraint(model, pinflxs[i] <= rxns[:ub][i])
        @constraint(model, ninflxs[i] >= 0);
        @constraint(model, ninflxs[i] <= -rxns[:ub][i])
    end
    for i in 1:m
        @constraint(model, poutflxs[i] >= 0);
        @constraint(model, poutflxs[i] <= min(mets[:V][i], mets[:c][i]/ξ));#min(c / ξ, ub)
        @constraint(model, noutflxs[i] >= 0);
        @constraint(model, noutflxs[i] <= -mets[:L][i]);
    end
    @constraint(model, z >= 0);
    @constraint(model, ϕ >= 0);
    @constraint(model, ϕ <= ϕub);

    #Objective
    @objective(model, Max, multi_obj_factor * z - ϕ);

    #Solving
    solve(model; suppress_warnings = true);

    #checking error
    @assert !isnan(getvalue(z));
    @assert !isnan(getvalue(ϕ));

    return FBAResult_v2(ξ, getvalue(z), getvalue(ϕ),
        getvalue.(pinflxs) - getvalue.(ninflxs),
        getvalue.(poutflxs) - getvalue.(noutflxs));

end
