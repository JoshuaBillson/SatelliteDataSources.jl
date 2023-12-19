using SatelliteDataSources
using Test, Fetch, JSON, Rasters, ArchGDAL, DataDeps
using Match: @match

include("utils.jl")

const sentinel_link = "https://drive.google.com/file/d/1P7TSPf_GxYtyOYat3iIui1hbjvb7H6a0/view?usp=sharing"
const sentinel_hash = "4135c6192a314e0d08d21cf44ca3cde0f34f1968854275e32656278ca163a3e0"
const landsat_link = "https://drive.google.com/file/d/1S5H_oyWZZInOzJK4glBCr6LgXSADzhOV/view?usp=sharing"
const landsat_hash = "2ce24abc359d30320213237d78101d193cdb8433ce21d1f7e9f08ca140cf5785"
const landsat9_link = "https://drive.google.com/file/d/1PJ0zFqbmVZROwdprZfXrxz-TaVRSevMJ/view?usp=sharing"
const landsat9_hash = "78db0f61d8b2ba09d9238d2a14887e1692cf410dab9f0c15356806b1fbea7e71"

ENV["DATADEPS_ALWAYS_ACCEPT"] = true
ENV["DATADEPS_LOAD_PATH"] = joinpath(pwd(), "data")

@testset "Interface" begin
    struct DummySatellite <: AbstractSatellite end
    @test_throws MethodError bands(DummySatellite)
    @test_throws MethodError layers(DummySatellite)
    @test_throws MethodError wavelengths(DummySatellite)
    @test_throws MethodError layer_source(DummySatellite, :foo)
    @test_throws MethodError SatelliteDataSources.metadata(DummySatellite())
    @test_throws ErrorException blue_band(DummySatellite)
    @test_throws ErrorException green_band(DummySatellite)
    @test_throws ErrorException red_band(DummySatellite)
    @test_throws ErrorException nir_band(DummySatellite)
    @test_throws ErrorException swir1_band(DummySatellite)
    @test_throws ErrorException swir2_band(DummySatellite)
    @test dn_scale(DummySatellite, :foo) == 1.0f0
    @test dn_offset(DummySatellite, :foo) == 0.0f0
end

