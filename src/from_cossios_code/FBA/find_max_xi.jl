### Code derived from MaxEntChemostat2018 Cossios package.
# find_max_xi --------------------------------------------------------------------------

"""
Returns the maximum value of ξ for which the model is
feasible, to .within tolerance 'find_max_xi_tol'.
"""
function find_max_xi!(LP, S, mets, rxns)
    @assert find_max_xi_tol > 0
    @assert find_unfeasible_xi_ξ0 < find_max_xi_ξ_ub;

    # find_unfeasible_xi
    unfeasible_ξ = find_unfeasible_xi_ξ0;
    while true
        try model_solve!(LP, S, mets, rxns, unfeasible_ξ)
            if unfeasible_ξ >= find_max_xi_ξ_ub
                warn("find_max_xi_ξ_ub = $(find_max_xi_ξ_ub) reached!!! This is save to ignore if the "*
                    "ξ value is high enough for your implementation. But it could "*
                    "indicate an unbound model!!!")
                return find_max_xi_ξ_ub;
            else
                unfeasible_ξ += find_unfeasible_xi_Δξ;
            end
        catch
            break;
        end
    end
    feasible_ξ = 0.0;

    # find_max_xi
    while true
        temp_ξ = (feasible_ξ + unfeasible_ξ)/2;
        if unfeasible_ξ - feasible_ξ ≤ find_max_xi_tol
            return feasible_ξ;
        else
            try model_solve!(LP, S, mets, rxns, temp_ξ)
                feasible_ξ = temp_ξ;
            catch
                unfeasible_ξ = temp_ξ;
            end
        end
    end
end

find_max_xi(S, mets, rxns) = find_max_xi!(gurobi_problem(S, mets, rxns), S, mets, rxns);
