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
translate_color
Rasters.Raster
Rasters.RasterStack
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
parse_file
```

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

# Index

```@index
```