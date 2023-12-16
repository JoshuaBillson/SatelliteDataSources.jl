function _get_files(dir::String)
    vcat([map(x -> joinpath(root, x), files) for (root, _, files) in walkdir(dir)]...)
end

function _band_regex(bands::Vector{Symbol})
    return "_" * capture(either(string.(bands)...), as="layer") * "." * ["TIF", "tif", "tiff", "TIFF", "JP2", "jp2"] * END
end

function _read_bit(x, pos; bits=16)
    left_shift = bits - pos
    right_shift = bits - 1
    return UInt8.((x .<< left_shift) .>> right_shift)
end