module Models

    using DataFrames;
    using CSV;


    """
        Returns a toy model just like the used by Cossio...
    """
    function load_toymodel(;M = 1000, Stub = 5, CSe = 10)

        ###  r1  r2  r3  Wt  St ExS ExW Obj Man ##
        S = sparse([-1   0   0   0   1   0   0   0   0  ## S
                     2  -1  -1   0   0   0   0   0   0  ## P
                     0   1   0   1   0   0   0   0   0  ## W
                     2   0  18   0   0   0   0  -1  -1  ## E
                     0   0   0  -1   0   0   1   0   0  ## We
                     0   0   0   0  -1   1   0   0   0])## Se

        rxns = DataFrame();
        rxns[:id] =          ["r1" , "r2", "r3", "Wt", "St","ExS","ExW","Obj","Man"];
        rxns[:ub] = Float64.([  M  ,  M  ,  M  ,  M  ,  Stub ,  M  ,  M  ,  M  , 0   ]);
        rxns[:lb] = Float64.([  0  , -M  ,  0  , -M  ,  -M , -M  , -M  ,  0  , 0   ]);
        rxns[:ap] = Float64.([ 0.5 , 0.1 ,  15 , 0.1 , 0.1 ,  0  ,  0  ,  0  , 0   ]);
        rxns[:an] = Float64.([  0  , 0.1 ,  0  , 0.1 , 0.1 ,  0  ,  0  ,  0  , 0   ]);
        rxns[:t]  =          [  0  ,  0  ,  0  ,  1  ,  1  ,  0  ,  0  ,  0  , 0   ];

        mets = DataFrame();
        mets[:id] =         [ "S" , "P" , "W" , "E" , "We" , "Se"];
        mets[:c] = Float64.([  0  ,  0  ,  0  ,  0  ,  0   ,  CSe ])

        return S, mets, rxns;
    end

    """
        load a ecoli cor metabolic model, the version 1 (v1)
    """
    function load_ecoli_v1(; models_dir_path = Pkg.dir() * "/Chemostat/Models/ecoli_v1")

        S = CSV.read("$models_dir_path/ecoli_s.csv";
            delim = ",", allowmissing = :none);
        mets = CSV.read("$models_dir_path/ecoli_mets.csv";
            delim = ",", allowmissing = :none);
        rxns = CSV.read("$models_dir_path/ecoli_rxns.csv";
            delim = ",", allowmissing = :none);
        return sparse(convert(Matrix,S)),mets, rxns;

    end

end  # module Models
