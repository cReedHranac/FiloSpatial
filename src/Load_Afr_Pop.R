##Script to read in African popultation density 
source("src/packagesFiloSpatial.R")
afr.pop <- raster('data/af_gpwv3_pdens_00_ascii_25/afds00ag.asc')

proj4string(afr.pop) <- proj4string(afr.blnk)
pop.25 <- projectRaster(afr.pop, afr.blnk)

rm(afr.pop)