module EP

import DataFrames: DataFrame, eachrow
import Chemostat;
import Chemostat.FBA: chemostat_bound;

include("params.jl");
include("types.jl");
include("Anna_code/MetabolicEP.jl"); # Anna Code
include("from_TruncatedNormal.jl"); # from_TruncatedNormal
include("ep_cossio.jl");
include("ep_wrappers.jl");
include("tools.jl");


end # EP
