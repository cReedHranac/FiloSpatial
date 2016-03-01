## Regression of index cases against monthly precip
setwd("~/Desktop/FiloSpatial/")
library(ProjectTemplate)
load.project('FiloSpatial.Rproj')

#Loading index case shapefiles and monthly precip data
source("src/Load_Precip.R")
source("src/Index_Cases.R")

#loading index case data files
human.index <- read.csv("data/Modified_Ebola_index_outbreak_140905.csv")
animal.index <- read.csv("data/latest_animal_case.csv")

#Obtaining and merging centrolds to point dataframes
animal.poly.cntr <- SpatialPointsDataFrame(gCentroid(animal.poly, byid = T),
                                          animal.poly@data, match=F)
human.poly.cntr <-SpatialPointsDataFrame(gCentroid(human.poly, byid = T),
                                         human.poly@data, match=F)
