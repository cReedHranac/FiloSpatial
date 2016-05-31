## Script for monthly rainfall data
source("src/packagesFiloSpatial.R")

#Reading African shapefile
afr.poly <- readOGR(dsn = "data/Africa", layer = "AfricanCountires")

#Reading in the Rasters from WorldClim (already downloaded)
m.precip <- list.files(path = "data/AfrPrecip/prec_30s_bil/",
                       pattern = ".bil")
setwd(file.path("data/prec_30s_bil/"))
precip.r <- lapply(m.precip,
                   raster)

#Cropping to the extent of Africa
precip.af <- lapply( precip.r,
                     crop,extent(afr.poly))

#Masking to extent
precip.af.m <- lapply(precip.af,
                      mask, afr.poly)

for(i in 1:12){
  writeRaster(x = precip.af.m[[i]],
              filename = paste("data/Afr_Percip/Afr_Precip",i,".tif", sep=""))
}