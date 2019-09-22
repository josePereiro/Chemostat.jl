working_expres = nothing;
set_working_expres(exp::ExpRes) = global working_expres = exp;
clear_working_expres() = global working_expres = nothing;
get_working_expres() =
    if working_expres == nothing error("You must set the working expres first!!!")
    else working_expres end;
