### Code derived from MaxEntChemostat2018 Cossios package.
# gurobi_problem -------------------------------------------------------------------------
function gurobi_problem(S,mets,rxns)
    m, n = size(S)

    # variables
    x = zeros(2n + m + 2)   # [r+, r-, u, μ, ϕ], all the variables

    upper::Vector{Float64} = [rxns[:pub]; -rxns[:nub]; mets[:V]; Inf; 1.0] # upper bounds
    lower::Vector{Float64} = [rxns[:plb]; -rxns[:nlb]; mets[:L]; 0.0; 0.0] # lower bounds

    @assert length(upper) == length(x) == m + 2n + 2
    @assert length(lower) == length(x) == m + 2n + 2

    # equality constrains
    W = sparse([ S              -S          speye(m)    -mets[:y]   spzeros(m)
                 rxns[:ap]'     rxns[:an]'  zeros(m)'  0           -1 ])

    @assert Base.size(W) == (m + 1, length(x))

    # the problem has the form:
    # max μ s.t. W⋅x = [e,0] and 0 ≤ x ≤ upper.
    # with the secondary objective: min ϕv
    LP = Gurobi.gurobi_model(GurobiEnv(), sense = :maximize,
                             Aeq = W, beq = [collect(mets[:e]); 0],
                             lb = lower, ub = upper, f = zeros(x))

    gurobi_set_multiobj_n!(LP, 2)
    gurobi_set_multiobj!(LP, 0, [zeros(2n + m); 1;  0], 10, 1.0)  # max μ
    gurobi_set_multiobj!(LP, 1, [zeros(2n + m); 0; -1], 5,  1.0)  # min ϕ

    return LP
end

"Sets the number of objectives in a Gurobi multi-objective optimization"
gurobi_set_multiobj_n!(gurobi_model::Gurobi.Model, n::Int) = Gurobi.set_intattr!(gurobi_model, "NumObj", n)

"Sets an additional objective in a Gurobi multi-objective optimization"
function gurobi_set_multiobj!(gurobi_model::Gurobi.Model, i::Int, c, priority, weight)
    @assert length(c) == Gurobi.num_vars(gurobi_model)
    oldi = Gurobi.get_int_param(gurobi_model, "ObjNumber")
    Gurobi.set_int_param!(gurobi_model, "ObjNumber", i)
    Gurobi.set_dblattrarray!(gurobi_model, "ObjN", 1, Gurobi.num_vars(gurobi_model), c)
    Gurobi.set_intattr!(gurobi_model, "ObjNPriority", priority)
    Gurobi.set_dblattr!(gurobi_model, "ObjNWeight", weight)
    Gurobi.set_int_param!(gurobi_model, "ObjNumber", oldi)
end

"Changes constrain RHS in a Gurobi optimization"
function gurobi_set_rhs!(gurobi_model::Gurobi.Model, rhs::Vector{Float64})
    @assert Gurobi.num_constrs(gurobi_model) == length(rhs)
    Gurobi.set_dblattrarray!(gurobi_model, "RHS", 1, Gurobi.num_constrs(gurobi_model), rhs)
end

"Sets up Gurobi environment options"
function GurobiEnv()
    env = Gurobi.Env()
    # suppress Gurobi logging output
    Gurobi.setparam!(env, "OutputFlag", 0)
    Gurobi.setparam!(env, "Quad", 1)
    Gurobi.setparam!(env, "Method", 4)
    Gurobi.setparam!(env, "FeasibilityTol", 1e-9)
    Gurobi.setparam!(env, "OptimalityTol", 1e-9)
    Gurobi.setparam!(env, "MarkowitzTol", 0.9)
    return env
end

"""Changes lower bounds of variables in a Gurobi optimization, from MaxEntChemostat2018"""
function gurobi_set_lb!(gurobi_model::Gurobi.Model, lbs::Vector{Float64})
    @assert length(lbs) == Gurobi.num_vars(gurobi_model)
    Gurobi.set_dblattrarray!(gurobi_model, "LB", 1, Gurobi.num_vars(gurobi_model), lbs)
end

"""Changes upper bounds of variables in a Gurobi optimization, from MaxEntChemostat2018"""
function gurobi_set_ub!(gurobi_model::Gurobi.Model, ubs::Vector{Float64})
    @assert length(ubs) == Gurobi.num_vars(gurobi_model)
    Gurobi.set_dblattrarray!(gurobi_model, "UB", 1, Gurobi.num_vars(gurobi_model), ubs)
end

# model_solve ----------------------------------------------------------------------------
"""
    Create a unsolved Linear Programming problem, from MaxEntChemostat2018,
    from MaxEntChemostat2018
"""
function model_solve!(LP, S, mets, rxns, ξ)
    @assert 0 ≤ ξ < Inf
    m, n = size(S)

    upper::Vector{Float64} = [rxns[:pub]; -rxns[:nub]; mets[:V]; Inf; 1.]     # upper bounds
    view(upper, 2n + (1:m)) .= chemostat_bound.(mets[:V], mets[:c], ξ) # exchanges
    gurobi_set_ub!(LP, upper)

    lower::Vector{Float64} = [rxns[:plb]; -rxns[:nlb]; mets[:L]; 0.0; 0.0]     # lower bounds
    gurobi_set_lb!(LP, lower)

    if gurobi_solve!(LP)
        return FBASolution(Gurobi.get_solution(LP), S, mets, rxns, ξ);
    else
        error("Gurobi solver failed to optimize fba at ξ $ξ !!!");
    end
end

"Solves a Gurobi model. Returns true if model was optimized succesfully."
function gurobi_solve!(gurobi_model::Gurobi.Model)::Bool
    Gurobi.update_model!(gurobi_model)
    Gurobi.optimize(gurobi_model)
    return Gurobi.get_status(gurobi_model) == :optimal
end

"""
Get the bound of an uptake reaction.
See http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1005835
from MaxEntChemostat2018
"""
function chemostat_bound(b, c, ξ)::Float64
    @assert 0 ≤ ξ < Inf
    if b > 0.0
        return c == 0 ? 0. : min(b, c / ξ)
    else
        return b;
    end
end
