
# Models data root dir
MODELS_DATA_DIR = joinpath(Pkg.dir(),"Chemostat","ModelsData")

# EColi
# EColi models data root folder
ECOLI_MODELS_ROOT_DIR = joinpath(MODELS_DATA_DIR,"EColi")
# A commom prefix for any ecoli model file
ECOLI_MODELS_DATA_FILES_PREFIX = "ecoli"

# EColi Core
# EColi Core root dir
ECOLI_CORE_MODEL_ROOT_DIR = joinpath(ECOLI_MODELS_ROOT_DIR,"Core")
# EColi core v1 data dir
ECOLI_CORE_V1_MODEL_DATA_DIR = joinpath(ECOLI_CORE_MODEL_ROOT_DIR, "core_v1")
# EColi core v2 data dir
ECOLI_CORE_V2_MODEL_DATA_DIR = joinpath(ECOLI_CORE_MODEL_ROOT_DIR, "core_v2")
# EColi iAF1260 root dir
ECOLI_iAF1260_MODEL_ROOT_DIR = joinpath(ECOLI_MODELS_ROOT_DIR,"iAF1260")
# EColi iAF1260 data dir
ECOLI_iAF1260_MODEL_DATA_DIR = ECOLI_iAF1260_MODEL_ROOT_DIR
