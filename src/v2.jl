module v2

# module FBA
#     include("FBA/v1/FBA_v1.jl");
# end  # module FBA

module Models
    module EColi
        include("Models/EColi/EColi_v2.jl");
    end  # module EColi
    # module ToyModel
    #     include("Models/ToyModel/ToyModel_v1.jl");
    # end  # module ToyModel
end  # module Models


end
