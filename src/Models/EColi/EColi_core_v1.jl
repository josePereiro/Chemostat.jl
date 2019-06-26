using CSV;
using DataFrames;
using Chemostat;

#Defaults
# DEFAULT_ϕ = 1e-4;
# DEFAULT_MAINTINANCE_DEMAND_FLUX_VALUE = 1;

"""
    load the ecoli core network in a v1 format
"""
function load_ecoli_v1(; model_data_dir = Chemostat.ECOLI_CORE_V1_MODEL_DATA_DIR,
                        file_prefix = Chemostat.ECOLI_MODELS_DATA_FILES_PREFIX)

    sto = CSV.read(joinpath(model_data_dir, file_prefix * "_s.csv"),
        allowmissing=:none, types=[Int, Int, Float64, String, String]);
    mets = CSV.read(joinpath(model_data_dir, file_prefix * "_mets.csv");
        delim = ",", allowmissing = :none);
    rxns = CSV.read(joinpath(model_data_dir, file_prefix * "_rxns.csv");
        delim = ",", allowmissing = :none);
    S = sparse(sto[:i], sto[:k], sto[:s])
    return S,mets, rxns;
end
