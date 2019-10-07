backup_gem = nothing;
backup_mets = nothing;
backup_rxns = nothing;
backup_S = nothing;

function backup_working_data()
    global backup_gem = working_gem;
    global backup_mets = working_mets;
    global backup_rxns = working_rxns;
    global backup_S = working_S;
end

function restore_working_data!()
    if backup_gem != nothing
        global working_gem = backup_gem;
        global backup_gem = nothing;
    end
    if backup_mets != nothing
        global working_mets = backup_mets;
        global backup_mets = nothing;
    end
    if backup_rxns != nothing
        global working_rxns = backup_rxns;
        global backup_rxns = nothing;
    end
    if backup_S != nothing
        global working_S = backup_S;
        global backup_S = nothing;
    end
end
