"""
Implements the `AbstractSatellite` interface for Sentinel 2.
"""
struct Sentinel2{R} <: AbstractSatellite end

bandnames(::Type{<:Sentinel2}) = error("Error: Must specify spatial resolution for Sentinel 2!")

wavelengths(::Type{<:Sentinel2}) = error("Error: Must specify spatial resolution for Sentinel 2!")

layernames(::Type{<:Sentinel2}) = error("Error: Must specify spatial resolution for Sentinel 2!")

bandnames(::Type{Sentinel2{60}}) = [:B01, :B02, :B03, :B04, :B05, :B06, :B07, :B8A, :B09, :B11, :B12]

wavelengths(::Type{Sentinel2{60}}) = [443, 490, 560, 665, 705, 740, 783, 865, 945, 1610, 2190]

layernames(::Type{Sentinel2{60}}) = [bandnames(Sentinel2{60})..., :blue, :green, :red, :nir, :swir1, :swir2, :SCL]

bandnames(::Type{Sentinel2{20}}) = [:B02, :B03, :B04, :B05, :B06, :B07, :B8A, :B11, :B12]

wavelengths(::Type{Sentinel2{20}}) = [490, 560, 665, 705, 740, 783, 865, 1610, 2190]

layernames(::Type{Sentinel2{20}}) = [bandnames(Sentinel2{20})..., :blue, :green, :red, :nir, :swir1, :swir2, :SCL]

bandnames(::Type{Sentinel2{10}}) = [:B02, :B03, :B04, :B08]

wavelengths(::Type{Sentinel2{10}}) = [490, 560, 665, 842]

layernames(::Type{Sentinel2{10}}) = [bandnames(Sentinel2{10})..., :blue, :green, :red, :nir]

blue_band(::Type{<:Sentinel2}) = :B02

green_band(::Type{<:Sentinel2}) = :B03

red_band(::Type{<:Sentinel2}) = :B04

nir_band(::Type{Sentinel2{10}}) = :B08

nir_band(::Type{<:Sentinel2}) = :B8A

swir1_band(::Type{Sentinel2{20}}) = :B11

swir1_band(::Type{Sentinel2{60}}) = :B11

swir2_band(::Type{Sentinel2{20}}) = :B12

swir2_band(::Type{Sentinel2{60}}) = :B12

function parse_layers(::Type{T}, dir::String) where {T <: Sentinel2}
    # Construct Regex
    band_regex = "_" * capture(either(string.(bandnames(T))...), as="layer") * zero_or_more(ANY) * "." * ["TIF", "tif", "jp2"] * END
    scl_regex = "SCL_" * either("60m", "20m") * "." * either("TIF", "tif", "jp2") * END

    # Parse Bands From Files
    res = "R$(T.parameters[1])m"
    files = filter(x -> res in splitpath(x), _get_files(dir))
    parsed_bands = _parse_layers(band_regex, files) 
    parsed_scl = _parse_layers(scl_regex, files, :SCL) 
    return vcat(parsed_bands, parsed_scl) |> Dict
end