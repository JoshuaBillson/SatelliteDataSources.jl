using SatelliteTypes
using Test, Fetch, JSON, Rasters, ArchGDAL

include("utils.jl")

const sentinel_link = "https://drive.google.com/file/d/1Q6LF2Hk49zSHgQqmdICBvjpp_dHIRyN5/view?usp=sharing"
const sentinel_dst = "data/L2A_T11UPT_A017828_20200804T184659"
const landsat_link = "https://drive.google.com/file/d/1S5H_oyWZZInOzJK4glBCr6LgXSADzhOV/view?usp=sharing"
const landsat_dst = "data/LC08_L2SP_043024_20200802_20200914_02_T1"

@testset "Landsat 7" begin
    # Load Test Data
    download_data(landsat_link, landsat_dst)

    # Test Specifications
    @test all(bandnames(Landsat7) .== [:B1, :B2, :B3, :B4, :B5, :B7])
    @test all(layernames(Landsat7) .== [:B1, :B2, :B3, :B4, :B5, :B7, :blue, :green, :red, :nir, :swir1, :swir2, :QA])
    @test all(wavelengths(Landsat7) .== [483, 560, 660, 835, 1650, 2220])
    @test dn_scale(Landsat7) == 0.0000275f0
    @test dn_offset(Landsat7) == -0.2f0

    # Test Color Mapping
    colors = Dict([:blue => :B1, :green => :B2, :red => :B3, :nir => :B4, :swir1 => :B5, :swir2 => :B7])
    test_colors(Landsat7, colors)

    # Test Layer Parsing
    test_layers(Landsat7, "data/answers.json", "landsat7", "data/LC08_L2SP_043024_20200802_20200914_02_T1/")
    @test first(keys(getlayers(Landsat7, "data/LC08_L2SP_043024_20200802_20200914_02_T1/", layers=:swir1))) == :B5

    # Test Raster
    @test size(Raster(Landsat7, "data/LC08_L2SP_043024_20200802_20200914_02_T1/", :red, lazy=true)) == (7821, 7921)
end

@testset "Landsat 8" begin
    # Load Test Data
    download_data(landsat_link, landsat_dst)

    # Test Specifications
    @test all(bandnames(Landsat8) .== [:B1, :B2, :B3, :B4, :B5, :B6, :B7])
    @test all(layernames(Landsat8) .== [:B1, :B2, :B3, :B4, :B5, :B6, :B7, :blue, :green, :red, :nir, :swir1, :swir2, :QA])
    @test all(wavelengths(Landsat8) .== [443, 483, 560, 660, 865, 1650, 2220])
    @test dn_scale(Landsat8) == 0.0000275f0
    @test dn_offset(Landsat8) == -0.2f0

    # Test Color Mapping
    colors = Dict([:blue => :B2, :green => :B3, :red => :B4, :nir => :B5, :swir1 => :B6, :swir2 => :B7])
    test_colors(Landsat8, colors)

    # Test Layer Parsing
    test_layers(Landsat8, "data/answers.json", "landsat8", "data/LC08_L2SP_043024_20200802_20200914_02_T1/")
    @test first(keys(getlayers(Landsat8, "data/LC08_L2SP_043024_20200802_20200914_02_T1/", layers=:swir1))) == :B6

    # Test Raster
    @test size(Raster(Landsat8, "data/LC08_L2SP_043024_20200802_20200914_02_T1/", :red, lazy=true)) == (7821, 7921)
end

@testset "Sentinel 2" begin
    # Load Test Data
    download_data(sentinel_link, sentinel_dst)

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

    # Test DN Specifications
    @test dn_scale(Sentinel2) == 0.0001f0
    @test dn_offset(Sentinel2) == 0.0f0

    # Test Resolution Requirement
    @test_throws ErrorException bandnames(Sentinel2)
    @test_throws ErrorException wavelengths(Sentinel2)
    @test_throws ErrorException layernames(Sentinel2)

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
    test_layers(Sentinel2{60}, "data/answers.json", "sentinel2_60", "data/L2A_T11UPT_A017828_20200804T184659/")
    @test first(keys(getlayers(Sentinel2{60}, "data/L2A_T11UPT_A017828_20200804T184659/", layers=:swir1))) == :B11

    # Test Layer Parsing (20m)
    test_layers(Sentinel2{20}, "data/answers.json", "sentinel2_20", "data/L2A_T11UPT_A017828_20200804T184659/")
    @test first(keys(getlayers(Sentinel2{20}, "data/L2A_T11UPT_A017828_20200804T184659/", layers=:swir1))) == :B11

    # Test Layer Parsing (10m)
    test_layers(Sentinel2{10}, "data/answers.json", "sentinel2_10", "data/L2A_T11UPT_A017828_20200804T184659/")
    @test_throws ArgumentError getlayers(Sentinel2{10}, "data/L2A_T11UPT_A017828_20200804T184659/", layers=:swir1)
    @test first(keys(getlayers(Sentinel2{10}, "data/L2A_T11UPT_A017828_20200804T184659/", layers=:red))) == :B04

    # Test Raster
    s10 = (10980, 10980)
    @test_throws ArgumentError Raster(Sentinel2{10}, "data/L2A_T11UPT_A017828_20200804T184659/", :swir1)
    @test_throws ArgumentError Raster(Sentinel2{10}, "data/L2A_T11UPT_A017828_20200804T184659/", :swir2)
    @test_throws ArgumentError Raster(Sentinel2{10}, "data/L2A_T11UPT_A017828_20200804T184659/", :SCL)
    @test_throws ArgumentError Raster(Sentinel2{10}, "data/L2A_T11UPT_A017828_20200804T184659/")
    r_10 = Raster(Sentinel2{10}, "data/L2A_T11UPT_A017828_20200804T184659/", :red);
    r_20 = Raster(Sentinel2{20}, "data/L2A_T11UPT_A017828_20200804T184659/", :swir1);
    r_60 = Raster(Sentinel2{60}, "data/L2A_T11UPT_A017828_20200804T184659/", :swir1);
    @test size(r_10) == s10
    @test size(r_20) == (s10 ./ 2)
    @test size(r_60) == (s10 ./ 6)
end

@testset "RasterStack" begin
    # Load Test Data
    download_data(sentinel_link, sentinel_dst)

    # Load RasterStack
    rs_10 = RasterStack(Sentinel2{10}, "data/L2A_T11UPT_A017828_20200804T184659/", lazy=true)
    rs_60 = RasterStack(Sentinel2{60}, "data/L2A_T11UPT_A017828_20200804T184659/", lazy=true)

    # Test Colors
    @test name(blue(Sentinel2{20}, rs_60)) == :B02
    @test name(green(Sentinel2{20}, rs_60)) == :B03
    @test name(red(Sentinel2{20}, rs_60)) == :B04
    @test name(nir(Sentinel2{20}, rs_60)) == :B8A
    @test name(nir(Sentinel2{10}, rs_10)) == :B08
    @test name(swir1(Sentinel2{20}, rs_60)) == :B11
    @test name(swir2(Sentinel2{20}, rs_60)) == :B12
end
