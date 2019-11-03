function show_exchanges(expres, ξ::Float64)
    Chemostat.GEMTools.Store.backup_working_gem();
    Chemostat.GEMTools.Store.set_working_gem(Chemostat.ExpRess.get_GEM(expres));
    Chemostat.ExpRess.backup_working_express();

    mets = Chemostat.METS.exchangeable();

    println("___________________________");
    println("Comsuptions");
    println("Met_id/ flux/ eV = min(V, c / ξ)");
    for met in sort(METS.ids(Chemostat.METS.consumable()))
        u = Chemostat.ExpRess.get_u(ξ, met);
        c = METS.get_c(met);
        V = METS.get_V(met);
        eV = Chemostat.FBA.chemostat_bound(V, c, ξ);
        if u > 0.0
            if isapprox(u,eV)
                println("$(met) --------------- BOUNDED");
                println("   u: ", u);
                println("   c: ", c);
                println("   V: ", V);
                println("   eV: ", eV);
            else
                println("$(met) -----------------------");
                println("   u: ", u);
                println("   c: ", c);
                println("   V: ", V);
                println("   eV: ", eV);
            end
        end
    end

    println();
    println("___________________________");
    println("Secretions");
    println("Met_id/ flux/ L");
    for met in sort(METS.ids(Chemostat.METS.secretable()))
        u = Chemostat.ExpRess.get_u(ξ, met);
        c = METS.get_c(met);
        L = METS.get_L(met);
        if u < 0.0
            if isapprox(u,L)
                println("$(met) --------------- BOUNDED");
                println("   u: ", u);
                println("   c: ", c);
                println("   L: ", L);
            else
                println("$(met) -----------------------");
                println("   u: ", u);
                println("   c: ", c);
                println("   L: ", L);
            end
        end
    end

    Chemostat.GEMTools.Store.restore_working_gem!();
    Chemostat.ExpRess.restore_working_expres!();

end
show_exchanges(ξ::Float64) = show_exchanges(get_working_expres(),ξ);
show_exchanges(expres, ξi::Int) = show_exchanges(expres, get_ξ(ξi));
show_exchanges(ξi::Int) = show_exchanges(get_working_expres(), ξi);
