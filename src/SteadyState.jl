export s
function s(c, st, ξ)
    return max(c - st * ξ, 0);
end

export μ
function μ(z::Real, w::Real, τ::Real)
    return max(z - w * τ, 0);
end

export X
function X(ξ::Real, μ::Real, ret_factor::Real)
    return ξ * μ / ret_factor;
end
