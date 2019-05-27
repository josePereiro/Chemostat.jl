using Chemostat
using JuMP;
using DataFrames;


@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

# write your own tests here
println("Testing EColi_v1...");
println("Loading model");
S ,mets, rxns = Chemostat.Models.EColi.v1.load_ecoli_v1();
println("Done!!!")

println();
println("Testing FBA_v1 at ξ = 1e5");
ξmax = 1e5;
md = Chemostat.Models.EColi.v1.DEFAULT_MAINTINANCE_DEMAND_FLUX_VALUE; #8e-5
cost = Chemostat.Models.EColi.v1.DEFAULT_ϕ;#1e-4
fbares = Chemostat.FBA.v1.fba_chemostat_v1(S, mets, rxns, ξmax; ϕub = cost, man_demand_flux_value = md);
println("Results")
println("ϕ: $(getvalue(fbares.ϕ))");
println("Obj: $(getvalue(fbares.obj))");
println("Non zero tranport fluxes")
display(filter((x) -> x[2] != 0 ,map((x,y) -> (x,y), rxns[:id][find((row) -> row[:t] > 0, eachrow(rxns))],
    Chemostat.FBA.v1.flux.(fbares, rxns[:id][find((row) -> row[:t] > 0, eachrow(rxns))]))))
println("Done");
@test 1 == 1
