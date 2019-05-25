module ToyModel

using Chemostat.Models;
using DataFrames;

"""
    Returns a v1 toy model ...
"""
function load_toymodel_v1(;M = 1000, Stub = 5, CSe = 10)

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

end  # module ToyModel
