## Script for reading in case data
setwd(file.path("~/Desktop/Filovirus/"))
library(ProjectTemplate)
load.project("Filovirus")

library(rgdal)

  #Animal points and poly
animal.pt <- readOGR(dsn = "data/Raw data/animal/",
                     layer = "animal_points")
animal.poly <- readOGR(dsn = "data/Raw data/animal/",
                      layer = "animal_polygon")

  #Human points and poly
human.pt <- readOGR(dsn = "data/Raw data/human/", 
                    layer = "index_human_case_modified_point")
human.poly <- readOGR(dsn = "data/Raw data/human/",
                     layer = "index_human_case_modified_polygon")
