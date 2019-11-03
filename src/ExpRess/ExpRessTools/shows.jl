function show_exchanges(expres, ξ::Float64)
    Chemostat.GEMTools.Store.backup_working_gem();
    Chemostat.GEMTools.Store.set_working_gem(Chemostat.ExpRess.get_GEM(expres));
    Chemostat.ExpRess.backup_working_express();

    mets = Chemostat.METS.exchangeable();

    println("Comsuptions")
    for met in sort(METS.ids(Chemostat.METS.consumable()))
        u = Chemostat.ExpRess.get_u(ξ, met);
        u > 0.0 && println("$(met): ", u);
    end

    println();
    println("Secretions")
    for met in sort(METS.ids(Chemostat.METS.secretable()))
        u = Chemostat.ExpRess.get_u(ξ, met);
        u < 0.0 && println("$(met): ", u);
    end

    Chemostat.GEMTools.Store.restore_working_gem!();
    Chemostat.ExpRess.restore_working_expres!();

end
