###############################
## Aggregrating rainfall data

library(ProjectTemplate)
load.project('FiloSpatial')

source('src/Load_Precip.R')

for( i in seq(from=20, to=200, by=20)){
  name1 <- paste0('precip.mean.',i)
  assign(name1, lapply(afr.precip, aggregate, i, mean))
  name2 <- paste0('precip.var', i)
  assign(name2, lapply(afr.precip, aggregate, i, var))
}
var.mean.10 <- unlist(lapply(precip.mean.10, cellStats, var))
var.mean.20 <- unlist(lapply(precip.mean.20, cellStats, var))
var.mean.30 <- unlist(lapply(precip.mean.30, cellStats, var))
var.mean.40 <- unlist(lapply(precip.mean.40, cellStats, var))
var.mean.50 <- unlist(lapply(precip.mean.50, cellStats, var))
var.mean.60 <- unlist(lapply(precip.mean.60, cellStats, var))
var.mean.70 <- unlist(lapply(precip.mean.70, cellStats, var))
var.mean.80 <- unlist(lapply(precip.mean.80, cellStats, var))
var.mean.90 <- unlist(lapply(precip.mean.90, cellStats, var))
var.mean.100 <- unlist(lapply(precip.mean.100, cellStats, var))

scale <- seq(from=10, to=100, by=10)
sum.var.10 <- unlist(lapply(precip.var10, cellStats, sum))
sum.var.20 <- unlist(lapply(precip.var20, cellStats, sum))
sum.var.30 <- unlist(lapply(precip.var30, cellStats, sum))
sum.var.40 <- unlist(lapply(precip.var40, cellStats, sum))
sum.var.50 <- unlist(lapply(precip.var50, cellStats, sum))
sum.var.60 <- unlist(lapply(precip.var60, cellStats, sum))
sum.var.70 <- unlist(lapply(precip.var70, cellStats, sum))
sum.var.80 <- unlist(lapply(precip.var80, cellStats, sum))
sum.var.90 <- unlist(lapply(precip.var90, cellStats, sum))
sum.var.100 <- unlist(lapply(precip.var100, cellStats, sum))

var.mean <- cbind(var.mean.10, var.mean.20, var.mean.30, var.mean.40, var.mean.50, var.mean.60, var.mean.70, var.mean.80, var.mean.90, var.mean.100)
var.means.frame <- apply(var.mean,2,mean)
plot(scale,var.means.frame)
frame <- cbind(sum.var.10, sum.var.20, sum.var.30, sum.var.40, sum.var.50, sum.var.60, sum.var.70, sum.var.80, sum.var.90, sum.var.100)

sums.var <- apply(frame,2,sum)
plot(scale, sums.var)
## Optimum selected at aggregation of by 25 
##

precip.25 <- lapply(afr.precip, aggregate, 25, mean)

path <- "data/AfrPrecip"
for(i in 1:12){
  writeRaster(precip.25[[i]], filename = paste(path,"/AfrPrecip25_",i,".tif",sep = ""))
}

rm(list=ls())