@testset "Landsat 7" begin
    # Load Test Data
    register(DataDep("LC08_L2SP_043024_20200802_20200914_02_T1", """Landsat 8 Test Data""", landsat_link, landsat_hash, fetch_method=gdownload, post_fetch_method=unpack))

    # Test Specifications
    @test all(bands(Landsat7) .== [:B1, :B2, :B3, :B4, :B5, :B7])
    @test all(layers(Landsat7) .== [:B1, :B2, :B3, :B4, :B5, :B7, :blue, :green, :red, :nir, :swir1, :swir2, :panchromatic, :thermal, :dilated_clouds, :clouds, :cloud_shadow, :snow, :water])
    @test all(wavelengths(Landsat7) .== [483, 560, 660, 835, 1650, 2220])
    test_dn_scale(Landsat7, [:B1, :B2, :B3, :B4, :B5, :B7], 0.0000275f0)
    test_dn_scale(Landsat7, [:thermal], 0.00341802f0)
    test_dn_offset(Landsat7, [:B1, :B2, :B3, :B4, :B5, :B7], -0.2f0)
    test_dn_offset(Landsat7, [:thermal], 149.0f0)

    # Test Color Mapping
    colors = Dict([:blue => :B1, :green => :B2, :red => :B3, :nir => :B4, :swir1 => :B5, :swir2 => :B7])
    test_colors(Landsat7, colors)

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
    test_dn_scale(Landsat8, [:B1, :B2, :B3, :B4, :B5, :B6, :B7], 0.0000275f0)
    test_dn_scale(Landsat8, [:thermal1, :thermal2], 0.00341802f0)
    test_dn_offset(Landsat8, [:B1, :B2, :B3, :B4, :B5, :B6, :B7], -0.2f0)
    test_dn_offset(Landsat8, [:thermal1, :thermal2], 149.0f0)

    # Test Color Mapping
    colors = Dict([:blue => :B2, :green => :B3, :red => :B4, :nir => :B5, :swir1 => :B6, :swir2 => :B7])
    test_colors(Landsat8, colors)

    # Test Layer Parsing
    landsat = Landsat8(datadep"LC08_L2SP_043024_20200802_20200914_02_T1")
    r1 = Raster(landsat, :B1, lazy=true)
    r2 = Raster(landsat, :B2, lazy=true)
    r3 = Raster(landsat, :B3, lazy=true)
    r4 = Raster(landsat, :B4, lazy=true)
    r5 = Raster(landsat, :B5, lazy=true)
    r6 = Raster(landsat, :B6, lazy=true)
    r7 = Raster(landsat, :B7, lazy=true)
    rt = Raster(landsat, :thermal1, lazy=true)
    @test !isnothing(match(r"LC08_L2SP_043024_20200802_20200914_02_T1_SR_B1.TIF$", r1.metadata["filepath"]))
    @test !isnothing(match(r"LC08_L2SP_043024_20200802_20200914_02_T1_SR_B2.TIF$", r2.metadata["filepath"]))
    @test !isnothing(match(r"LC08_L2SP_043024_20200802_20200914_02_T1_SR_B3.TIF$", r3.metadata["filepath"]))
    @test !isnothing(match(r"LC08_L2SP_043024_20200802_20200914_02_T1_SR_B4.TIF$", r4.metadata["filepath"]))
    @test !isnothing(match(r"LC08_L2SP_043024_20200802_20200914_02_T1_SR_B5.TIF$", r5.metadata["filepath"]))
    @test !isnothing(match(r"LC08_L2SP_043024_20200802_20200914_02_T1_SR_B6.TIF$", r6.metadata["filepath"]))
    @test !isnothing(match(r"LC08_L2SP_043024_20200802_20200914_02_T1_SR_B7.TIF$", r7.metadata["filepath"]))
    @test !isnothing(match(r"LC08_L2SP_043024_20200802_20200914_02_T1_ST_B10.TIF$", rt.metadata["filepath"]))

    # Test Masks
    mask_layers = [:dilated_clouds, :clouds, :cloud_shadow, :snow, :water]
    masks = RasterStack(landsat, mask_layers)
    qa = Raster(datadep"LC08_L2SP_043024_20200802_20200914_02_T1/LC08_L2SP_043024_20200802_20200914_02_T1/LC08_L2SP_043024_20200802_20200914_02_T1_QA_PIXEL.TIF")
    for layer in mask_layers
        @test all(get_landsat_mask(qa, layer) .== masks[layer])
    end

    # Test Metadata Parsing
    md = SatelliteDataSources.metadata(landsat)
    @test md["product"] == "LC08"
    @test md["level"] == "L2SP"
    @test md["collection"] == "02"
    @test string(md["acquired"]) == "2020-08-02"
    @test string(md["processed"]) == "2020-09-14"
end

