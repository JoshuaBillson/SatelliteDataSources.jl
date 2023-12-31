module SatelliteDataSources

using ReadableRegex, OrderedCollections, Dates
import Rasters
import Base: match
using Pipe: @pipe
using Match: @match

include("utils.jl")
include("sources.jl")
include("interface.jl")
include("landsat7.jl")
include("landsat8.jl")
include("landsat9.jl")
include("sentinel2.jl")
include("desis.jl")
include("rasters.jl")

export AbstractLayerSource, File, BitField, Band, parse_file
export AbstractSatellite, Landsat7, Landsat8, Landsat9, Sentinel2, DESIS
export files, bands, layers, wavelength, wavelengths, blue_band, green_band, red_band, nir_band, swir1_band, swir2_band, dn_scale, dn_offset, layer_source, translate_color
export decode, encode, metadata
export Raster, RasterStack

end