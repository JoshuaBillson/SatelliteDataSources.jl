"""
Super type of all layer sources.
"""
abstract type AbstractLayerSource end

"""
A layer corresponding to a file.  

Commonly used for sensors which store their bands as individual rasters.
"""
struct File <: AbstractLayerSource
    regex::RegexString
end

"""
A layer corresponding to a particular bit in a single-band file.  

Landsat uses this format to encode segmentation masks within the QA file.
"""
struct BitField <: AbstractLayerSource
    regex::RegexString
    bit::Int
end

"""
A layer corresponding to a specific value in a single-band file.  

Sentinel 2 uses this format to encode segmentation masks in the SCL file.
"""
struct MaskValue{T} <: AbstractLayerSource
    regex::RegexString
    value::T
end

"""
A layer corresponding to a particular band in a multi-band file.  

Commonly used for sensors which store their bands in a single multi-band raster.
"""
struct Band <: AbstractLayerSource
    regex::RegexString
    band::Int
end

# Default File Constructor
function File(band::Symbol)
    regex = "_" * exactly(1, string(band)) * "." * ["TIF", "tif", "tiff", "TIFF", "JP2", "jp2"] * END
    return File(regex)
end