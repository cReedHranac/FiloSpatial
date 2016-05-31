# packagesFiloSpatial.R

### Checks for required packages and installs if not present ###

packs <- rownames(installed.packages()) # names of all installed packages
req <- c("reshape", "plyr", "dplyr", "tidyr", "ggplot2", "stringr", "raster", "rgeos", "rgdal") # packages required to run code
toInstall <- req[!is.element(req,packs)] # packages needing installation

if(length(toInstall)>0){
  if(verbose){
    print("The following packages are required and will be installed:")
    print(toInstall)
  }
  install.packages(toInstall)
}
lapply(req, library, character.only = TRUE)

# clean up workspace:
rm(packs,req,toInstall)
