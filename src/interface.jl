"""
The super-type of all satellites. 

Sub-types must implement the `AbstractSatellite` interface.
"""
abstract type AbstractSatellite end

"""
    files(x::AbstractSatellite)

Return a list of files for the given satellite product.
"""
function files end

"""
    bands(::Type{AbstractSatellite})

Return the band names in order from shortest to longest wavelength.
"""
function bands end

"""
    layers(::Type{AbstractSatellite})
    layers(x::AbstractSatellite)

Return the names of all layers available for the given sensor.

# Example
```julia
# Get all Available Layers for Landsat 8
landsat_layers = layers(Landsat8)

# Get all Available Layers for a Specific Scene
src = Landsat8("LC08_L2SP_043024_20200802_20200914_02_T1")
available_layers = layers(src)
```
"""
function layers end

"""
    wavelengths(::Type{AbstractSatellite})

Return the central wavelengths for all bands in order from shortest to longest.
"""
function wavelengths end

"""
    blue_band(::Type{AbstractSatellite})

Return the blue band for the given sensor.
"""
blue_band(::Type{T}) where {T <: AbstractSatellite} = error("Error: Band 'blue' not defined for $(T)!")

"""
    green_band(::Type{AbstractSatellite})

Return the green band for the given sensor.
"""
green_band(::Type{T}) where {T <: AbstractSatellite} = error("Error: Band 'green' not defined for $(T)!")

"""
    red_band(::Type{AbstractSatellite})

Return the red band for the given sensor.
"""
red_band(::Type{T}) where {T <: AbstractSatellite} = error("Error: Band 'red' not defined for $(T)!")

"""
    nir_band(::Type{AbstractSatellite})

Return the nir band for the given sensor.
"""
nir_band(::Type{T}) where {T <: AbstractSatellite} = error("Error: Band 'nir' not defined for $(T)!")

"""
    swir1_band(::Type{AbstractSatellite})

Return the swir1 band for the given sensor.
"""
swir1_band(::Type{T}) where {T <: AbstractSatellite} = error("Error: Band 'swir1' not defined for $(T)!")

"""
    swir2_band(::Type{AbstractSatellite})

Return the swir2 band for the given sensor.
"""
swir2_band(::Type{T}) where {T <: AbstractSatellite} = error("Error: Band 'swir2' not defined for $(T)!")

"""
    dn_scale(::Type{AbstractSatellite}, layer::Symbol)

Return the scale factor applied to digital numbers.
"""
dn_scale(::Type{<:AbstractSatellite}, layer::Symbol) = 1.0f0

"""
    dn_offset(::Type{AbstractSatellite}, layer::Symbol)

Return the offset factor applied to digital numbers.
"""
dn_offset(::Type{<:AbstractSatellite}, layer::Symbol) = 0.0f0

"""
    layer_source(::Type{AbstractSatellite}, layer::Symbol)

Retrieve the `AbstractLayerSource` for the given layer and sensor type.
"""
function layer_source end

"""
    metadata(x::AbstractSatellite)

Parses the metadata fields for the given satellite scene.

Metadata varies between products, but typically includes the acquisition date and processing level.
"""
function metadata end

"""
    wavelength(::Type{AbstractSatellite}, band::Symbol)

Return the central wavelength for the corresponding band.
"""
function wavelength(::Type{T}, band::Symbol) where {T <: AbstractSatellite}
    !(band in bandnames(T)) && throw(ArgumentError("$band not found in bands $(bandnames(T))!"))
    return @pipe findfirst(isequal(band), bandnames(T)) |> wavelengths(T)[_]
end

function layers(x::T) where {T <: AbstractSatellite}
    sources = [(layer, layer_source(T, translate_color(T, layer))) for layer in layers(T)]
    return [layer for (layer, src) in sources if !isnothing(parse_file(src, files(x)))]
end

"""
    translate_color(::Type{AbstractSatellite}, layer::Symbol)

Translates a color such as `:red`, `:green`, or `:blue` to the corresponding band name.

# Example
```julia
julia> translate_color(Landsat8, :red)
:B4

julia> translate_color(Sentinel2{10}, :nir)
:B08

julia> translate_color(Sentinel2{20}, :nir)
:B8A
```
"""
function translate_color(::Type{T}, layer::Symbol) where {T <: AbstractSatellite}
    @match layer begin
        :blue => blue_band(T)
        :green => green_band(T)
        :red => red_band(T)
        :nir => nir_band(T)
        :swir1 => swir1_band(T)
        :swir2 => swir2_band(T)
        _ => layer
    end
end

function Base.show(io::IO, ::MIME"text/plain", x::T) where T <: AbstractSatellite
    printstyled(io, "$T(")
    printstyled(io, "\"$(x.src)\"", color=:black)
    printstyled(io, ")")
    for (k, v) in metadata(x)
        printstyled(io, "\n  $k", color=:red)
        printstyled(io, " $v")
    end
    if isempty(metadata(x))
        printstyled(io, "\n  No Metadata", color=:red)
    end
end