# SatelliteDataSources

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JoshuaBillson.github.io/SatelliteDataSources.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://JoshuaBillson.github.io/SatelliteDataSources.jl/dev/)
[![Build Status](https://github.com/JoshuaBillson/SatelliteDataSources.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/JoshuaBillson/SatelliteDataSources.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/JoshuaBillson/SatelliteDataSources.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/JoshuaBillson/SatelliteDataSources.jl)

SatelliteDataSources is a package for automating the retrieval of bands/layers from common remote sensing products. At present, data sources must be saved locally. Support is provided for [Rasters.jl](https://github.com/rafaqz/Rasters.jl), which enables the following syntax for loading remote sensing products:

```julia
# Load All Sentinel 2 Bands With 10m Resolution
RasterStack(Sentinel2{10}, "data/L2A_T11UPT_A017828_20200804T184659/")

# Load The Red, Green, and Blue Sentinel 2 Bands At 10m Resolution
RasterStack(Sentinel2{10}, "data/L2A_T11UPT_A017828_20200804T184659/", [:red, :green, :blue])

# Load The SCL Layer At 60m Resolution
Raster(Sentinel2{60}, "data/L2A_T11UPT_A017828_20200804T184659/", :SCL)
```

# Supported Sensors

| Satellites           | Supported Layers                                                                                                                                      |
| -------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------- |
| Landsat 7            | `:B1`, `:B2`, `:B3`, `:B4`, `:B5`, `:B7`, `:blue`, `:green`, `:red`, `:nir`, `:swir1`, `:swir2`, `:QA`                                                |
| Landsat 8            | `:B1`, `:B2`, `:B3`, `:B4`, `:B5`, `:B6`, `:B7`, `:blue`, `:green`, `:red`, `:nir`, `:swir1`, `:swir2`, `:QA`                                         |
| Landsat 9            | `:B1`, `:B2`, `:B3`, `:B4`, `:B5`, `:B6`, `:B7`, `:blue`, `:green`, `:red`, `:nir`, `:swir1`, `:swir2`, `:QA`                                         |
| Sentinel 2   &nbsp;  | `:B01`, `:B02`, `:B03`, `:B04`, `:B05`, `:B06`, `:B07`, `:B8A`, `:B09`, `:B11`, `:B12`, `:blue`, `:green`, `:red`, `:nir`, `:swir1`, `:swir2`, `:SCL` |
| DESIS                | `:bands`, `:QA`                                                                                                                                       |
