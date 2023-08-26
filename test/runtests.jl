using SatelliteTypes
using Test, Fetch

include("utils.jl")

const sentinel_link = "https://drive.google.com/file/d/1Q6LF2Hk49zSHgQqmdICBvjpp_dHIRyN5/view?usp=sharing"
const sentinel_dst = "data/L2A_T11UPT_A017828_20200804T184659"
const landsat_link = "https://drive.google.com/file/d/1S5H_oyWZZInOzJK4glBCr6LgXSADzhOV/view?usp=sharing"
const landsat_dst = "data/LC08_L2SP_043024_20200802_20200914_02_T1"

@testset "Landsat 7" begin
    # Test Specifications
    @test all(bandnames(Landsat7) .== [:B1, :B2, :B3, :B4, :B5, :B7])
    @test all(layernames(Landsat7) .== [:B1, :B2, :B3, :B4, :B5, :B7, :blue, :green, :red, :nir, :swir1, :swir2, :QA])
    @test all(wavelengths(Landsat7) .== [483, 560, 660, 835, 1650, 2220])

    # Test Color Mapping
    colors = Dict([:blue => :B1, :green => :B2, :red => :B3, :nir => :B4, :swir1 => :B5, :swir2 => :B7])
    test_colors(Landsat7, colors)
end

@testset "Landsat 8" begin
    # Test Specifications
    @test all(bandnames(Landsat8) .== [:B1, :B2, :B3, :B4, :B5, :B6, :B7])
    @test all(layernames(Landsat8) .== [:B1, :B2, :B3, :B4, :B5, :B6, :B7, :blue, :green, :red, :nir, :swir1, :swir2, :QA])
    @test all(wavelengths(Landsat8) .== [443, 483, 560, 660, 865, 1650, 2220])

    # Test Color Mapping
    colors = Dict([:blue => :B2, :green => :B3, :red => :B4, :nir => :B5, :swir1 => :B6, :swir2 => :B7])
    test_colors(Landsat8, colors)
end

@testset "Sentinel 2" begin
    # Test Specifications (10m)
    @test all(bandnames(Sentinel2{10}) .== [:B02, :B03, :B04, :B08])
    @test all(layernames(Sentinel2{10}) .== [:B02, :B03, :B04, :B08, :blue, :green, :red, :nir])
    @test all(wavelengths(Sentinel2{10}) .== [490, 560, 665, 842])

    # Test Specifications (20m)
    @test all(bandnames(Sentinel2{20}) .== [:B02, :B03, :B04, :B05, :B06, :B07, :B8A, :B11, :B12])
    @test all(layernames(Sentinel2{20}) .== [:B02, :B03, :B04, :B05, :B06, :B07, :B8A, :B11, :B12, :blue, :green, :red, :nir, :swir1, :swir2, :SCL])
    @test all(wavelengths(Sentinel2{20}) .== [490, 560, 665, 705, 740, 783, 865, 1610, 2190])

    # Test Specifications (60m)
    @test all(bandnames(Sentinel2{60}) .== [:B01, :B02, :B03, :B04, :B05, :B06, :B07, :B8A, :B09, :B11, :B12])
    @test all(layernames(Sentinel2{60}) .== [:B01, :B02, :B03, :B04, :B05, :B06, :B07, :B8A, :B09, :B11, :B12, :blue, :green, :red, :nir, :swir1, :swir2, :SCL])
    @test all(wavelengths(Sentinel2{60}) .== [443, 490, 560, 665, 705, 740, 783, 865, 945, 1610, 2190])

    # Test Color Mapping (10m)
    colors = Dict([:blue => :B02, :green => :B03, :red => :B04, :nir => :B08, :swir1 => nothing, :swir2 => nothing])
    test_colors(Sentinel2{10}, colors)

    # Test Color Mapping (20m)
    colors = Dict([:blue => :B02, :green => :B03, :red => :B04, :nir => :B8A, :swir1 => :B11, :swir2 => :B12])
    test_colors(Sentinel2{20}, colors)

    # Test Color Mapping (60m)
    colors = Dict([:blue => :B02, :green => :B03, :red => :B04, :nir => :B8A, :swir1 => :B11, :swir2 => :B12])
    test_colors(Sentinel2{60}, colors)
end
