function test_colors(bandset::Type{<:AbstractSatellite}, colors)
    @test blue_band(bandset) == colors[:blue]
    @test green_band(bandset) == colors[:green]
    @test red_band(bandset) == colors[:red]
    @test nir_band(bandset) == colors[:nir]
    @test swir1_band(bandset) == colors[:swir1]
    @test swir2_band(bandset) == colors[:swir2]
end

function test_layers(bandset::Type{<:AbstractSatellite}, answer_src::String, answer_key::String, data_src::String)
    answer = JSON.parsefile(answer_src)[answer_key]
    response = getlayers(bandset, data_src)
    @test Set(bandnames(bandset)) == Set(keys(response))
    @test all([answer[k] == basename(response[Symbol(k)]) for k in keys(answer)])
end