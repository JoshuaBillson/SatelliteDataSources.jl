function Rasters.Raster(::Type{T}, dir::String, layer::Symbol; kwargs...) where {T <: AbstractSatellite}
    layer = _translate_color(T, layer)
    source = layer_source(T, layer)
    return _read_layer(source, dir, layer; kwargs...)
end

function Rasters.RasterStack(::Type{T}, dir::String, layers=bandnames(T); kwargs...) where {T <: AbstractSatellite}
    layers isa Vector{Symbol} || throw(ArgumentError("`layers` must be a `Vector{Symbol}`!"))
    rasters = [Rasters.Raster(T, dir, layer; kwargs...) for layer in layers]
    return Rasters.RasterStack(NamedTuple{Tuple(layers)}(rasters); kwargs...)
end

function decode(::Type{T}, raster::Rasters.AbstractRaster) where {T <: AbstractSatellite} 
    scale = dn_scale(T, raster.name)
    offset = dn_offset(T, raster.name)
    decoded_raster = Rasters.rebuild((raster .* scale) .+ offset, name=raster.name)
    return Rasters.mask!(decoded_raster, with=raster, missingval=Inf32)
end

function decode(::Type{T}, raster::Rasters.AbstractRasterStack) where {T <: AbstractSatellite} 
    map(x -> decode(T, x), raster)
end

function encode(::Type{T}, raster::Rasters.AbstractRaster; encoding_type=UInt16, missingval=0x0000) where {T <: AbstractSatellite} 
    scale = dn_scale(T, raster.name)
    offset = dn_offset(T, raster.name)
    @pipe ((raster .- offset) ./ scale) |>
    Rasters.mask!(_, with=raster, missingval=missingval) |>
    round.(encoding_type, _) |>
    Rasters.rebuild(_, name=raster.name, missingval=encoding_type(missingval))
end

function encode(::Type{T}, raster::Rasters.AbstractRasterStack; kwargs...) where {T <: AbstractSatellite} 
    map(x -> encode(T, x; kwargs...), raster)
end

function _read_source(src::File, file::String, layer::Symbol; kwargs...)
    return Rasters.Raster(file; name=layer, kwargs...)
end

function _read_source(src::Band, file::String, layer::Symbol; kwargs...)
    return @view Rasters.Raster(file; kwargs...)[Rasters.Band(src.band)]
end

function _read_source(src::MaskValue, file::String, layer::Symbol; kwargs...)
    raster = Rasters.Raster(file; kwargs...)
    new_raster = UInt8.(raster .== src.value)
    return Rasters.rebuild(new_raster, missingval=0x00, name=layer)
end

function _read_source(src::BitField, file::String, layer::Symbol; kwargs...)
    raster = Rasters.Raster(file; kwargs...)
    n = sizeof(eltype(raster)) * 8  # Number of bits
    new_raster = _read_bit(raster, src.bit, bits=n)
    return Rasters.rebuild(new_raster, missingval=0x00, name=layer)
end

function _read_layer(src, dir::String, layer::Symbol; kwargs...)
    for file in _get_files(dir)
        if !isnothing(match(src.regex, file))
            return _read_source(src, file, layer; kwargs...)
        end
    end
    error("Could not find layer :$(layer) in the directory \"$(dir)\"")
end

function _translate_color(::Type{T}, layer::Symbol) where {T <: AbstractSatellite}
    @match layer begin
        :blue => blue_band(T)
        :green => green_band(T)
        :red => red_band(T)
        :nir => nir_band(T)
        :swir1 => swir1_band(T)
        :swir2 => swir2_band(T)
        _ => layer
    end
end