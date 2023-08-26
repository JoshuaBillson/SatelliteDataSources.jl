module SatelliteTypesRastersExt

using SatelliteTypes, Rasters

Rasters.Raster(::Type{AbstractSatellite}, dir::String; kwargs...) = throw(ArgumentError("Must specify a layer!"))

function Rasters.Raster(::Type{T}, dir::String, layer::Symbol; kwargs...) where {T <: SatelliteTypes.AbstractSatellite}
    parsed_layer = getlayers(T, dir, layers=layer) |> first
    return Rasters.Raster(parsed_layer[2], name=parsed_layer[1]; kwargs...)
end

function Rasters.RasterStack(::Type{T}, dir::String, layers=bandnames(T); kwargs...) where {T <: SatelliteTypes.AbstractSatellite}
    layers isa Vector{Symbol} || throw(ArgumentError("`layers` must be a `Vector{Symbol}`!"))
    parsed_layers = getlayers(T, dir, layers=layers) |> NamedTuple
    return Rasters.RasterStack(parsed_layers; kwargs...)
end

end