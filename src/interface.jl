"""
The supertype of all sensor types. Provides sensor-specific information to many `RemoteSensingToolbox` methods.
"""
abstract type AbstractBandset end

"""
    bandnames(::Type{AbstractBandset})

Return the band names in order from shortest to longest wavelength.
"""
bandnames(::Type{T}) where {T <: AbstractBandset} = error("Error: `bands` not defined for '$(T)'!")

"""
    layernames(::Type{AbstractBandset})

Return the names of all layers available for the given sensor.
"""
layernames(::Type{T}) where {T <: AbstractBandset} = error("Error: `layernames` not defined for '$(T)'!")

"""
    wavelengths(::Type{AbstractBandset})

Return the central wavelengths for all bands in order from shortest to longest.
"""
wavelengths(::Type{T}) where {T <: AbstractBandset} = error("Error: `wavelengths` not defined for '$(T)'!")

"""
    wavelength(::Type{AbstractBandset}, band::Symbol)

Return the central wavelength for the corresponding band.
"""
function wavelength(::Type{T}, band::Symbol) where {T <: AbstractBandset}
    !(band in bandnames(T)) && throw(ArgumentError("$band not found in bands $(bandnames(T))!"))
    return @pipe findfirst(isequal(band), bandnames(T)) |> wavelengths(T)[_]
end

"""
    blue_band(::Type{AbstractBandset})

Return the blue band for the given sensor.
"""
blue_band(::Type{T}) where {T <: AbstractBandset} = error("Error: Band 'blue' not defined for $(T)!")

"""
    green_band(::Type{AbstractBandset})

Return the green band for the given sensor.
"""
green_band(::Type{T}) where {T <: AbstractBandset} = error("Error: Band 'green' not defined for $(T)!")

"""
    red_band(::Type{AbstractBandset})

Return the red band for the given sensor.
"""
red_band(::Type{T}) where {T <: AbstractBandset} = error("Error: Band 'red' not defined for $(T)!")

"""
    nir_band(::Type{AbstractBandset})

Return the nir band for the given sensor.
"""
nir_band(::Type{T}) where {T <: AbstractBandset} = error("Error: Band 'nir' not defined for $(T)!")

"""
    swir1_band(::Type{AbstractBandset})

Return the swir1 band for the given sensor.
"""
swir1_band(::Type{T}) where {T <: AbstractBandset} = error("Error: Band 'swir1' not defined for $(T)!")

"""
    swir2_band(::Type{AbstractBandset})

Return the swir2 band for the given sensor.
"""
swir2_band(::Type{T}) where {T <: AbstractBandset} = error("Error: Band 'swir2' not defined for $(T)!")

"""
    getlayers(::Type{AbstractBandset}, dir::String)

Retrieve all layers in the provided directory. Returns a dictionary where layer names are keys and filenames are values.
"""
getlayers(::Type{T}, dir::String) where {T <: AbstractBandset} = error("Error: Band 'swir2' not defined for $(T)!")

function getlayers(::Type{T}, dir::String; layers=bandnames(T)) where {T <: AbstractBandset}
    # Handle Single Layers
    layers = layers isa AbstractVector ? layers : [layers]

    # Check That Layer is Valid
    for layer in layers
        layer in layernames(T) || throw(ArgumentError("Layer '$layer' is not valid for '$T'!"))
    end

    # Get All Layers
    all_layers = parse_layers(T, dir)

    # Replace Colors With Bands
    layers = _translate_color.(T, layers)

    # Confirm That Requested Layers Are Available
    for layer in layers
        layer in keys(all_layers) || throw(ArgumentError("Layer '$layer' could not found!"))
    end

    # Return Requested Layers
    return Dict([k => v for (k, v) in all_layers if k in layers])
end