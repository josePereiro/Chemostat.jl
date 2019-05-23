using Chemostat
@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

# write your own tests here
println(Chemostat.Models.load_ecoli_v1());
@test 1 == 1
