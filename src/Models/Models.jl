module Models

using Chemostat;
using DataFrames;
using CSV;

export MODELS_DATA_DIR;
MODELS_DATA_DIR = "$(Pkg.dir())/Chemostat/ModelsData";

include("EColi/EColi.jl");
include("ToyModel/ToyModel.jl");

end  # module Models