@testset "Landsat 9" begin
    # Load Test Data
    register(DataDep("LC09_L2SP_042023_20220825_20230401_02_T1", """Landsat 9 Test Data""", landsat9_link, landsat9_hash, fetch_method=gdownload, post_fetch_method=unpack))

    # Test Specifications
    @test all(bands(Landsat9) .== [:B1, :B2, :B3, :B4, :B5, :B6, :B7])
    @test all(layers(Landsat9) .== [:B1, :B2, :B3, :B4, :B5, :B6, :B7, :blue, :green, :red, :nir, :swir1, :swir2, :panchromatic, :thermal1, :thermal2, :dilated_clouds, :clouds, :cloud_shadow, :snow, :water])
    @test all(wavelengths(Landsat9) .== [443, 483, 560, 660, 865, 1650, 2220])
    test_dn_scale(Landsat9, [:B1, :B2, :B3, :B4, :B5, :B6, :B7], 0.0000275f0)
    test_dn_scale(Landsat9, [:thermal1, :thermal2], 0.00341802f0)
    test_dn_offset(Landsat9, [:B1, :B2, :B3, :B4, :B5, :B6, :B7], -0.2f0)
    test_dn_offset(Landsat9, [:thermal1, :thermal2], 149.0f0)

    # Test Color Mapping
    colors = Dict([:blue => :B2, :green => :B3, :red => :B4, :nir => :B5, :swir1 => :B6, :swir2 => :B7])
    test_colors(Landsat9, colors)

    # Test Layer Parsing
    src = Landsat9(datadep"LC09_L2SP_042023_20220825_20230401_02_T1")
    r1 = Raster(src, :B1, lazy=true)
    r2 = Raster(src, :B2, lazy=true)
    r3 = Raster(src, :B3, lazy=true)
    r4 = Raster(src, :B4, lazy=true)
    r5 = Raster(src, :B5, lazy=true)
    r6 = Raster(src, :B6, lazy=true)
    r7 = Raster(src, :B7, lazy=true)
    rt = Raster(src, :thermal1, lazy=true)
    @test !isnothing(match(r"LC09_L2SP_042023_20220825_20230401_02_T1_SR_B1.TIF$", r1.metadata["filepath"]))
    @test !isnothing(match(r"LC09_L2SP_042023_20220825_20230401_02_T1_SR_B2.TIF$", r2.metadata["filepath"]))
    @test !isnothing(match(r"LC09_L2SP_042023_20220825_20230401_02_T1_SR_B3.TIF$", r3.metadata["filepath"]))
    @test !isnothing(match(r"LC09_L2SP_042023_20220825_20230401_02_T1_SR_B4.TIF$", r4.metadata["filepath"]))
    @test !isnothing(match(r"LC09_L2SP_042023_20220825_20230401_02_T1_SR_B5.TIF$", r5.metadata["filepath"]))
    @test !isnothing(match(r"LC09_L2SP_042023_20220825_20230401_02_T1_SR_B6.TIF$", r6.metadata["filepath"]))
    @test !isnothing(match(r"LC09_L2SP_042023_20220825_20230401_02_T1_SR_B7.TIF$", r7.metadata["filepath"]))
    @test !isnothing(match(r"LC09_L2SP_042023_20220825_20230401_02_T1_ST_B10.TIF$", rt.metadata["filepath"]))

    # Test Masks
    mask_layers = [:dilated_clouds, :clouds, :cloud_shadow, :snow, :water]
    masks = RasterStack(src, mask_layers)
    qa = Raster(datadep"LC09_L2SP_042023_20220825_20230401_02_T1/LC09_L2SP_042023_20220825_20230401_02_T1/LC09_L2SP_042023_20220825_20230401_02_T1_QA_PIXEL.TIF")
    for layer in mask_layers
        @test all(get_landsat_mask(qa, layer) .== masks[layer])
    end

    # Test Metadata Parsing
    md = SatelliteDataSources.metadata(src)
    @test md["product"] == "LC09"
    @test md["level"] == "L2SP"
    @test md["collection"] == "02"
    @test string(md["acquired"]) == "2022-08-25"
    @test string(md["processed"]) == "2023-04-01"
end

