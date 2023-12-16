"""
Implements the `AbstractSatellite` interface for Sentinel 2.
The user must specify a resolution of eith 10, 20, or 60 meters.

Sentinel2{10} Layers: :B02, :B03, :B04, :B08, :blue, :green, :red, :nir  

Sentinel2{20} Layers: :B02, :B03, :B04, :B05, :B06, :B07, :B8A, :B11, :B12, :blue, :green, :red, :nir, :swir1, :swir2, :cloud_shadow, :clouds_med, :clouds_high, :cirrus, :vegetation, :soil, :water, :snow  

Sentinel2{60} Layers: :B01, :B02, :B03, :B04, :B05, :B06, :B07, :B8A, :B09, :B11, :B12, :blue, :green, :red, :nir, :swir1, :swir2, :cloud_shadow, :clouds_med, :clouds_high, :cirrus, :vegetation, :soil, :water, :snow  
"""
struct Sentinel2{R} <: AbstractSatellite end

bands(::Type{<:Sentinel2}) = error("Error: Must specify spatial resolution for Sentinel 2!")

bands(::Type{Sentinel2{60}}) = [:B01, :B02, :B03, :B04, :B05, :B06, :B07, :B8A, :B09, :B11, :B12]

bands(::Type{Sentinel2{20}}) = [:B02, :B03, :B04, :B05, :B06, :B07, :B8A, :B11, :B12]

bands(::Type{Sentinel2{10}}) = [:B02, :B03, :B04, :B08]

wavelengths(::Type{<:Sentinel2}) = error("Error: Must specify spatial resolution for Sentinel 2!")

wavelengths(::Type{Sentinel2{60}}) = [443, 490, 560, 665, 705, 740, 783, 865, 945, 1610, 2190]

wavelengths(::Type{Sentinel2{20}}) = [490, 560, 665, 705, 740, 783, 865, 1610, 2190]

wavelengths(::Type{Sentinel2{10}}) = [490, 560, 665, 842]

layers(::Type{<:Sentinel2}) = error("Error: Must specify spatial resolution for Sentinel 2!")

layers(::Type{Sentinel2{60}}) = [:B01, :B02, :B03, :B04, :B05, :B06, :B07, :B8A, :B09, :B11, :B12, :blue, :green, :red, :nir, :swir1, :swir2, :cloud_shadow, :clouds_med, :clouds_high, :cirrus, :vegetation, :soil, :water, :snow]

layers(::Type{Sentinel2{20}}) = [:B02, :B03, :B04, :B05, :B06, :B07, :B8A, :B11, :B12, :blue, :green, :red, :nir, :swir1, :swir2, :cloud_shadow, :clouds_med, :clouds_high, :cirrus, :vegetation, :soil, :water, :snow]

layers(::Type{Sentinel2{10}}) = [:B02, :B03, :B04, :B08, :blue, :green, :red, :nir]

blue_band(::Type{<:Sentinel2}) = :B02

green_band(::Type{<:Sentinel2}) = :B03

red_band(::Type{<:Sentinel2}) = :B04

nir_band(::Type{Sentinel2{10}}) = :B08

nir_band(::Type{<:Sentinel2}) = :B8A

swir1_band(::Type{Sentinel2{20}}) = :B11

swir1_band(::Type{Sentinel2{60}}) = :B11

swir2_band(::Type{Sentinel2{20}}) = :B12

swir2_band(::Type{Sentinel2{60}}) = :B12

function dn_scale(::Type{<:Sentinel2}, layer::Symbol)
    @match layer begin
        :B01 || :B02 || :B03 || :B04 || :B05 || :B06 || :B07 || :B08 || :B8A || :B09 || :B11 || :B12 => 0.0001f0
        _ => 1.0f0
    end
end

function dn_offset(::Type{<:Sentinel2}, layer::Symbol)
    return 0.0f0
end

function layer_source(::Type{Sentinel2{60}}, layer::Symbol)
    band_regex(band) = "_" * exactly(1, string(band)) * "_60m." * either("TIF", "tif", "jp2") * END
    scl_regex = "SCL_60m." * either("TIF", "tif", "jp2") * END

    @match layer begin
        :B01 => File(band_regex(:B01))
        :B02 => File(band_regex(:B02))
        :B03 => File(band_regex(:B03))
        :B04 => File(band_regex(:B04))
        :B05 => File(band_regex(:B05))
        :B06 => File(band_regex(:B06))
        :B07 => File(band_regex(:B07))
        :B8A => File(band_regex(:B8A))
        :B09 => File(band_regex(:B09))
        :B11 => File(band_regex(:B11))
        :B12 => File(band_regex(:B12))
        :cloud_shadow => MaskValue(scl_regex, 0x03)
        :clouds_med => MaskValue(scl_regex, 0x08)
        :clouds_high => MaskValue(scl_regex, 0x09)
        :cirrus => MaskValue(scl_regex, 0x0a)
        :vegetation => MaskValue(scl_regex, 0x04)
        :non_vegetated => MaskValue(scl_regex, 0x05)
        :water => MaskValue(scl_regex, 0x06)
        :snow => MaskValue(scl_regex, 0x0b)
        :SCL => File(scl_regex)
        _ => error("Sentinel2{60} does not support layer :$(layer)!")
    end
end

function layer_source(::Type{Sentinel2{20}}, layer::Symbol)
    band_regex(band) = "_" * exactly(1, string(band)) * "_20m." * either("TIF", "tif", "jp2") * END
    scl_regex = "SCL_20m." * either("TIF", "tif", "jp2") * END

    @match layer begin
        :B02 => File(band_regex(:B02))
        :B03 => File(band_regex(:B03))
        :B04 => File(band_regex(:B04))
        :B05 => File(band_regex(:B05))
        :B06 => File(band_regex(:B06))
        :B07 => File(band_regex(:B07))
        :B8A => File(band_regex(:B8A))
        :B11 => File(band_regex(:B11))
        :B12 => File(band_regex(:B12))
        :cloud_shadow => MaskValue(scl_regex, 0x03)
        :clouds_med => MaskValue(scl_regex, 0x08)
        :clouds_high => MaskValue(scl_regex, 0x09)
        :cirrus => MaskValue(scl_regex, 0x0a)
        :vegetation => MaskValue(scl_regex, 0x04)
        :non_vegetated => MaskValue(scl_regex, 0x05)
        :water => MaskValue(scl_regex, 0x06)
        :snow => MaskValue(scl_regex, 0x0b)
        :SCL => File(scl_regex)
        _ => error("Sentinel2{20} does not support layer :$(layer)!")
    end
end

function layer_source(::Type{Sentinel2{10}}, layer::Symbol)
    band_regex(band) = "_" * exactly(1, string(band)) * "_20m." * either("TIF", "tif", "jp2") * END

    @match layer begin
        :B02 => File(band_regex(:B02))
        :B03 => File(band_regex(:B03))
        :B04 => File(band_regex(:B04))
        :B08 => File(band_regex(:B08))
        _ => error("Sentinel2{10} does not support layer :$(layer)!")
    end
end