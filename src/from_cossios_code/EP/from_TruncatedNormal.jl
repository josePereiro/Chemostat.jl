"""
tnmean(a,b)

Mean of the truncated standard normal distribution

tnmean(a, b, μ, σ)

Mean of the truncated normal distribution, where μ, σ
are the mean and standard deviation of the untruncated
distribution.
"""
function tnmean end

# delete this
t = 0;

function tnmean(a, b)
    if a < b
        √(2/π) * _F1(a/√2, b/√2)
    elseif a == b
        a
    else
        # throw(ArgumentError("a must be < b"))

        # Delete, this is a test
        if time() - t > 1.0 println("Delete, this is a test"); global t = time(); end
        tnmean(b,a);
    end
end

function tnmean(a, b, μ, σ)
    α = (a - μ)/σ; β = (b - μ)/σ
    return μ + tnmean(α, β) * σ
end

"""
_F1(x, y) =

    (exp(-x^2) - exp(-y^2)) / (erf(y) - erf(x))

without catastrophic cancellation. _F1(±∞,±∞) is defined
by taking the limit of the second argument first.
"""
function _F1(x::Real, y::Real; thresh=1e-7)
    if abs(x) > abs(y)
        return _F1(y, x)
    elseif isinf(y)
        return sign(y) / erfcx(sign(y) * x)
    elseif abs(x - y) ≤ thresh
        ϵ = y - x
        return √π*x + (√π/2 + (-√π*x/6 + (-√π/12 + x*(√π/90 + (√π*x^2)/90)ϵ)ϵ)ϵ)ϵ
    end

    Δ = exp(x^2 - y^2)

    if max(x, y) < 0
        (1 - Δ) / (Δ * erfcx(-y) - erfcx(-x))
    elseif min(x, y) > 0 || y == Inf
        (1 - Δ) / (erfcx(x) - Δ * erfcx(y))
    else
        exp(-x^2) * (1 - Δ) / (erf(y) - erf(x))
    end
end
