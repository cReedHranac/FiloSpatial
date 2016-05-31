## Script for subsetting species distributions for selected species
source("src/packagesFiloSpatial.R")

##Potential host species 
  Af.spec <- read.csv("data/Dataframes/AfSpecies.csv")
  af.spec <- apply(Af.spec,
                   2,
                   str_replace, "_", " ")
  af.spec <- as.data.frame(af.spec)

##Reading in the species shapefiles
  mam <- readOGR(dsn = "data/MAMMTERR",
                 layer = "Mammals_Terrestrial")

##Subsetting the terrestial database
  spec.shp <- mam[mam@data$BINOMIAL %in% af.spec$Species_Binomial,]

##Loading Africa Shapefile
  Afr.shp <- readOGR(dsn = "data/Africa",
                     layer = "AfricanCountires")

##Croping to Africa
  spec.shp.cr <-crop(spec.shp, Afr.shp)
  
##Adding class varriable
  m <- match(spec.shp.cr@data$BINOMIAL,af.spec$Species_Binomial)
  spec.shp.cr@data$Class <- af.spec[m,"Class"]
  
##Writing out cleaned
  writeOGR(obj = spec.shp.cr, dsn = "data/AfrSpecShp", layer = "AfrSpecDist", driver = "ESRI Shapefile", overwrite_layer = T)

