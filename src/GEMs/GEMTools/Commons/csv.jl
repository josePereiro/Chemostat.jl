function write_to_csv(gem, S_file, mets_file, rxns_file; delim = '\t')
    
    i,k,s = findnz(gem.S)
    S_df = DataFrame(Dict("i"=> i, "k" => k, "s" => s));
    CSV.write(S_file, S_df, delim = delim)
    CSV.write(mets_file, gem.mets, delim = delim)
    CSV.write(rxns_file, gem.rxns, delim = delim)
    
end

function write_to_csv(gem, files_prefix, dir_path = "."; delim = '\t')
    if files_prefix == ""
        error("You most specify a files_prefix")
    end
    prefix = joinpath(dir_path, files_prefix)
    write_to_csv(gem, prefix * ".S.csv", prefix * ".mets.csv", prefix * ".rxns.csv", delim = delim)
end

function read_from_csv(S_file, mets_file, rxns_file; delim = '\t', allowmissing = :none)
    
    S = CSV.read(S_file, delim = delim)
    S = sparse(Int.(S[:i]), Int.(S[:k]), Float64.(S[:s]))
    
    mets = CSV.read(mets_file, delim = delim, allowmissing = allowmissing)
    mets[:id] = String.(mets[:id])
    mets[:y] = Float64.(mets[:y])
    mets[:e] = Float64.(mets[:e])
    mets[:L] = Float64.(mets[:L])
    mets[:V] = Float64.(mets[:V])
    
    rxns = CSV.read(rxns_file, delim = delim, allowmissing = allowmissing)
    rxns[:id] = String.(rxns[:id])
    rxns[:ap] = Float64.(rxns[:ap])
    rxns[:an] = Float64.(rxns[:an])
    rxns[:nub] = Float64.(rxns[:nub])
    rxns[:nlb] = Float64.(rxns[:nlb])
    rxns[:pub] = Float64.(rxns[:pub])
    rxns[:plb] = Float64.(rxns[:plb])
    
    return Chemostat.GEM(S, mets, rxns)
    
end

function read_from_csv(files_prefix, dir_path = "."; delim = '\t', allowmissing = :none)
    if files_prefix == ""
        error("You most specify a files_prefix")
    end
    prefix = joinpath(dir_path, files_prefix)
    read_from_csv(prefix * ".S.csv", prefix * ".mets.csv", prefix * ".rxns.csv", 
        delim = delim, allowmissing = allowmissing)
end