@testset "Sentinel 2" begin
    # Load Test Data
    register(DataDep("S2B_MSIL2A_20200804T183919_N0214_R070_T11UPT_20200804T230343", """Sentinel 2 Test Data""", sentinel_link, sentinel_hash, fetch_method=gdownload, post_fetch_method=unpack))

    # Test Specifications (10m)
    @test all(bands(Sentinel2{10}) .== [:B02, :B03, :B04, :B08])
    @test all(layers(Sentinel2{10}) .== [:B02, :B03, :B04, :B08, :blue, :green, :red, :nir])
    @test all(wavelengths(Sentinel2{10}) .== [490, 560, 665, 842])
    test_dn_scale(Sentinel2{10}, [:B01, :B02, :B03, :B04, :B05, :B06, :B07, :B8A, :B09, :B11, :B12], 0.0001f0)
    test_dn_offset(Sentinel2{10}, [:B01, :B02, :B03, :B04, :B05, :B06, :B07, :B8A, :B09, :B11, :B12], 0.0f0)

    # Test Specifications (20m)
    @test all(bands(Sentinel2{20}) .== [:B02, :B03, :B04, :B05, :B06, :B07, :B8A, :B11, :B12])
    @test all(layers(Sentinel2{20}) .== [:B02, :B03, :B04, :B05, :B06, :B07, :B8A, :B11, :B12, :blue, :green, :red, :nir, :swir1, :swir2, :cloud_shadow, :clouds_med, :clouds_high, :cirrus, :vegetation, :soil, :water, :snow])
    @test all(wavelengths(Sentinel2{20}) .== [490, 560, 665, 705, 740, 783, 865, 1610, 2190])
    test_dn_scale(Sentinel2{20}, [:B01, :B02, :B03, :B04, :B05, :B06, :B07, :B8A, :B09, :B11, :B12], 0.0001f0)
    test_dn_offset(Sentinel2{20}, [:B01, :B02, :B03, :B04, :B05, :B06, :B07, :B8A, :B09, :B11, :B12], 0.0f0)

    # Test Specifications (60m)
    @test all(bands(Sentinel2{60}) .== [:B01, :B02, :B03, :B04, :B05, :B06, :B07, :B8A, :B09, :B11, :B12])
    @test all(layers(Sentinel2{60}) .== [:B01, :B02, :B03, :B04, :B05, :B06, :B07, :B8A, :B09, :B11, :B12, :blue, :green, :red, :nir, :swir1, :swir2, :cloud_shadow, :clouds_med, :clouds_high, :cirrus, :vegetation, :soil, :water, :snow])
    @test all(wavelengths(Sentinel2{60}) .== [443, 490, 560, 665, 705, 740, 783, 865, 945, 1610, 2190])
    test_dn_scale(Sentinel2{60}, [:B01, :B02, :B03, :B04, :B05, :B06, :B07, :B8A, :B09, :B11, :B12], 0.0001f0)
    test_dn_offset(Sentinel2{60}, [:B01, :B02, :B03, :B04, :B05, :B06, :B07, :B8A, :B09, :B11, :B12], 0.0f0)

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
    sentinel_60 = Sentinel2{60}(datadep"S2B_MSIL2A_20200804T183919_N0214_R070_T11UPT_20200804T230343")
    r01 = Raster(sentinel_60, :B01, lazy=true)
    r02 = Raster(sentinel_60, :B02, lazy=true)
    r03 = Raster(sentinel_60, :B03, lazy=true)
    r04 = Raster(sentinel_60, :B04, lazy=true)
    r05 = Raster(sentinel_60, :B05, lazy=true)
    r06 = Raster(sentinel_60, :B06, lazy=true)
    r07 = Raster(sentinel_60, :B07, lazy=true)
    r8A = Raster(sentinel_60, :B8A, lazy=true)
    r09 = Raster(sentinel_60, :B09, lazy=true)
    r11 = Raster(sentinel_60, :B11, lazy=true)
    r12 = Raster(sentinel_60, :B12, lazy=true)
    @test !isnothing(match(r"T11UPT_20200804T183919_B01_60m.jp2$", r01.metadata["filepath"]))
    @test !isnothing(match(r"T11UPT_20200804T183919_B02_60m.jp2$", r02.metadata["filepath"]))
    @test !isnothing(match(r"T11UPT_20200804T183919_B03_60m.jp2$", r03.metadata["filepath"]))
    @test !isnothing(match(r"T11UPT_20200804T183919_B04_60m.jp2$", r04.metadata["filepath"]))
    @test !isnothing(match(r"T11UPT_20200804T183919_B05_60m.jp2$", r05.metadata["filepath"]))
    @test !isnothing(match(r"T11UPT_20200804T183919_B06_60m.jp2$", r06.metadata["filepath"]))
    @test !isnothing(match(r"T11UPT_20200804T183919_B07_60m.jp2$", r07.metadata["filepath"]))
    @test !isnothing(match(r"T11UPT_20200804T183919_B8A_60m.jp2$", r8A.metadata["filepath"]))
    @test !isnothing(match(r"T11UPT_20200804T183919_B09_60m.jp2$", r09.metadata["filepath"]))
    @test !isnothing(match(r"T11UPT_20200804T183919_B11_60m.jp2$", r11.metadata["filepath"]))
    @test !isnothing(match(r"T11UPT_20200804T183919_B12_60m.jp2$", r12.metadata["filepath"]))

    # Test Layer Parsing (20m)
    sentinel_20 = Sentinel2{20}(datadep"S2B_MSIL2A_20200804T183919_N0214_R070_T11UPT_20200804T230343")
    r02 = Raster(sentinel_20, :B02, lazy=true)
    r03 = Raster(sentinel_20, :B03, lazy=true)
    r04 = Raster(sentinel_20, :B04, lazy=true)
    r05 = Raster(sentinel_20, :B05, lazy=true)
    r06 = Raster(sentinel_20, :B06, lazy=true)
    r07 = Raster(sentinel_20, :B07, lazy=true)
    r8A = Raster(sentinel_20, :B8A, lazy=true)
    r11 = Raster(sentinel_20, :B11, lazy=true)
    r12 = Raster(sentinel_20, :B12, lazy=true)
    @test !isnothing(match(r"T11UPT_20200804T183919_B02_20m.jp2$", r02.metadata["filepath"]))
    @test !isnothing(match(r"T11UPT_20200804T183919_B03_20m.jp2$", r03.metadata["filepath"]))
    @test !isnothing(match(r"T11UPT_20200804T183919_B04_20m.jp2$", r04.metadata["filepath"]))
    @test !isnothing(match(r"T11UPT_20200804T183919_B05_20m.jp2$", r05.metadata["filepath"]))
    @test !isnothing(match(r"T11UPT_20200804T183919_B06_20m.jp2$", r06.metadata["filepath"]))
    @test !isnothing(match(r"T11UPT_20200804T183919_B07_20m.jp2$", r07.metadata["filepath"]))
    @test !isnothing(match(r"T11UPT_20200804T183919_B8A_20m.jp2$", r8A.metadata["filepath"]))
    @test !isnothing(match(r"T11UPT_20200804T183919_B11_20m.jp2$", r11.metadata["filepath"]))
    @test !isnothing(match(r"T11UPT_20200804T183919_B12_20m.jp2$", r12.metadata["filepath"]))

    # Test Layer Parsing (10m)
    sentinel_10 = Sentinel2{10}(datadep"S2B_MSIL2A_20200804T183919_N0214_R070_T11UPT_20200804T230343")
    r02 = Raster(sentinel_10, :B02, lazy=true)
    r03 = Raster(sentinel_10, :B03, lazy=true)
    r04 = Raster(sentinel_10, :B04, lazy=true)
    r08 = Raster(sentinel_10, :B08, lazy=true)
    @test !isnothing(match(r"T11UPT_20200804T183919_B02_10m.jp2$", r02.metadata["filepath"]))
    @test !isnothing(match(r"T11UPT_20200804T183919_B03_10m.jp2$", r03.metadata["filepath"]))
    @test !isnothing(match(r"T11UPT_20200804T183919_B04_10m.jp2$", r04.metadata["filepath"]))
    @test !isnothing(match(r"T11UPT_20200804T183919_B08_10m.jp2$", r08.metadata["filepath"]))

    # Test Masks
    mask_layers = [:cloud_shadow, :clouds_med, :clouds_high, :cirrus, :vegetation, :non_vegetated, :water, :snow]
    masks20 = RasterStack(sentinel_20, mask_layers)
    masks60 = RasterStack(sentinel_60, mask_layers)
    scl20 = Raster(datadep"S2B_MSIL2A_20200804T183919_N0214_R070_T11UPT_20200804T230343/S2B_MSIL2A_20200804T183919_N0214_R070_T11UPT_20200804T230343/GRANULE/L2A_T11UPT_A017828_20200804T184659/IMG_DATA/R20m/T11UPT_20200804T183919_SCL_20m.jp2")
    scl60 = Raster(datadep"S2B_MSIL2A_20200804T183919_N0214_R070_T11UPT_20200804T230343/S2B_MSIL2A_20200804T183919_N0214_R070_T11UPT_20200804T230343/GRANULE/L2A_T11UPT_A017828_20200804T184659/IMG_DATA/R60m/T11UPT_20200804T183919_SCL_60m.jp2")
    for layer in mask_layers
        @test all(get_sentinel_mask(scl20, layer) .== masks20[layer])
        @test all(get_sentinel_mask(scl60, layer) .== masks60[layer])
    end

    # Test Metadata Parsing
    md = SatelliteDataSources.metadata(sentinel_10)
    @test md["mission"] == "S2B"
    @test md["level"] == "L2A"
    @test md["tile"] == "11UPT"
    @test string(md["acquired"]) == "2020-08-04T18:39:19"
end

@testset "Rasters" begin
    # Load Test Data
    register(DataDep("LC08_L2SP_043024_20200802_20200914_02_T1", """Landsat 8 Test Data""", landsat_link, landsat_hash, fetch_method=gdownload, post_fetch_method=unpack))

    # Test Decode
    landsat = Landsat8(datadep"LC08_L2SP_043024_20200802_20200914_02_T1")
    original = RasterStack(landsat, [:B2, :B3, :B4])
    decoded = decode(Landsat8, original)
    encoded = encode(Landsat8, decoded)
    for layer in [:B2, :B3, :B4]
        @test all(original[layer] .== encoded[layer])
    end
end