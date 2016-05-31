## Script for reading in case data from shape files
    ## Note: Commented section includes additon of new data 
source("src/packagesFiloSpatial.R")
  #Animal points and poly
animal.pt <- readOGR(dsn = "data/InfShp/animalORG",
                     layer = "animal_points")
animal.poly <- readOGR(dsn = "data/InfShp/animalORG",
                      layer = "animal_polygon")

  #Human points and poly
# human.pt <- readOGR(dsn = "data/InfShp/humanORG", 
#                     layer = "index_human_case_modified_point")
# 
# new <- c(-0.616667, 20.433333, 31, 20.433333, -0.616667)
# human.add <- rbind(as.data.frame(human.pt), new)
# coordinates(human.add) <- ~ coords.x1 + coords.x2
# human.pt <- human.add
# writeOGR(obj = human.pt,
#          layer = "index_human_case_modified_point",
#          dsn = "data/InfShp/humanADD", driver =  "ESRI Shapefile",
#          overwrite_layer = T)

human.pt <- readOGR(dsn = "data/InfShp/humanADD", 
                    layer = "index_human_case_modified_point")
                    

human.poly <- readOGR(dsn = "data/InfShp/humanORG",
                     layer = "index_human_case_modified_polygon")
