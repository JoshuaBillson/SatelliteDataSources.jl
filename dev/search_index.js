var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = SatelliteDataSources","category":"page"},{"location":"#SatelliteDataSources","page":"Home","title":"SatelliteDataSources","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for SatelliteDataSources.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [SatelliteDataSources]","category":"page"},{"location":"#SatelliteDataSources.AbstractSatellite","page":"Home","title":"SatelliteDataSources.AbstractSatellite","text":"The supertype of all sensor types. Provides sensor-specific information to many RemoteSensingToolbox methods.\n\n\n\n\n\n","category":"type"},{"location":"#SatelliteDataSources.Landsat8","page":"Home","title":"SatelliteDataSources.Landsat8","text":"Implements the AbstractSatellite interface for Landsat 8.\n\nSupported layers are: (:B1, :B2, :B3, :B4, :B5, :B6, :B7, :blue, :green, :red, :nir, :swir1, :swir2, :QA, :bands).\n\n\n\n\n\n","category":"type"},{"location":"#SatelliteDataSources.Landsat9","page":"Home","title":"SatelliteDataSources.Landsat9","text":"Implements the AbstractSatellite interface for Landsat 9.\n\nSupported layers are: (:B1, :B2, :B3, :B4, :B5, :B6, :B7, :blue, :green, :red, :nir, :swir1, :swir2, :QA).\n\n\n\n\n\n","category":"type"},{"location":"#SatelliteDataSources.Sentinel2","page":"Home","title":"SatelliteDataSources.Sentinel2","text":"Implements the AbstractSatellite interface for Sentinel 2.\n\n\n\n\n\n","category":"type"},{"location":"#SatelliteDataSources.bandnames","page":"Home","title":"SatelliteDataSources.bandnames","text":"bandnames(::Type{AbstractSatellite})\n\nReturn the band names in order from shortest to longest wavelength.\n\n\n\n\n\n","category":"function"},{"location":"#SatelliteDataSources.blue_band-Union{Tuple{Type{T}}, Tuple{T}} where T<:AbstractSatellite","page":"Home","title":"SatelliteDataSources.blue_band","text":"blue_band(::Type{AbstractSatellite})\n\nReturn the blue band for the given sensor.\n\n\n\n\n\n","category":"method"},{"location":"#SatelliteDataSources.dn_offset-Union{Tuple{Type{T}}, Tuple{T}} where T<:AbstractSatellite","page":"Home","title":"SatelliteDataSources.dn_offset","text":"dn_offset(::Type{AbstractSatellite})\n\nReturn the offset applied to digital numbers.\n\n\n\n\n\n","category":"method"},{"location":"#SatelliteDataSources.dn_scale-Union{Tuple{Type{T}}, Tuple{T}} where T<:AbstractSatellite","page":"Home","title":"SatelliteDataSources.dn_scale","text":"dn_scale(::Type{AbstractSatellite})\n\nReturn the scaling factor applied to digital numbers.\n\n\n\n\n\n","category":"method"},{"location":"#SatelliteDataSources.getlayers-Union{Tuple{T}, Tuple{Type{T}, String}} where T<:AbstractSatellite","page":"Home","title":"SatelliteDataSources.getlayers","text":"getlayers(::Type{T}, dir::String; layers=bandnames(T)) where {T <: AbstractSatellite}\n\nRetrieve the requested layers in the provided directory. Returns a dictionary where layer names are keys and filenames are values.\n\n\n\n\n\n","category":"method"},{"location":"#SatelliteDataSources.green_band-Union{Tuple{Type{T}}, Tuple{T}} where T<:AbstractSatellite","page":"Home","title":"SatelliteDataSources.green_band","text":"green_band(::Type{AbstractSatellite})\n\nReturn the green band for the given sensor.\n\n\n\n\n\n","category":"method"},{"location":"#SatelliteDataSources.layernames","page":"Home","title":"SatelliteDataSources.layernames","text":"layernames(::Type{AbstractSatellite})\n\nReturn the names of all layers available for the given sensor.\n\n\n\n\n\n","category":"function"},{"location":"#SatelliteDataSources.nir_band-Union{Tuple{Type{T}}, Tuple{T}} where T<:AbstractSatellite","page":"Home","title":"SatelliteDataSources.nir_band","text":"nir_band(::Type{AbstractSatellite})\n\nReturn the nir band for the given sensor.\n\n\n\n\n\n","category":"method"},{"location":"#SatelliteDataSources.parse_layers","page":"Home","title":"SatelliteDataSources.parse_layers","text":"parse_layers(::Type{AbstractSatellite}, dir::String)\n\nRetrieve all layers in the provided directory. Returns a dictionary where layer names are keys and filenames are values.\n\n\n\n\n\n","category":"function"},{"location":"#SatelliteDataSources.red_band-Union{Tuple{Type{T}}, Tuple{T}} where T<:AbstractSatellite","page":"Home","title":"SatelliteDataSources.red_band","text":"red_band(::Type{AbstractSatellite})\n\nReturn the red band for the given sensor.\n\n\n\n\n\n","category":"method"},{"location":"#SatelliteDataSources.swir1_band-Union{Tuple{Type{T}}, Tuple{T}} where T<:AbstractSatellite","page":"Home","title":"SatelliteDataSources.swir1_band","text":"swir1_band(::Type{AbstractSatellite})\n\nReturn the swir1 band for the given sensor.\n\n\n\n\n\n","category":"method"},{"location":"#SatelliteDataSources.swir2_band-Union{Tuple{Type{T}}, Tuple{T}} where T<:AbstractSatellite","page":"Home","title":"SatelliteDataSources.swir2_band","text":"swir2_band(::Type{AbstractSatellite})\n\nReturn the swir2 band for the given sensor.\n\n\n\n\n\n","category":"method"},{"location":"#SatelliteDataSources.wavelength-Union{Tuple{T}, Tuple{Type{T}, Symbol}} where T<:AbstractSatellite","page":"Home","title":"SatelliteDataSources.wavelength","text":"wavelength(::Type{AbstractSatellite}, band::Symbol)\n\nReturn the central wavelength for the corresponding band.\n\n\n\n\n\n","category":"method"},{"location":"#SatelliteDataSources.wavelengths","page":"Home","title":"SatelliteDataSources.wavelengths","text":"wavelengths(::Type{AbstractSatellite})\n\nReturn the central wavelengths for all bands in order from shortest to longest.\n\n\n\n\n\n","category":"function"}]
}
