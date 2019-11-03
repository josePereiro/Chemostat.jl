# working express
working_expres = nothing;
set_working_expres(exp::ExpRes) = global working_expres = exp;
clear_working_expres() = global working_expres = nothing;
get_working_expres() =
    if working_expres == nothing error("You must set the working expres first!!!")
    else working_expres end;

# backup
backup_expres = nothing;

function backup_working_express()
    global backup_expres = working_expres;
end

function restore_working_expres!()
    if backup_expres != nothing
        global working_expres = backup_expres;
        global backup_expres = nothing;
    end
end
