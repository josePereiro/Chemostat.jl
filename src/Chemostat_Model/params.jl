default_ϕ = 1.0;
set_default_ϕ!(new_ϕ) = if 0 <= new_ϕ <= 1.0 global default_ϕ = new_ϕ else
    error("new_ϕ must be a number between 0 and 1!!!") end;
