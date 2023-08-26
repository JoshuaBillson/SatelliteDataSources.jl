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
    @test all([answer[k] == response[Symbol(k)] for k in keys(answer)])
end

function download_data(link, dst)
    mkpath(joinpath(splitpath(dst)[1:end-1]))
    if !isdir(dst)
        dst_path = splitpath(dst)[1:end-1] |> joinpath
        file = gdownload(link, dst_path)
        run(`unzip $file -d $dst_path`)
        rm(file, force=true)
    end
end