module SatelliteTypes

using ReadableRegex
using Pipe: @pipe

include("interface.jl")
include("utils.jl")
include("landsat7.jl")
include("landsat8.jl")
include("sentinel2.jl")
include("extensions.jl")

export AbstractBandset, Landsat7, Landsat8, Sentinel2
export bandnames, layernames, wavelength, wavelengths, blue_band, green_band, red_band, nir_band, swir1_band, swir2_band, parse_layers, getlayers
export blue, green, red, nir, swir1, swir2

end