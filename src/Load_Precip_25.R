##Script for Loading Precip Layers

#Reading in the layers
files <- list.files("data/AfrPrecip/Precip25/", 
                    pattern = ".tif")

precip.25 <- lapply(paste0("data/AfrPrecip/Precip25/",files),
                     raster)

rm(files) # Removing temporary items created
