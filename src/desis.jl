struct DESIS <: AbstractSatellite end

bandnames(::Type{DESIS}) = Symbol.(["Band_$i" for i in 1:235])

layernames(::Type{DESIS}) = [:bands, :QA]

wavelengths(::Type{DESIS}) = collect(401.275:2.553:998.75)

blue_band(::Type{DESIS}) = 25

green_band(::Type{DESIS}) = 52

red_band(::Type{DESIS}) = 90

nir_band(::Type{DESIS}) = 175

decode_dn(::Type{DESIS}, dn::Number) = dn * 0.0001f0

function parse_layers(::Type{DESIS}, dir::String)
    # Construct Regex
    band_regex = "SPECTRAL_IMAGE." * either("TIF", "tif", "jp2") * END
    qa_regex = "QL_QUALITY-2." * either("TIF", "tif", "jp2") * END

    # Parse Bands From Files
    files = _get_files(dir)
    parsed_bands = _parse_layers(band_regex, files, :bands) 
    parsed_qa = _parse_layers(qa_regex, files, :QA) 
    return vcat(parsed_bands, parsed_qa) |> Dict
end

function getlayers(::Type{DESIS}, dir::String; layers=:bands)
    # Handle Single Layers
    layers = layers isa AbstractVector ? layers : [layers]

    # Check That Layer is Valid
    for layer in layers
        layer in layernames(DESIS) || throw(ArgumentError("Layer '$layer' is not valid for '$T'!"))
    end

    # Get All Layers
    all_layers = parse_layers(DESIS, dir)

    # Confirm That Requested Layers Are Available
    for layer in layers
        layer in keys(all_layers) || throw(ArgumentError("Layer '$layer' could not found!"))
    end

    # Return Requested Layers
    return OrderedDict([layer => all_layers[layer] for layer in layers])
end