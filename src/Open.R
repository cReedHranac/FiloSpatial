## Open Script
  #load packages
source("src/packagesFiloSpatial.R")

  # load blank cropping raster
b1 <- raster("data/AfrPrecip/Precip25/AfrPrecip25_1.tif")
as.1 <- function(x){
  if(!is.na(x)){return(1)}else{return(NA)}
}
afr.blnk <- calc(b1, as.1)
rm(b1)

  # load cached data frames 
#full <- read.csv("data/Dataframes/cache/Full.csv")
#outbreaks.df <- read.csv("data/Dataframes/cache/OBmatrix_long.csv")
#breed.df <- read.csv("data/Dataframes/cache/BRmatrix_long.csv")
comp.df <- read.csv("data/Dataframes/cache/complete_df.csv")