function test_colors(bandset::Type{<:AbstractSatellite}, colors)
    @test blue_band(bandset) == colors[:blue]
    @test green_band(bandset) == colors[:green]
    @test red_band(bandset) == colors[:red]
    @test nir_band(bandset) == colors[:nir]
    @test swir1_band(bandset) == colors[:swir1]
    @test swir2_band(bandset) == colors[:swir2]
end

function test_dn_scale(bandset::Type{<:AbstractSatellite}, layers::Vector{Symbol}, scale::Float32)
    scales = [dn_scale(bandset, layer) for layer in layers]
    @test all(scales .== scale)
end

function test_dn_offset(bandset::Type{<:AbstractSatellite}, layers::Vector{Symbol}, offset::Float32)
    offsets = [dn_offset(bandset, layer) for layer in layers]
    @test all(offsets .== offset)
end

function get_sentinel_mask(scl::Raster, layer::Symbol)
    @match layer begin
        :cloud_shadow => UInt8.(scl .== 0x03)
        :vegetation => UInt8.(scl .== 0x04)
        :non_vegetated => UInt8.(scl .== 0x05)
        :water => UInt8.(scl .== 0x06)
        :clouds_med => UInt8.(scl .== 0x08)
        :clouds_high => UInt8.(scl .== 0x09)
        :cirrus => UInt8.(scl .== 0x0a)
        :snow => UInt8.(scl .== 0x0b)
    end
end

function get_landsat_mask(qa::Raster, layer::Symbol)
    @match layer begin
        :dilated_clouds => read_bit(qa, 2)
        :clouds => read_bit(qa, 4)
        :cloud_shadow => read_bit(qa, 5)
        :snow => read_bit(qa, 6)
        :water => read_bit(qa, 8)
    end
end

function read_bit(x, pos, bits=16)
    left_shift = bits - pos
    right_shift = bits - 1
    new_x = UInt8.((x .<< left_shift) .>> right_shift)
    return Rasters.rebuild(new_x, missingval=0x00, name=x.name)
end