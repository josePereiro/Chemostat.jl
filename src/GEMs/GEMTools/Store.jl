module Store

    using Chemostat.GEMs;
    using Chemostat.GEMTools.Commons;
    _gem_ = nothing;
    _mets_ = nothing;
    _rxns_ = nothing;
    _S_ = nothing;
    function set_working_gem(gem::GEM)
        global _gem_ = gem;
        global _mets_ = _gem_.mets;
        global _rxns_ = _gem_.rxns;
        global _S_ = _gem_.S;
    end

    function clean_working_gem()
        global _gem_ = nothing;
        global _mets_ = nothing;
        global _rxns_ = nothing;
        global _S_ = nothing;
    end


    force_mets(mets) = begin
        warn("This method set the working mets data without checking its " *
                "format or data quality!!! Use with precaution!!!")
        global _mets_ = mets;
    end

    clean_mets() = global _mets_ = nothing;

    force_rxns(rxns) = begin
        warn("This method set the working rxns data without checking its " *
                "format or data quality!!! Use with precaution!!!")
        global _rxns_ = rxns;
    end

    clean_rxns() = global _rxns_ = nothing;

    force_S(S) = begin
        warn("This method set the working S data without checking its " *
                "format!!! Use with precaution!!!")
        global _S_ = S;
    end

    clean_S() = global _S_ = nothing;

    get_gem() = _gem_ == nothing ? error("You must first set the working GEM!!!") : _gem_;

    get_mets() = _mets_ == nothing ? error("You must first set the working GEM!!!") : _mets_;
    get_mets(met) = get_mets()[Commons.parse_ider(_mets_, met),:];

    get_rxns() = _rxns_ == nothing ? error("You must first set the working GEM!!!") : _rxns_;
    get_rxns(rxn) = get_rxns()[Commons.parse_ider(_rxns_, rxn),:];

    get_S() = _S_ == nothing ? error("You must first set the working GEM!!!") : _S_;
    get_S(met, rxn) =
        get_S()[Commons.parse_ider(_mets_, met), Commons.parse_ider(_rxns_, rxn)];
    get_S(::Colon, rxn) = get_S()[:, Commons.parse_ider(_rxns_, rxn)];
    get_S(met, ::Colon) = get_S()[Commons.parse_ider(_mets_, met),:];

end
