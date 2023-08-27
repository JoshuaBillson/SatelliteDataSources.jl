"""
The supertype of all sensor types. Provides sensor-specific information to many `RemoteSensingToolbox` methods.
"""
abstract type AbstractSatellite end

"""
    bandnames(::Type{AbstractSatellite})

Return the band names in order from shortest to longest wavelength.
"""
function bandnames end

"""
    layernames(::Type{AbstractSatellite})

Return the names of all layers available for the given sensor.
"""
function layernames end

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
    parse_layers(::Type{AbstractSatellite}, dir::String)

Retrieve all layers in the provided directory. Returns a dictionary where layer names are keys and filenames are values.
"""
function parse_layers end

"""
    dn_scale(::Type{AbstractSatellite})

Return the scaling factor applied to digital numbers.
"""
dn_scale(::Type{T}) where {T <: AbstractSatellite} = 0.0001f0

"""
    dn_offset(::Type{AbstractSatellite})

Return the offset applied to digital numbers.
"""
dn_offset(::Type{T}) where {T <: AbstractSatellite} = 0.0f0


###################
# Derived Methods #
###################


"""
    wavelength(::Type{AbstractSatellite}, band::Symbol)

Return the central wavelength for the corresponding band.
"""
function wavelength(::Type{T}, band::Symbol) where {T <: AbstractSatellite}
    !(band in bandnames(T)) && throw(ArgumentError("$band not found in bands $(bandnames(T))!"))
    return @pipe findfirst(isequal(band), bandnames(T)) |> wavelengths(T)[_]
end

"""
    getlayers(::Type{T}, dir::String; layers=bandnames(T)) where {T <: AbstractSatellite}

Retrieve the requested layers in the provided directory. Returns a dictionary where layer names are keys and filenames are values.
"""
function getlayers(::Type{T}, dir::String; layers=bandnames(T)) where {T <: AbstractSatellite}
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
    return OrderedDict([layer => all_layers[layer] for layer in layers])
end

retrieve_layer(raster, layer::Symbol) = raster[layer]

retrieve_layer(raster, layer::Integer) = raster[:,:,layer]

blue(::Type{T}, raster) where {T <: AbstractSatellite} = retrieve_layer(raster, blue_band(T))

green(::Type{T}, raster) where {T <: AbstractSatellite} =retrieve_layer(raster, green_band(T))

red(::Type{T}, raster) where {T <: AbstractSatellite} = retrieve_layer(raster, red_band(T))

nir(::Type{T}, raster) where {T <: AbstractSatellite} = retrieve_layer(raster, nir_band(T))

swir1(::Type{T}, raster) where {T <: AbstractSatellite} = retrieve_layer(raster, swir1_band(T))

swir2(::Type{T}, raster) where {T <: AbstractSatellite} = retrieve_layer(raster, swir2_band(T))