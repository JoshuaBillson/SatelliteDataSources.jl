function _get_files(dir::String)
    vcat([map(x -> joinpath(root, x), files) for (root, _, files) in walkdir(dir)]...)
end

function _band_regex(bands::Vector{Symbol})

    return "_" * capture(either(string.(bands)...), as="layer") * "." * ["TIF", "tif", "tiff", "TIFF", "JP2", "jp2"] * END
end

function _parse_layer(regexp, filename::String)
    m = match(regexp, filename)
    return !isnothing(m) ? (Symbol(m[:layer]), filename) : (nothing, filename)
end

function _parse_layer(regexp, filename::String, layername::Symbol)
    m = match(regexp, filename)
    return !isnothing(m) ? (layername, filename) : (nothing, filename)
end

function _parse_layers(regexp, files::Vector{String})
    return @pipe map(x -> _parse_layer(regexp, x), files) |> filter(!isnothing ∘ first, _)
end

function _parse_layers(regexp, files::Vector{String}, layername::Symbol)
    return @pipe map(x -> _parse_layer(regexp, x, layername), files) |> filter(!isnothing ∘ first, _)
end

function _translate_color(::Type{T}, color::Symbol) where {T <: AbstractBandset}
    colordict = Dict([:blue => blue_band(T), :green => green_band(T), :red => red_band(T), :nir => nir_band(T), :swir1 => swir1_band(T), :swir2 => swir2_band(T)])
    return color in keys(colordict) ? colordict[color] : color
end