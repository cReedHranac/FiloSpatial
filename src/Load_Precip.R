##Script for Loading Precip Layers
dir.now <- getwd() # storing current wd
setwd(file.path("~/Desktop/FiloSpatial/"))
library(ProjectTemplate)
load.project("FiloSpatial.Rproj")

#Reading in the layers
files <- list.files(path = "data/AfrPrecip/", 
                    pattern = ".tif")

setwd(file.path("data/AfrPrecip/"))
afr.precip <- lapply(files,
                     raster)

setwd(dir.now) # Resetting wd
rm(files, dir.now) # Removing temporary items created

