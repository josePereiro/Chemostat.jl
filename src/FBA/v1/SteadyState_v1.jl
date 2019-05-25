
export s;
function s(fbares::FBAResult_v1, sid::String, trxnid::String)
    return s(fbares, indexof(fbares,sid), indexof(fbares,trxnid));
end

function s(fbares::FBAResult_v1, sidx::Int, trxnidx::Int)
    return Chemostat.s(fbares.mets[:c][sidx], flux(fbares, trxnidx), xi(fbares));
end

export μ
function μ(fbaress, w, τ)
    return Chemostat.μ(objv(fbaress), w, τ);
end

export X
function X(fbaress, μ, ret_factor)
    return Chemostat.X(xi(fbaress), μ , ret_factor);
end
