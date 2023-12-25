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

function File(band::Symbol)
    regex = "_" * exactly(1, string(band)) * "." * ["TIF", "tif", "tiff", "TIFF", "JP2", "jp2"] * END
    return File(regex)
end

Base.match(x::File, str) = !isnothing(Base.match(x.regex, str))

"""
A layer corresponding to a particular bit in a single-band file.  

Landsat uses this format to encode segmentation masks within the QA file.
"""
struct BitField <: AbstractLayerSource
    regex::RegexString
    bit::Int
end

Base.match(x::BitField, str) = !isnothing(Base.match(x.regex, str))

"""
A layer corresponding to a specific value in a single-band file.  

Sentinel 2 uses this format to encode segmentation masks in the SCL file.
"""
struct MaskValue{T} <: AbstractLayerSource
    regex::RegexString
    value::T
end

Base.match(x::MaskValue, str) = !isnothing(Base.match(x.regex, str))

"""
A layer corresponding to a particular band in a multi-band file.  

Commonly used for sensors which store their bands in a single multi-band raster.
"""
struct Band <: AbstractLayerSource
    regex::RegexString
    band::Int
end

Base.match(x::Band, str) = !isnothing(Base.match(x.regex, str))

"""
A layer composed of the union of two other layers.  

An example is a cloud mask expressed as the union of a cloud-over-water mask and a cloud-over-land mask.
"""
struct UnionLayer{A,B} <: AbstractLayerSource
    a::A
    b::B
end

Base.match(x::UnionLayer, str) = !isnothing(Base.match(x.a, str)) || !isnothing(Base.match(x.b, str))

"""
    parse_file(x::AbstractLayerSource, files::Vector{String})

Returns the first file that matches the provided `AbstractLayerSource` from a list of files.

Returns `nothing`if no matching file can be found.
"""
function parse_file(x::AbstractLayerSource, files::Vector{String})
    for file in files
        if Base.match(x, file)
            return file
        end
    end
    return nothing
end

function parse_file(x::UnionLayer, files::Vector{String})
    matched = (a=parse_file(x.a, files), b=parse_file(x.b, files))
    return (isnothing(matched.a) || isnothing(matched.b)) ? nothing : matched
end