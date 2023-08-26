"""
Implements the `AbstractSatellite` interface for Landsat 8.

Supported layers are: (:B1, :B2, :B3, :B4, :B5, :B6, :B7, :blue, :green, :red, :nir, :swir1, :swir2, :QA, :bands).
"""
struct Landsat8 <: AbstractSatellite end

bandnames(::Type{Landsat8}) = [:B1, :B2, :B3, :B4, :B5, :B6, :B7]

layernames(::Type{Landsat8}) = [bandnames(Landsat8)..., :blue, :green, :red, :nir, :swir1, :swir2, :QA]

wavelengths(::Type{Landsat8}) = [443, 483, 560, 660, 865, 1650, 2220]

blue_band(::Type{Landsat8}) = :B2

green_band(::Type{Landsat8}) = :B3

red_band(::Type{Landsat8}) = :B4

nir_band(::Type{Landsat8}) = :B5

swir1_band(::Type{Landsat8}) = :B6

swir2_band(::Type{Landsat8}) = :B7

dn_scale(::Type{Landsat8}) = 0.0000275f0

dn_offset(::Type{Landsat8}) = -0.2f0

function parse_layers(::Type{Landsat8}, dir::String)
    # Construct Regex
    band_regex = _band_regex(bandnames(Landsat8))
    qa_regex = "QA_PIXEL." * either("TIF", "tif", "jp2") * END

    # Parse Bands From Files
    files = _get_files(dir)
    parsed_bands = _parse_layers(band_regex, files) 
    parsed_qa = _parse_layers(qa_regex, files, :QA) 
    return vcat(parsed_bands, parsed_qa) |> Dict
end