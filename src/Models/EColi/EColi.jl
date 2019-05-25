module EColi


using Chemostat.Models;

# A commom prefix for any ecoli model file
export MODEL_DATA_FILES_PREFIX;
MODEL_DATA_FILES_PREFIX = "ecoli";
# The path till the EColi models data folder
export ECOLI_MODELS_DATA_DIR;
ECOLI_MODELS_DATA_DIR = "$MODELS_DATA_DIR/EColi";

include("EColi_v1.jl")



end  # module EColi
