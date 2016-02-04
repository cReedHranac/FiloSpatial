## Script for monthly rainfall data
setwd(file.path("~/Desktop/FiloSpatial/"))
library(ProjectTemplate)
load.project("FiloSpatial.Rproj")


#Reading African shapefile
afr.poly <- readOGR(dsn = "data/Africa", layer = "AfricanCountires")

#Reading in the Rasters from WorldClim (already downloaded)
m.precip <- list.files(path = "data/prec_30s_bil/",
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

#Changing to cleaned directory
setwd(file.path("~/Desktop/FiloSpatial/data/AfrPrecip/"))

for(i in 1:12){
  writeRaster(x = precip.af.m[[i]],
              filename = paste("Afr_Precip",i,".tif", sep=""))
}