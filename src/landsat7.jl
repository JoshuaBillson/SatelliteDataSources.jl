struct Landsat7 <: AbstractBandset end

bandnames(::Type{Landsat7}) = [:B1, :B2, :B3, :B4, :B5, :B7]

layernames(::Type{Landsat7}) = [bandnames(Landsat7)..., :blue, :green, :red, :nir, :swir1, :swir2, :QA, :bands]

wavelengths(::Type{Landsat7}) = [483, 560, 660, 835, 1650, 2220]

blue_band(::Type{Landsat7}) = :B1

green_band(::Type{Landsat7}) = :B2

red_band(::Type{Landsat7}) = :B3

nir_band(::Type{Landsat7}) = :B4

swir1_band(::Type{Landsat7}) = :B5

swir2_band(::Type{Landsat7}) = :B7

function parse_layers(::Type{Landsat7}, dir::String)
    # Construct Regex
    band_regex = _band_regex(bandnames(Landsat7))
    qa_regex = BEGIN * zero_or_more(ANY) * "QA_PIXEL." * either("TIF", "tif", "jp2") * END

    # Parse Bands From Files
    files = readdir(dir, join=true)
    parsed_bands = @pipe map(x -> _parse_layer(band_regex, x), files) |> zip(_, files) |> collect
    parsed_qa = @pipe map(x -> _parse_layer(qa_regex, x, :QA), files) |> zip(_, files) |> collect
    return @pipe vcat(parsed_bands, parsed_qa) |> filter(!isnothing ∘ first, _) |> Dict
end