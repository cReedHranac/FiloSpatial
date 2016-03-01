##Script for loading potential reservoir SDMs
library(ProjectTemplate)
load.project("FiloSpatial")

  res.spec <- readOGR(dsn = "data/AfrSpecShp/", 
                    layer = "AfrSpecDist")
  