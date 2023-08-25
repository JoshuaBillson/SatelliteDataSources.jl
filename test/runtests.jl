using SatelliteTypes
using Test, Fetch

include("utils.jl")

const sentinel_link = "https://drive.google.com/file/d/1Q6LF2Hk49zSHgQqmdICBvjpp_dHIRyN5/view?usp=sharing"
const sentinel_dst = "data/L2A_T11UPT_A017828_20200804T184659"
const landsat_link = "https://drive.google.com/file/d/1S5H_oyWZZInOzJK4glBCr6LgXSADzhOV/view?usp=sharing"
const landsat_dst = "data/LC08_L2SP_043024_20200802_20200914_02_T1"

@testset "Landsat7" begin
    colors = Dict([:blue => :B1, :green => :B2, :red => :B3, :nir => :B4, :swir1 => :B5, :swir2 => :B7])
    test_colors(Landsat7, colors)
end
