using Chemostat;
using CSV;

"""
    load the ecoli core network in a v1 format
"""
function load_ecoli_iaf1260(; model_data_dir = Chemostat.ECOLI_iAF1260_MODEL_ROOT_DIR,
                        file_prefix = Chemostat.ECOLI_MODELS_DATA_FILES_PREFIX)

    S = CSV.read(joinpath(model_data_dir, file_prefix * "_s.csv");
        delim = ",", allowmissing = :none);
    mets = CSV.read(joinpath(model_data_dir, file_prefix * "_mets.csv");
        delim = ",", allowmissing = :none);
    rxns = CSV.read(joinpath(model_data_dir, file_prefix * "_rxns.csv");
        delim = ",", allowmissing = :none);
    return sparse(S[:i], S[:k], S[:v]),mets, rxns;

end
