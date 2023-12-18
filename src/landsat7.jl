"""
Implements the `AbstractSatellite` interface for Landsat 7.

**Supported Bands:** `:B1`, `:B2`, `:B3`, `:B4`, `:B5`, `:B7`, `:thermal`, `:panchromatic`

**Supported Colors:** `:blue`, `:green`, `:red`, `:nir`, `:swir1`, `:swir2`

**Supported Masks:** `:dilated_clouds`, `:clouds`, `:cloud_shadow`, `:snow`, `:water`
"""
struct Landsat7 <: AbstractSatellite 
    src::String
end

files(x::Landsat7) = _get_files(x.src)

bands(::Type{Landsat7}) = [:B1, :B2, :B3, :B4, :B5, :B7]

layers(::Type{Landsat7}) = [:B1, :B2, :B3, :B4, :B5, :B7, :blue, :green, :red, :nir, :swir1, :swir2, :panchromatic, :thermal, :dilated_clouds, :clouds, :cloud_shadow, :snow, :water]

wavelengths(::Type{Landsat7}) = [483, 560, 660, 835, 1650, 2220]

blue_band(::Type{Landsat7}) = :B1

green_band(::Type{Landsat7}) = :B2

red_band(::Type{Landsat7}) = :B3

nir_band(::Type{Landsat7}) = :B4

swir1_band(::Type{Landsat7}) = :B5

swir2_band(::Type{Landsat7}) = :B7

function dn_scale(::Type{Landsat7}, layer::Symbol)
    @match layer begin
        :thermal => 0.00341802f0
        :B1 || :B2 || :B3 || :B4 || :B5 || :B7 => 0.0000275f0
        _ => 1.0f0
    end
end

function dn_offset(::Type{Landsat7}, layer::Symbol)
    @match layer begin
        :thermal => 149.0f0
        :B1 || :B2 || :B3 || :B4 || :B5 || :B7 => -0.2f0
        _ => 0.0f0
    end
end

function layer_source(::Type{Landsat7}, layer::Symbol)
    qa_regex = "QA_PIXEL." * either("TIF", "tif", "jp2") * END

    @match layer begin
        :B1 => File(:B1)
        :B2 => File(:B2)
        :B3 => File(:B3)
        :B4 => File(:B4)
        :B5 => File(:B5)
        :B7 => File(:B7)
        :panchromatic => File(:B8)
        :thermal => File(:B6)
        :dilated_clouds => BitField(qa_regex, 2)
        :clouds => BitField(qa_regex, 4)
        :cloud_shadow => BitField(qa_regex, 5)
        :snow => BitField(qa_regex, 6)
        :water => BitField(qa_regex, 8)
        _ => error("Landsat7 does not support layer :$(layer)!")
    end
end

function metadata(x::Landsat7)
    # Build Regex
    sensor_pattern = capture(rs"L" * ("C", "O", "T", "E", "M") * exactly(2, DIGIT), as="product")
    level_pattern = capture(rs"L" * DIGIT * exactly(2, WORD), as="level")
    acquisition_date_pattern = capture(exactly(8, DIGIT), as="acquired")
    processing_date_pattern = capture(exactly(8, DIGIT), as="processed")
    collection_pattern = capture(("01", "02"), as="collection")
    regex = sensor_pattern * "_" * level_pattern * rs"_\d{6}_" * acquisition_date_pattern * "_" * processing_date_pattern * "_" * collection_pattern

    # Parse Data From File
    m = match(regex, x.src)

    # Return Metadata
    if !isnothing(m)
        return OrderedDict( 
            "product" => m["product"], 
            "level" => m["level"], 
            "acquired" => Date(m["acquired"], "yyyymmdd"), 
            "processed" => Date(m["processed"], "yyyymmdd"), 
            "collection" => m["collection"] )
    end
    return OrderedDict{String, Any}()
end