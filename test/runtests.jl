using SatelliteDataSources
using Test, Fetch, JSON, Rasters, ArchGDAL, DataDeps

include("utils.jl")

const sentinel_link = "https://drive.google.com/file/d/1Q6LF2Hk49zSHgQqmdICBvjpp_dHIRyN5/view?usp=sharing"
const sentinel_hash = "41cebfbc84b330d94abda5cc524de05aa15ac859cddca806aad9e9dc29abfbb9"
const landsat_link = "https://drive.google.com/file/d/1S5H_oyWZZInOzJK4glBCr6LgXSADzhOV/view?usp=sharing"
const landsat_hash = "2ce24abc359d30320213237d78101d193cdb8433ce21d1f7e9f08ca140cf5785"
const landsat9_link = "https://drive.google.com/file/d/1PJ0zFqbmVZROwdprZfXrxz-TaVRSevMJ/view?usp=sharing"
const landsat9_hash = "78db0f61d8b2ba09d9238d2a14887e1692cf410dab9f0c15356806b1fbea7e71"

ENV["DATADEPS_ALWAYS_ACCEPT"] = true
ENV["DATADEPS_LOAD_PATH"] = joinpath(pwd(), "data")

@testset "Landsat 7" begin
    # Load Test Data
    register(DataDep("LC08_L2SP_043024_20200802_20200914_02_T1", """Landsat 8 Test Data""", landsat_link, landsat_hash, fetch_method=gdownload, post_fetch_method=unpack))

    # Test Specifications
    @test all(bands(Landsat7) .== [:B1, :B2, :B3, :B4, :B5, :B7])
    @test all(layers(Landsat7) .== [:B1, :B2, :B3, :B4, :B5, :B7, :blue, :green, :red, :nir, :swir1, :swir2, :panchromatic, :thermal, :dilated_clouds, :clouds, :cloud_shadow, :snow, :water])
    @test all(wavelengths(Landsat7) .== [483, 560, 660, 835, 1650, 2220])

    # Test Color Mapping
    colors = Dict([:blue => :B1, :green => :B2, :red => :B3, :nir => :B4, :swir1 => :B5, :swir2 => :B7])

    # Test Layer Parsing

    # Test Raster
end

@testset "Landsat 8" begin
    # Load Test Data
    register(DataDep("LC08_L2SP_043024_20200802_20200914_02_T1", """Landsat 8 Test Data""", landsat_link, landsat_hash, fetch_method=gdownload, post_fetch_method=unpack))

    # Test Specifications
    @test all(bands(Landsat8) .== [:B1, :B2, :B3, :B4, :B5, :B6, :B7])
    @test all(layers(Landsat8) .== [:B1, :B2, :B3, :B4, :B5, :B6, :B7, :blue, :green, :red, :nir, :swir1, :swir2, :panchromatic, :thermal1, :thermal2, :dilated_clouds, :clouds, :cloud_shadow, :snow, :water])
    @test all(wavelengths(Landsat8) .== [443, 483, 560, 660, 865, 1650, 2220])

    # Test Color Mapping
    colors = Dict([:blue => :B2, :green => :B3, :red => :B4, :nir => :B5, :swir1 => :B6, :swir2 => :B7])

    # Test Layer Parsing

    # Test Raster
end

@testset "Landsat 9" begin
    # Load Test Data
    register(DataDep("LC09_L2SP_042023_20220825_20230401_02_T1", """Landsat 9 Test Data""", landsat9_link, landsat9_hash, fetch_method=gdownload, post_fetch_method=unpack))

    # Test Specifications
    @test all(bands(Landsat9) .== [:B1, :B2, :B3, :B4, :B5, :B6, :B7])
    @test all(layers(Landsat9) .== [:B1, :B2, :B3, :B4, :B5, :B6, :B7, :blue, :green, :red, :nir, :swir1, :swir2, :panchromatic, :thermal1, :thermal2, :dilated_clouds, :clouds, :cloud_shadow, :snow, :water])
    @test all(wavelengths(Landsat9) .== [443, 483, 560, 660, 865, 1650, 2220])

    # Test Color Mapping
    colors = Dict([:blue => :B2, :green => :B3, :red => :B4, :nir => :B5, :swir1 => :B6, :swir2 => :B7])

    # Test Layer Parsing

    # Test Raster
end

@testset "Sentinel 2" begin
    # Load Test Data
    register(DataDep("L2A_T11UPT_A017828_20200804T184659", """Sentinel 2 Test Data""", sentinel_link, sentinel_hash, fetch_method=gdownload, post_fetch_method=unpack))

    # Test Specifications (10m)
    @test all(bands(Sentinel2{10}) .== [:B02, :B03, :B04, :B08])
    @test all(layers(Sentinel2{10}) .== [:B02, :B03, :B04, :B08, :blue, :green, :red, :nir])
    @test all(wavelengths(Sentinel2{10}) .== [490, 560, 665, 842])

    # Test Specifications (20m)
    @test all(bands(Sentinel2{20}) .== [:B02, :B03, :B04, :B05, :B06, :B07, :B8A, :B11, :B12])
    @test all(layers(Sentinel2{20}) .== [:B02, :B03, :B04, :B05, :B06, :B07, :B8A, :B11, :B12, :blue, :green, :red, :nir, :swir1, :swir2, :cloud_shadow, :clouds_med, :clouds_high, :cirrus, :vegetation, :soil, :water, :snow])
    @test all(wavelengths(Sentinel2{20}) .== [490, 560, 665, 705, 740, 783, 865, 1610, 2190])

    # Test Specifications (60m)
    @test all(bands(Sentinel2{60}) .== [:B01, :B02, :B03, :B04, :B05, :B06, :B07, :B8A, :B09, :B11, :B12])
    @test all(layers(Sentinel2{60}) .== [:B01, :B02, :B03, :B04, :B05, :B06, :B07, :B8A, :B09, :B11, :B12, :blue, :green, :red, :nir, :swir1, :swir2, :cloud_shadow, :clouds_med, :clouds_high, :cirrus, :vegetation, :soil, :water, :snow])
    @test all(wavelengths(Sentinel2{60}) .== [443, 490, 560, 665, 705, 740, 783, 865, 945, 1610, 2190])

    # Test DN Specifications

    # Test Resolution Requirement
    @test_throws ErrorException bands(Sentinel2)
    @test_throws ErrorException wavelengths(Sentinel2)
    @test_throws ErrorException layers(Sentinel2)

    # Test Color Mapping (10m)
    @test blue_band(Sentinel2{10}) == :B02
    @test green_band(Sentinel2{10}) == :B03
    @test red_band(Sentinel2{10}) == :B04
    @test nir_band(Sentinel2{10}) == :B08

    # Test Color Mapping (20m)
    colors = Dict([:blue => :B02, :green => :B03, :red => :B04, :nir => :B8A, :swir1 => :B11, :swir2 => :B12])
    test_colors(Sentinel2{20}, colors)

    # Test Color Mapping (60m)
    colors = Dict([:blue => :B02, :green => :B03, :red => :B04, :nir => :B8A, :swir1 => :B11, :swir2 => :B12])
    test_colors(Sentinel2{60}, colors)

    # Test Layer Parsing (60m)

    # Test Layer Parsing (20m)

    # Test Layer Parsing (10m)

    # Test Raster
end