##################################
## Processing Outbreak Data Frame
##################################

outbreaks <- full[106:nrow(full),]
coordinates(outbreaks) <- ~lat + lon
source("src/Load_Res_SDM.R")
proj4string(outbreaks) <-crs(res.spec)

##Adding human population density
source("src/Load_Afr_Pop.R")
outbreaks$pop.den <- raster::extract(afr.pop, outbreaks)

##Adding reservoir species counts to each outbreak location
df <-over(outbreaks, res.spec, returnList = T)
res.fill <- as.data.frame(matrix(nrow=nrow(outbreaks), ncol = 4))
for(i in 1:length(df)){
  t.spec <- length(unique(df[[i]]$BINOMIAL))
  class.n <- as.character(unique(df[[i]]$Class))
  class.bi <- rep(0,3)
  ifelse('1' %in% class.n, class.bi[1]<-1, class.n[1]<-0)
  ifelse('2' %in% class.n, class.bi[2]<-1, class.n[2]<-0)
  ifelse('3' %in% class.n, class.bi[3]<-1, class.n[3]<-0)
  res.fill[i,] <-c(t.spec, class.bi)
}
colnames(res.fill)<- c("Res.Species.T", "Res.Class.1", "Res.Class.2", "Res.Class.3")
res.fill$ID <- outbreaks$ID
outbreaks <- merge(outbreaks, res.fill, by.x='ID', by.y='ID')

## Subsetting IUNC data set for African mammals and African Bats
mam <- readOGR(dsn = "data/MAMMTERR",layer = "Mammals_Terrestrial")
afr.poly <- readOGR(dsn = "data/Africa", layer = "AfricanCountires")
afr.1 <- gUnaryUnion(afr.poly)
plot(afr.1)
###mam.afr <- crop(mam, afr.1) ### Takes a long time!!!


##Mammalian diversity at each site
proj4string(outbreaks) <- crs(mam.afr)
df.mam <- over(outbreaks, mam.afr, returnList = T)
mam.fill <- as.data.frame(matrix(nrow = length(df.mam), ncol = 1))
for(i in 1:length(df.mam)){
  mam.fill[i,] <- length(unique(df.mam[[i]]$BINOMIAL))
}
colnames(mam.fill) <- "Mam.Diversity"
mam.fill$ID <- outbreaks$ID
outbreaks <- merge(outbreaks, mam.fill, by.x='ID', by.y= 'ID')
outbreaks <- as.data.frame(outbreaks)
cache('outbreaks')
