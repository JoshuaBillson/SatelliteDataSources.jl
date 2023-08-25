module SatelliteTypes

using ReadableRegex
using Pipe: @pipe

include("interface.jl")
include("utils.jl")
include("landsat7.jl")
include("landsat8.jl")
include("sentinel2.jl")
include("extensions.jl")

blue(::Type{T}, raster) where {T <: AbstractBandset} = getlayer(raster, blue_band(T))

green(::Type{T}, raster) where {T <: AbstractBandset} = getlayer(raster, green_band(T))

red(::Type{T}, raster) where {T <: AbstractBandset} = getlayer(raster, red_band(T))

nir(::Type{T}, raster) where {T <: AbstractBandset} = getlayer(raster, nir_band(T))

swir1(::Type{T}, raster) where {T <: AbstractBandset} = getlayer(raster, swir1_band(T))

swir2(::Type{T}, raster) where {T <: AbstractBandset} = getlayer(raster, swir2_band(T))

export AbstractBandset, Landsat7, Landsat8, Sentinel2
export bandnames, layernames, wavelength, wavelengths, blue_band, green_band, red_band, nir_band, swir1_band, swir2_band, parse_layers, getlayers
export blue, green, red, nir, swir1, swir2

end