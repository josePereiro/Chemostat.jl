"""
    This module performs Flux Balance Analysis (FBA)
    assembled to the Chemostat model 
    
    The metabolic network has this layout:
    
    m: metabolites
    n: reactions
    S: stoichiometric matrix (m,n)
    mets: metabolites parameters. It is a DataFrame with m rows containing:
        id: metabolite identifier
        c: the metabolite concentration in the feed medium
        y: the metabolite coefficient in the objective reactions (biomass)
        e: the metabolite coefficient in the maintenance demand reaction
        L: the lower bound of the exchange reaction
        V: the upper bound of the exchange reaction  
        (you can add as many other fields as you want)

    rxns: reactions parameters. It is a DataFrame with n rows containing:
        id: reactions identifier
        an: cost associated with the backward (negative) reaction
        ap: cost associated with the forward (positive) reaction
        lb: the lower bound of the reactions
        ub: the upper bound of the reactions

    The FBA problem has the form:
        max μ 
        s.t. 
            W⋅x = [e,0] and 0 ≤ x ≤ upper.
            x = [r+, r-, u, μ, ϕ]

    the meaning of stuff:
        u > 0 (up-taking)
        u < 0 (excretion)

        y > 0 (it is consumed in biomass)
        y < 0 (it is produced in biomass)

        e > 0 (it is consumed in demand)
        e < 0 (it is produced in demand)
"""
module FBA

using Chemostat;
using DataFrames;
using Gurobi;

include("types.jl");
include("params.jl");
include("gurobi_code.jl");
include("find_max_xi.jl");
include("non_zero_model.jl");
include("fba_wrappers.jl");
include("find_max_xi_wrappers.jl");
include("non_zero_model_wrappers.jl");


end  # module FBA
