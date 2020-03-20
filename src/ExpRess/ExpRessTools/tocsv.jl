function to_csv(expres, file_name; delim = "\t")
    
    try
    
        Chemostat.ExpRess.backup_working_express()
        Chemostat.ExpRess.set_working_expres(expres)

        data = []

        # Observables 
        head_line = ["ξ", "μ", "Xv"]
        
        # mets
        for met in Chemostat.ExpRess.get_mets_ids()
            push!(head_line, "c_$met")
            push!(head_line, "s_$met")
            push!(head_line, "u_$met")
        end
        
        # rxns
        for rxn in Chemostat.ExpRess.get_rxns_ids()
            push!(head_line, "r_$rxn")
        end
        
        push!(data, join(head_line, delim))

        # data
        for ξ in Chemostat.ExpRess.get_ξs()
            
            # Observables
            ξ_line = [ξ, Chemostat.ExpRess.get_μ(ξ), Chemostat.ExpRess.get_Xv(ξ)]

            # mets
            for met in Chemostat.ExpRess.get_mets_ids()
                push!(ξ_line, Chemostat.ExpRess.get_c(met))
                push!(ξ_line, Chemostat.ExpRess.get_s(ξ, met))
                push!(ξ_line, Chemostat.ExpRess.get_u(ξ, met))
            end
            
            # rxns
            for rxn in Chemostat.ExpRess.get_rxns_ids()
                push!(ξ_line, Chemostat.ExpRess.get_r(ξ, rxn))
            end
            
            push!(data, join(ξ_line, delim))

        end

        write(file_name, join(data, "\n"))
    
    catch err
        rethrow(err)
    finally
        Chemostat.ExpRess.restore_working_expres!()
    end
    
end
to_csv(file_name::String; delim = "\") = to_csv(get_working_expres(), file_name; delim = delim);
