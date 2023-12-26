"""
Implements the `AbstractSatellite` interface for DESIS.

**Supported Bands:** `:Bands`, `:Band_30`, `:Band_65`, `:Band_100`, `:Band_175`

**Supported Colors:** `:blue`, `:green`, `:red`, `:nir`

**Supported Masks:** `:clouds`, `:shadow`, `:haze`, `:snow`, `:land`, `:water`
"""
struct DESIS <: AbstractSatellite 
    src::String
end

files(x::DESIS) = _get_files(x.src)

@generated function bands(::Type{DESIS})
    bandnames = Symbol.(["Band_$i" for i in 1:235])
    return :($bandnames)
end

layers(::Type{DESIS}) = [:Bands, :Band_30, :Band_65, :Band_100, :Band_175, :blue, :green, :red, :nir, :clouds, :shadow, :haze, :snow, :land, :water]

@generated function wavelengths(::Type{DESIS})
    wl = collect(LinRange(401.25, 998.75, 235))
    return :($wl)
end

blue_band(::Type{DESIS}) = :Band_30

green_band(::Type{DESIS}) = :Band_65

red_band(::Type{DESIS}) = :Band_100

nir_band(::Type{DESIS}) = :Band_175

function dn_scale(::Type{DESIS}, layer::Symbol)
    if (layer == :Bands) || (layer in bands(DESIS))
        return 0.0001f0
    end
    return 1.0f0
end

function dn_offset(::Type{DESIS}, layer::Symbol)
    return 0.0f0
end

function layer_source(::Type{DESIS}, layer::Symbol)
    bands_regex = "SPECTRAL_IMAGE." * either("TIF", "tif", "jp2") * END
    qa_regex = "QL_QUALITY-2." * either("TIF", "tif", "jp2") * END

layers(::Type{DESIS}) = [:clouds, :shadow, :haze, :snow, :land, :water]
    @match layer begin
        :Bands => File(bands_regex)
        :Band_30 => Band(bands_regex, 30)
        :Band_65 => Band(bands_regex, 65)
        :Band_100 => Band(bands_regex, 100)
        :Band_175 => Band(bands_regex, 175)
        :shadow => Band(qa_regex, 1)
        :snow => Band(qa_regex, 3)
        :land => Band(qa_regex, 2)
        :water => Band(qa_regex, 8)
        :haze => UnionLayer(Band(qa_regex, 4), Band(qa_regex, 5))
        :clouds => UnionLayer(Band(qa_regex, 6), Band(qa_regex, 7))
        _ => error("DESIS does not support layer :$(layer)!")
    end
end

function metadata(x::DESIS)
    # Build Regex
    level_pattern = capture(rs"L" * ("1B", "1C", "2A"), as="level")
    acquisition_date_pattern = capture(exactly(8, DIGIT) * "T" * exactly(6, DIGIT), as="acquired")
    processing_version_pattern = capture(rs"V\d{4}", as="processor_version")
    regex = rs"DESIS-HSI-" * level_pattern * rs"-DT\d{10}_\d{3}-" * acquisition_date_pattern * rs"-" * processing_version_pattern

    # Parse Data From File
    m = match(regex, x.src)

    # Return Metadata
    if !isnothing(m)
        return OrderedDict( 
            "level" => m["level"], 
            "acquired" => DateTime(m["acquired"], "yyyymmddTHHMMSS"), 
            "processor version" => m["processor_version"] )
    end
    return OrderedDict{String, Any}()
end