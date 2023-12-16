module SatelliteDataSources

using ReadableRegex, OrderedCollections
import Rasters, ArchGDAL
using Pipe: @pipe
using Match: @match

include("interface.jl")
include("utils.jl")
include("sources.jl")
include("landsat7.jl")
include("landsat8.jl")
include("landsat9.jl")
include("sentinel2.jl")
include("desis.jl")
include("rasters.jl")

export AbstractLayerSource, File, BitField, Band
export AbstractSatellite, Landsat7, Landsat8, Landsat9, Sentinel2, DESIS
export bands, layers, wavelength, wavelengths, blue_band, green_band, red_band, nir_band, swir1_band, swir2_band, dn_scale, dn_offset, layer_source
export decode, encode

end