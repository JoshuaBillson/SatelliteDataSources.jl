# SatelliteDataSources

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JoshuaBillson.github.io/SatelliteDataSources.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://JoshuaBillson.github.io/SatelliteDataSources.jl/dev/)
[![Build Status](https://github.com/JoshuaBillson/SatelliteDataSources.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/JoshuaBillson/SatelliteDataSources.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/JoshuaBillson/SatelliteDataSources.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/JoshuaBillson/SatelliteDataSources.jl)

[SatelliteDataSources](https://github.com/JoshuaBillson/SatelliteDataSources.jl) is a pure Julia package built on top of [Rasters.jl](https://github.com/rafaqz/Rasters.jl) for reading and manipulating satellite imagery. Each 
`AbstractSatellite` provides a set of layers that can be conveniently read into either a `Raster` or `RasterStack`.
Additionally, all `AbstractSatellite` types define a collection of sensor-specific information, such digital number
encoding, band wavelength, and band color. For details on supported satellites, please refer to the [Docs](https://JoshuaBillson.github.io/SatelliteDataSources.jl/stable/).

# Example

```julia
using Rasters, SatelliteDataSources

# Path to Satellite Product
src = "data/LC08_L2SP_043024_20200802_20200914_02_T1"

# Load the Blue, Green, Red, and NIR Bands
stack = RasterStack(Landsat8, src, [:blue, :green, :red, :nir], lazy=true)

# Mask Clouds
cloud_mask = Raster(Landsat8, src, :clouds) 
shadow_mask = Raster(Landsat8, src, :cloud_shadow) 
raster_mask = .!(boolmask(cloud_mask) .|| boolmask(shadow_mask))
masked_stack = mask(stack, with=raster_mask)

# Save Processed Data as a Multiband Raster
masked_raster = Raster(masked_stack)
write("data/masked_bands.tif", masked_raster)

```