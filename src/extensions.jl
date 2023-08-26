getlayer(raster, layer::Symbol) = raster[layer]

getlayer(raster, layer::Integer) = raster[:,:,layer]