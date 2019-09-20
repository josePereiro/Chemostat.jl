module Tools

function log_sample(from, till; approx_len = 20,  include = [])
    fo = round(Int, log10(from));
    to = round(Int, log10(till));
    approx_step = (9.0 * (log10(till) - log10(from)))/(approx_len - length(include) - 2);
    col = filter((x) -> from <= x <= till , sort!(union([vcat([collect(1.0:approx_step:9.0) * 10.0^o
                            for o in fo:to]...); from; till; include])));
end

end  # module Tools
