using CSV;
using DataFrames;
using Chemostat;

#Defaults
DEFAULT_ϕ = 1e-4;
DEFAULT_MAINTINANCE_DEMAND_FLUX_VALUE = 1;

#DirName
ECOLI_V1_MODEL_DIR_NAME = "ecoli_v1";


"""
    load the ecoli core network in a v1 format
"""
function load_ecoli_v1(; model_data_dir = "$(Chemostat.ECOLI_MODELS_DATA_DIR)/$ECOLI_V1_MODEL_DIR_NAME",
                        file_prefix = Chemostat.ECOLI_MODELS_DATA_FILES_PREFIX)

    S = CSV.read("$model_data_dir/$(file_prefix)_s.csv";
        delim = ",", allowmissing = :none);
    mets = CSV.read("$model_data_dir/$(file_prefix)_mets.csv";
        delim = ",", allowmissing = :none);
    rxns = CSV.read("$model_data_dir/$(file_prefix)_rxns.csv";
        delim = ",", allowmissing = :none);
    return sparse(convert(Matrix,S)),mets, rxns;

end
