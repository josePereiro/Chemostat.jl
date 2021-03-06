function ReadMatrix(filename::String)

    X = matread(filename)
    key1=""
    if length(keys(X)) == 1
        key1 = collect(keys(X))[1]
    else
        for i in keys(X)
            if i == "model"
                key1 = i
                break
            end
        end
    end
    S = X[key1]["S"]
    M,N = size(S)
    b = vec(X[key1]["b"])
    c = vec(X[key1]["c"])
    lb = vec(X[key1]["lb"])
    ub = vec(X[key1]["ub"])
    if haskey(X[key1],"genes")
        genes = String[ string(X[key1]["genes"][i]) for i=1:length(X[key1]["genes"])]
    else
        genes = ["NA"]
    end
    if haskey(X[key1], "rxnGeneMat")
        rxnGeneMat = X[key1]["rxnGeneMat"]
    else
        rxnGeneMat = sparse([1],[1],[0.0])
    end
    if haskey(X[key1],"grRules")
        grRules = String[ string(X[key1]["grRules"][i]) for i=1:length(X[key1]["grRules"]) ]
    else
        grRules = ["NA"]
    end
    if haskey(X[key1],"mets")
        mets = String[ string(X[key1]["mets"][i])  for i=1:length(X[key1]["mets"]) ]
        if length(unique(mets)) != M
            mets = String["met$i" for i=1:M]
            warn("not unique list if metabolite names")
        end
    else
        mets = String["met$i" for i=1:M]
    end

    if haskey(X[key1],"rxns")
        rxns = String[ string(X[key1]["rxns"][i])  for i=1:length(X[key1]["rxns"])]
        if length(unique(rxns)) != N
            rxns = String["rxn$i" for i=1:N]
            warn("not unique list of reaction names")
        end
    else
        rxns = String["rxn$i" for i=1:N]
    end
    if haskey(X[key1],"metNames")
        metNames = String[ string(X[key1]["metNames"][i])  for i=1:length(X[key1]["metNames"]) ]
    else
        metNames = ["NA"]
    end
    if haskey(X[key1],"metFormulas")
        metFormulas = String[ string(X[key1]["metFormulas"][i]) for i=1:length(X[key1]["metFormulas"]) ]
    else
        metFormulas = ["NA"]
    end
    if haskey(X[key1],"rxnNames")
        rxnNames = String[ string(X[key1]["rxnNames"][i])  for i=1:length(X[key1]["rxnNames"]) ]
    else
        rxnNames = ["NA"]
    end
    if haskey(X[key1],"rev")
        rev = Bool[X[key1]["rev"][i] > 0 ? true : false for i=1:length(X[key1]["rev"]) ]
    else
        rev = Vector{Bool}()
    end
    if haskey(X[key1],"subSystems")
        subSystems = String[string(X[key1]["subSystems"][i]) for i=1:length(X[key1]["subSystems"]) ]
    else
        subSystems = ["NA"]
    end
    return MetNet(N, M, S, b, c,  lb, ub, genes, rxnGeneMat, grRules,
                  mets,rxns,metNames,metFormulas, rxnNames,rev,subSystems)

end

# function reduceModel(X::COBRA.LPproblem; solverName::Symbol=:Gurobi,solParams=[],optPercentage::Float64=100.0, tiny=1e-10)
#
#     solver = COBRA.changeCobraSolver(solverName, solParams)
#     minFlux, maxFlux, optSol, fbaSol, fvamin, fvamax = COBRA.distributedFBA(X, solver, nWorkers=1, optPercentage=optPercentage)
#     for i in eachindex(maxFlux)
#         deltaflux = maxFlux[i] - minFlux[i]
#         if -tiny <= deltaflux <= tiny
#             if abs(maxFlux[i]) < tiny
#                 maxFlux[i] = 0.0
#                 minFlux[i] = 0.0
#             else
#                 maxFlux[i] = 0.5*(minFlux[i] + maxFlux[i])
#                 minFlux[i] = maxFlux[i]
#             end
#         end
#     end
#     return COBRA.LPproblem(X.S,X.b,X.c,minFlux,maxFlux,X.osense,X.csense,X.rxns,X.mets)
# end



