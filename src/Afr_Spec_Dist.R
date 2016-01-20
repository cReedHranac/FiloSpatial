## Script for importing species distributions for selected species
library(ProjectTemplate)
setwd(file.path("~/Desktop/Filovirus"))
load.project('Filospatial')

library(rgdal)
library(stringr)
library(raster)

#Reading in the potential host species 
Af.spec <- read.csv("data/AfSpecies.csv")

#Reading in the species shapefiles
mam <- readOGR(dsn = "data/MAMMTERR",
               layer = "Mammals_Terrestrial")

#Changing the binomial format
spec.ls <- lapply(Af.spec$Species_Binomial,
                  str_replace, "_", " ")

#Subsetting the terrestial database
spec.shp <- mam[mam@data$BINOMIAL %in% spec.ls,]

#Loading Africa Shapefile
Afr.shp <- readOGR(dsn = "data/Africa",
                   layer = "AfricanCountires")

#Croping to Africa
spec.shp.cr <-crop(spec.shp, Afr.shp)

#Writing out cleaned
writeOGR(obj = spec.shp.cr, dsn = "data/AfrSpecShp", layer = "AfrSpecDist", driver = "ESRI Shapefile")

