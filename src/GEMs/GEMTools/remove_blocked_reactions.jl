function remove_blocked_reaction(gem)
    Chemostat.GEMTools.Store.backup_working_gem();
    Chemostat.GEMTools.Store.set_working_gem(gem);

    nz_S = copy(gem.S);
    nz_S[:, Chemostat.RXNS.blocked()] = 0.0;
    nz_mets, nz_rxns = findnz(nz_S)[1:2]
    nz_mets = unique(nz_mets);
    nz_rxns = unique(nz_rxns);


    Chemostat.GEMTools.Store.restore_working_gem!();
    return Chemostat.GEMs.GEM(nz_S[nz_mets,nz_rxns],
        copy(gem.mets)[nz_mets,:], copy(gem.rxns)[nz_rxns,:]);
end