# function reduceModel!(X::COBRA.LPproblem; solverName::Symbol=:Gurobi,solParams=[],optPercentage::Float64=100.0, tiny=1e-10)
#
#     solver = COBRA.changeCobraSolver(solverName, solParams)
#     minFlux, maxFlux, optSol, fbaSol, fvamin, fvamax = COBRA.distributedFBA(X, solver, nWorkers=1, optPercentage=optPercentage)
#
#     for i in eachindex(X.lb)
#         deltaflux = maxFlux[i] - minFlux[i]
#         if deltaflux > tiny
#             X.lb[i] = minFlux[i]
#             X.ub[i] = maxFlux[i]
#         elseif -tiny <= deltaflux <= tiny
#             if abs(X.lb[i]) < tiny
#                 X.lb[i] = 0.0
#                 X.ub[i] = 0.0
#             else
#                 X.lb[i] = 0.5*(minFlux[i] + maxFlux[i])
#                 X.ub[i] = X.lb[i]
#             end
#         else
#             warn("lb[$i] = ", lb[i], " ub[$i] = ",ub[i])
#         end
#     end
#     return nothing
# end

function idxlicols{T<:DenseArray}(X::T; tol::Float64=1e-10)
    sum(abs2,X) == 0 && (return(Array{Int,1}(),Array{Int,2}()))
    Q,R,E = qr(X,Val{true})
    diagr = abs.(diag(R))
    r = find(diagr .>= tol*diagr[1])[end]
    idx = sort(E[1:r])
    return idx
end


# function simplereducestandardform(X)
#
#     RX = reduceModel(X)
#     @extract RX : S b c lb ub csense osense rxns mets
#     M,N = size(S)
#     idxfixed = find(lb .== ub .* lb .== 0)
#     idxrow = setdiff(1:M,idxfixed)
#     idxcol = setdiff(1:N,idxfixed)
#     COBRA.LPproblem(S[idxrow,idxcol],b[idxrow],c[idxcol],lb[idxcol],ub[idxcol],osense, csense[idxrow], rxns[idxcol], mets[idxrow])
# end


# function standardform(X::COBRA.LPproblem)
#     idxrow, idxcol, res, bnew = echelonize(full(X.S), X.b)
#     (length(idxrow),length(idxcol)) == size(res) || BoundsError()
#     COBRA.LPproblem(sparse(res),bnew,X.c[idxcol],X.lb[idxcol],X.ub[idxcol],X.osense, X.csense[idxrow], X.rxns[idxcol], X.mets[idxrow])
# end
#
# isstandardform(X::COBRA.LPproblem) = isstandardform(X.S)
isstandardform(S::SparseMatrixCSC) = S[1:size(S,1),1:size(S,1)] == speye(size(S,1))
isstandardform(S::DenseMatrix) = S[1:size(S,1),1:size(S,1)] == eye(size(S,1))


function echelonize{T<:DenseArray}(X::T, b::Vector; eps::Real=1e-10)
    M,N = size(X)

    idxrow = idxlicols(X')
    Mred = length(idxrow)
    idxind = idxlicols(X)
    idxdep = setdiff(1:N,idxind)
    newidx = vcat(idxind,idxdep)
    Tv = @view X[idxrow,newidx]
    iTv = inv(Tv[1:Mred,1:Mred])
    res =   iTv * Tv
    for i in eachindex(res)
        abs(res[i]) < eps && (res[i] = zero(res[i]))
    end

    bnew = iTv * b[idxrow]

    # trimming zeros
    for i in 1:Mred
        abs(1.0 - res[i,i]) < eps  && (res[i,i] = one(res[i,i]))
    end
    idxrow,newidx,res, bnew
end
