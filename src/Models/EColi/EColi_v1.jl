module v1

    using CSV;
    using DataFrames;
    using Chemostat.Models.EColi;

    #Defaults
    DEFAULT_ϕ = 1e-4;
    DEFAULT_MAINTINANCE_DEMAND_FLUX_VALUE = 8e-5;
    ECOLI_V1_MODEL_DIR_NAME = "ecoli_v1";


    """
        load the ecoli core netwotk in a v1 format
    """
    function load_ecoli_v1(; file_prefix = MODEL_DATA_FILES_PREFIX)

        S = CSV.read("$ECOLI_MODELS_DATA_DIR/$ECOLI_V1_MODEL_DIR_NAME/$(file_prefix)_s.csv";
            delim = ",", allowmissing = :none);
        mets = CSV.read("$ECOLI_MODELS_DATA_DIR/$ECOLI_V1_MODEL_DIR_NAME/$(file_prefix)_mets.csv";
            delim = ",", allowmissing = :none);
        rxns = CSV.read("$ECOLI_MODELS_DATA_DIR/$ECOLI_V1_MODEL_DIR_NAME/$(file_prefix)_rxns.csv";
            delim = ",", allowmissing = :none);
        return sparse(convert(Matrix,S)),mets, rxns;

    end


end  # module v1
