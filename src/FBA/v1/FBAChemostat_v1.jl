export fba_chemostat_v1;
function fba_chemostat_v1(S, mets, rxns, ξ;
        objt_indx = size(rxns,1),
        man_demand_indx = size(rxns,1) - 1,
        man_demand_flux_value = 1,
        ϕub::Float64 = 1.0,
        multi_obj_factor = 10^5,
        verbose = false)

    @assert all(size(S) .== (size(mets,1),size(rxns,1)));
    @assert allunique(rxns[:id]);
    @assert allunique(mets[:id]);

    #Model
    model = JuMP.Model();
    if verbose
        JuMP.setsolver(model, Gurobi.GurobiSolver());
    else
        JuMP.setsolver(model, Gurobi.GurobiSolver(OutputFlag = 0));
    end
    rxnscount = size(rxns,1);
    metscount = size(mets,1);

    #Variables
    pfluxes = Vector{JuMP.Variable}();
    nfluxes = Vector{JuMP.Variable}();
    for r in 1:rxnscount
        var = @variable(model, basename = "p_$(rxns[:id][r])");
        push!(pfluxes, var);
        var = @variable(model, basename = "n_$(rxns[:id][r])");
        push!(nfluxes, var);
    end
    obj = pfluxes[objt_indx];#Biomass production rate
    main_dem = pfluxes[man_demand_indx];#Maintinance Demand
    ϕ = @variable(model, basename = "ϕ");#Total cost

    #constraints
    #Mass balance
    for m in 1:metscount
        @constraint(model, S[m,:]' * (pfluxes - nfluxes) == 0);
    end

    #Cost
    @constraint(model, rxns[:ap]'* pfluxes + rxns[:an]' * nfluxes <= ϕ);

    #Bound Constraints
    for ri in 1:rxnscount

        ub = rxns[:ub][ri];
        lb = -rxns[:lb][ri];

        if rxns[:t][ri] > 0
            c = maximum(mets[:c][S[:,ri].nzind]);
            ub = min(c / ξ, ub);
        end

        #Maintinance demand
        if ri == man_demand_indx
            @constraint(model, pfluxes[ri] >= man_demand_flux_value);
            @constraint(model, pfluxes[ri] <= man_demand_flux_value);
            @constraint(model, nfluxes[ri] >= 0);
            @constraint(model, nfluxes[ri] <= 0);
        else
            @constraint(model, pfluxes[ri] >= 0);
            @constraint(model, pfluxes[ri] <= ub);
            @constraint(model, nfluxes[ri] >= 0);
            @constraint(model, nfluxes[ri] <= lb);
        end
    end
    @constraint(model, ϕ >= 0)
    @constraint(model, ϕ <= ϕub);

    #Objectives
    @objective(model, Max, multi_obj_factor * obj - ϕ);

    #Info
    verbose && println(model);

    #Solving
    solve(model; suppress_warnings = true);

    #checking error
    @assert !isnan(getvalue(obj));
    @assert !isnan(getvalue(ϕ));

    return FBAResult_v1(ξ, model, pfluxes, nfluxes, obj, ϕ, main_dem, S, rxns, mets);

end
