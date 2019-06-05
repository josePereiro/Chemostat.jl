using Chemostat
using JuMP;
using DataFrames;


@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

#
# # write your own tests here
# println("Testing EColi_v1...");
# println("Loading model");
# S ,mets, rxns = Chemostat.v1.Models.EColi.load_ecoli_v1();
# println("Done!!!")
#
# println();
# println("Testing FBA_v1 at ξ = 1e5");
# ξmax = 1e5;
# md = Chemostat.v1.Models.EColi.DEFAULT_MAINTINANCE_DEMAND_FLUX_VALUE; #8e-5
# cost = Chemostat.v1.Models.EColi.DEFAULT_ϕ;#1e-4
# fbares = Chemostat.v1.FBA.fba_chemostat_v1(S, mets, rxns, ξmax; ϕub = cost, man_demand_flux_value = md);
# println("Results")
# println("ϕ: $(getvalue(fbares.ϕ))");
# println("Obj: $(getvalue(fbares.obj))");
# println("Non zero tranport fluxes")
# display(filter((x) -> x[2] != 0 ,map((x,y) -> (x,y), rxns[:id][find((row) -> row[:t] > 0, eachrow(rxns))],
#     Chemostat.v1.FBA.flux.(fbares, rxns[:id][find((row) -> row[:t] > 0, eachrow(rxns))]))))
# println("Done");

# write your own tests here
println("Testing EColi_v2...");
println("Loading model");
S ,mets, rxns = Chemostat.v2.Models.EColi.load_ecoli_v2();
println("Done!!!")
prin


@test 1 == 1
