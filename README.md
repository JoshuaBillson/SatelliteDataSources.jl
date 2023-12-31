# SatelliteDataSources

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JoshuaBillson.github.io/SatelliteDataSources.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://JoshuaBillson.github.io/SatelliteDataSources.jl/dev/)
[![Build Status](https://github.com/JoshuaBillson/SatelliteDataSources.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/JoshuaBillson/SatelliteDataSources.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/JoshuaBillson/SatelliteDataSources.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/JoshuaBillson/SatelliteDataSources.jl)

[SatelliteDataSources](https://github.com/JoshuaBillson/SatelliteDataSources.jl) is a pure Julia package built on top of [Rasters.jl](https://github.com/rafaqz/Rasters.jl) for reading satellite imagery. Most functionality is built around the `AbstractSatellite` type, which is used to encode sensor-specific information by exploiting Julia's multiple dispatch mechanism. For example, methods specialized on the `Landsat8` struct knows which bands correspond to colors like `:red` or `:green`, how to convert digital numbers to reflectance or kelvin, and how to read the `:clouds` mask from the included QA file. In particular, this package aims to abstract the details of retrieving a specific layer of a remote sensing product, such that the user can simply request whatever layers they want and trust that the details will be automatically inferred from the sensor type. For a complete list of supported satellites, please refer to the [Docs](https://JoshuaBillson.github.io/SatelliteDataSources.jl/stable/).

# Example

```julia
using ArchGDAL, Rasters, SatelliteDataSources, DataDeps, Fetch

# Download Landsat 8 Scene From Google Drive
landsat_link = "https://drive.google.com/file/d/1S5H_oyWZZInOzJK4glBCr6LgXSADzhOV/view?usp=sharing"
landsat_hash = "2ce24abc359d30320213237d78101d193cdb8433ce21d1f7e9f08ca140cf5785"
register(
    DataDep(
        "LC08_L2SP_043024_20200802_20200914_02_T1", 
        "Landsat 8 Test Data", 
        landsat_link, 
        landsat_hash, 
        fetch_method=gdownload, 
        post_fetch_method=unpack
    )
)

# Place Scene in a Landsat8 Context
src = Landsat8(datadep"LC08_L2SP_043024_20200802_20200914_02_T1")

# Load the Blue, Green, Red, and NIR Bands
stack = RasterStack(src, [:blue, :green, :red, :nir], lazy=true)

# Mask Clouds and Cloud Shadow
cloud_mask = Raster(src, :clouds) 
shadow_mask = Raster(src, :cloud_shadow) 
raster_mask = .!(boolmask(cloud_mask) .|| boolmask(shadow_mask))
masked_stack = mask(stack, with=raster_mask)

# Save Processed Data as a Multiband Raster
masked_raster = Raster(masked_stack)
write("masked_bands.tif", masked_raster)
```
