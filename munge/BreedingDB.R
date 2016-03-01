## Script for generating normalized monthly rainafll values for each breeding location and month as a serise of binary varriables
setwd("~/Desktop/FiloSpatial/")
library(ProjectTemplate)
load.project('FiloSpatial.Rproj')

#Sourcing Africian precip data
source("src/Load_Precip.R")
  precip.stack <- stack(afr.precip)   #Stacking

##Reading in BreedingDB
  dat <- read.csv("data/Dataframes/BreedingDB.csv", header = T)
  dat$X<-paste("q",1:nrow(dat),sep="") #Creating unique ID 
  
##Creating month of birth start as a binary variable 
  dat$Start <-round(dat$Start) #roudning the month of breeding start
  bi.gen <- as.data.frame(matrix(nrow=nrow(dat), ncol=12)) #creating empty matrix to deposit values in
  for(i in 1:nrow(dat)){
    ## Creating a binary matrix of the start of birthing
    ## Goes through each row and creates a vector of 12 0s, and then replaces where dat$Start with 1
    a <- rep(0,12)
    a[dat$Start[i]]=1
    bi.gen[i,] <- a
  } 
  colnames(bi.gen) <- paste0("M.Start.",1:12)
  bi.gen$ID <- dat$X #adding ID tag  
  dat.bi <- merge(dat,bi.gen, by.x="X", by.y="ID")

##Adding normalized precipitation data from each point
  coordinates(dat) <- ~ Lon + Lat #creating spatial points
  xy.precip <- as.data.frame(raster::extract(precip.stack, dat)) #Extracting climate data for each point
    ##Normalize data
  normalize <- function(x){
    ## function for normalizing precipitation values between 0 and 1
    (x-min(x))/(max(x)-min(x))
  }
  
      ####NOTE: Issues with the apply function... when I select apply accross rows, it inverts the table.
  xy.norm <- as.data.frame(t(apply(xy.precip,1,normalize))) #applying norm across data 
  #xy.norm1 <- as.data.frame(apply(xy.precip,2,normalize))
  head(xy.precip)
  head(xy.norm)
      ####NOTE: Values appear to be correct however
  
  colnames(xy.norm) <- paste0("Precip.",1:12)
  xy.norm$Y <-paste("q",1:nrow(xy.norm),sep="") #Generating matching ID
  dat.precip <- merge(dat.bi, xy.norm,by.x="X", by.y="Y") #Merging the dataframes
  
## Generating time lags
  # 1 month lag -> month before
  minus1 <- as.data.frame(matrix(ncol = ncol(xy.norm)))
  colnames(minus1) <- c("Precip.12", paste0("Precip.",1:11), "Y")
  for( i in 1:nrow(xy.norm)){
    m1<-cbind( xy.norm[i,12], xy.norm[i,1:11], xy.norm[i,13])
    colnames(m1) <- c("Precip.12", paste0("Precip.",1:11), "Y")
    minus1 <- rbind(minus1, m1)
  }
  minus1 <-minus1[-1,]
  colnames(minus1) <-c(paste0("Minus1.",1:12), "Y")
  dat.precip <- merge(dat.precip, minus1, by.x = "X", by.y = "Y")
  
  # 2 month lag -> 2 months before
  minus2 <- as.data.frame(matrix(ncol = ncol(xy.norm)))
  colnames(minus2) <- c(paste0("Precip.",11:12), paste0("Precip.",1:10), "Y")
  for( i in 1:nrow(xy.norm)){
    m2<-cbind( xy.norm[i,11:12], xy.norm[i,1:10], xy.norm[i,13])
    colnames(m2) <- c(paste0("Precip.",11:12), paste0("Precip.",1:10), "Y")
    minus2 <- rbind(minus2, m2)
  }
  minus2 <-minus2[-1,]
  colnames(minus2) <-c(paste0("Minus2.",1:12), "Y")
  dat.precip <- merge(dat.precip, minus2, by.x = "X", by.y = "Y")  

##Flipping the data structure
      library(tidyr)
      library(stringr)
      library(dplyr)
  

  
  dat.month <- dat.precip %>% 
    dplyr::select(-(Precip.1:Precip.12), -(Minus1.1:Minus1.12), -(Minus2.1:Minus2.12)) %>% 
    gather(key="Month", value="M.Start", M.Start.1:M.Start.12)

  dat.month.p <- dat.precip %>% 
    dplyr::select(-starts_with('M.Start'), -(Minus1.1:Minus1.12), -(Minus2.1:Minus2.12)) %>%
    gather(key="Month", value="Precip", Precip.1:Precip.12)
  
  dat.month.m1 <- dat.precip %>%
    dplyr::select(-(Minus2.1:Minus2.12), -(Precip.1:Precip.12), -starts_with('M.Start')) %>%
    gather(key="Month", value="Minus1.", Minus1.1:Minus1.12)
  
  dat.month.m2 <- dat.precip %>%
    dplyr::select(-(Minus1.1:Minus1.12), -(Precip.1:Precip.12), -starts_with('M.Start')) %>%
    gather(key="Month", value="Minus2.", Minus2.1:Minus2.12)
  
  dat.month <- dat.month %>% 
    mutate(Month = as.numeric(substring(Month, 9)))
  dat.month.p <- dat.month.p %>%
    mutate(Month = as.numeric(substring(Month, 8)))
  dat.month.m1 <- dat.month.m1 %>%
    mutate(Month = as.numeric(substring(Month, 8)))
  dat.month.m2 <- dat.month.m2 %>%
    mutate(Month = as.numeric(substring(Month, 8)))
  
  breed.precip = dat.month %>% 
    left_join(dat.month.p) %>%
    left_join(dat.month.m1) %>%
    left_join(dat.month.m2)


cache('breed.precip')

  