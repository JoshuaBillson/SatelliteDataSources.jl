```@meta
CurrentModule = SatelliteDataSources
```

# SatelliteDataSources

[SatelliteDataSources](https://github.com/JoshuaBillson/SatelliteDataSources.jl) is a pure Julia package built on top of [Rasters.jl](https://github.com/rafaqz/Rasters.jl) for reading and manipulating satellite imagery. Each 
`AbstractSatellite` provides a set of layers that can be conveniently read into either a `Raster` or `RasterStack`.
Additionally, all `AbstractSatellite` types define a collection of sensor-specific information, such as digital number
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
files
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
dn_scale
dn_offset
decode
encode
metadata
Rasters.Raster
```

# Layer Sources

A sensor's layers can come form a variety of sources, including single-band rasters, multiband rasters, and bit-fields. However, we do not want to expose these particulars to the end user. Thus, we rely on several Julia types to represent this abstraction. Each of these types are sub-types of `AbstractLayerSource` and store the necessary information to retrieve the corresponding layer.

```@docs
AbstractLayerSource
File
Band
MaskValue
BitField
layer_source
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