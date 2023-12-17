```@meta
CurrentModule = SatelliteDataSources
```

# SatelliteDataSources

[SatelliteDataSources](https://github.com/JoshuaBillson/SatelliteDataSources.jl) is a pure Julia package built on top of [Rasters.jl](https://github.com/rafaqz/Rasters.jl) for reading and manipulating satellite imagery. Each 
`AbstractSatellite` provides a set of layers that can be conveniently read into either a `Raster` or `RasterStack`.
Additionally, all `AbstractSatellite` types define a collection of sensor-specific information, such digital number
encoding, band wavelength, and band color.

# Supported Sensors

Several popular satellites are already supported, and we provide a simple interface for adding more down the line.

```@docs
AbstractSatellite
Landsat7
Landsat8
Landsat9
Sentinel2
```

# User Interface

```@docs
bands
layers
wavelengths
wavelength
blue_band
green_band
red_band
nir_band
swir1_band
swir2_band
decode
encode
```

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

# Index

Documentation for [SatelliteDataSources](https://github.com/JoshuaBillson/SatelliteDataSources.jl).

```@index
```