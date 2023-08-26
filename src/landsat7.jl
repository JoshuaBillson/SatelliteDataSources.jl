struct Landsat7 <: AbstractSatellite end

bandnames(::Type{Landsat7}) = [:B1, :B2, :B3, :B4, :B5, :B7]

layernames(::Type{Landsat7}) = [bandnames(Landsat7)..., :blue, :green, :red, :nir, :swir1, :swir2, :QA]

wavelengths(::Type{Landsat7}) = [483, 560, 660, 835, 1650, 2220]

blue_band(::Type{Landsat7}) = :B1

green_band(::Type{Landsat7}) = :B2

red_band(::Type{Landsat7}) = :B3

nir_band(::Type{Landsat7}) = :B4

swir1_band(::Type{Landsat7}) = :B5

swir2_band(::Type{Landsat7}) = :B7

dn_scale(::Type{Landsat7}) = 0.0000275f0

dn_offset(::Type{Landsat7}) = -0.2f0

function parse_layers(::Type{Landsat7}, dir::String)
    # Construct Regex
    band_regex = _band_regex(bandnames(Landsat7))
    qa_regex = "QA_PIXEL." * either("TIF", "tif", "jp2") * END

    # Parse Bands From Files
    files = _get_files(dir)
    parsed_bands = _parse_layers(band_regex, files) 
    parsed_qa = _parse_layers(qa_regex, files, :QA) 
    return vcat(parsed_bands, parsed_qa) |> Dict
end