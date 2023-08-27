module SatelliteDataSources

using ReadableRegex, OrderedCollections
using Pipe: @pipe

include("interface.jl")
include("utils.jl")
include("landsat7.jl")
include("landsat8.jl")
include("sentinel2.jl")
include("desis.jl")

export AbstractSatellite, Landsat7, Landsat8, Sentinel2, DESIS
export bandnames, layernames, wavelength, wavelengths, blue_band, green_band, red_band, nir_band, swir1_band, swir2_band, parse_layers, dn_offset, dn_scale, getlayers
export blue, green, red, nir, swir1, swir2

end