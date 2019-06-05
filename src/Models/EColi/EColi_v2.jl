using CSV;
using DataFrames;
using Chemostat;

#Defaults
# DEFAULT_ϕ = 1e-4;
# DEFAULT_MAINTINANCE_DEMAND_FLUX_VALUE = 8e-5;

#DirName
ECOLI_V2_MODEL_DIR_NAME = "ecoli_v2";


"""
    load the ecoli core network in a v2 format.
    Returns stoichiometric matrix and DataFrames mets and rxns
"""

function load_ecoli_v2()

    sto, mets, rxns = load_ecoli_dataframes()

    # no infinities
    rxns[:lb] .= max.(rxns[:lb], -1000)
    rxns[:ub] .= min.(rxns[:ub], 1000)
    mets[:L] .= max.(mets[:L], -1000)
    mets[:V] .= min.(mets[:V], 1000)
    mets[:c] .= min.(mets[:c], 100000)

    S = sparse(sto[:i], sto[:k], sto[:s])

    return S, mets, rxns
end

function load_ecoli_dataframes(;model_data_dir = "$(Chemostat.ECOLI_MODELS_DATA_DIR)/$ECOLI_V2_MODEL_DIR_NAME",
                        file_prefix = Chemostat.ECOLI_MODELS_DATA_FILES_PREFIX)

    sto = CSV.read("$model_data_dir/$(file_prefix)_s.csv", allowmissing=:none, types=[Int, Int, Float64, String, String]);
    mets = CSV.read("$model_data_dir/$(file_prefix)_mets.csv", allowmissing=:none, types=[String, Float64, Float64, Float64, Float64, Float64]);
    rxns = CSV.read("$model_data_dir/$(file_prefix)_rxns.csv", allowmissing=:none, types=[String, Float64, Float64, Float64, Float64]);

    return sto, mets, rxns
end
