function _get_files(dir::String)
    vcat([map(x -> joinpath(root, x), files) for (root, _, files) in walkdir(dir)]...)
end

function _read_bit(x, pos; bits=16)
    left_shift = bits - pos
    right_shift = bits - 1
    return UInt8.((x .<< left_shift) .>> right_shift)
end