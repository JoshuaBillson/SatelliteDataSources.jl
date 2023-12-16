"""
Super type of all concrete layer sources.
"""
abstract type AbstractLayerSource end

"""
Represents a layer corresponding to a file. 
Commonly used for sensors which store their bands in individual files.
"""
struct File <: AbstractLayerSource
    regex::RegexString
end

"""
Represents a layer corresponding to a particular bit in a single-band file. 
Commonly used for QA and scene classification masks.
"""
struct BitField <: AbstractLayerSource
    regex::RegexString
    bit::Int
end

"""
Represents a layer corresponding to a particular bit in a single-band file. 
Commonly used for QA and scene classification masks.
"""
struct MaskValue{T} <: AbstractLayerSource
    regex::RegexString
    value::T
end

"""
Represents a layer corresponding to a particular band in a multi-band file. 
Commonly used for sensors which store their bands as a single multi-band file.
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