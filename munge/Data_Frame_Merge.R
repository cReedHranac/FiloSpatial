################################
## Merging all dataframes into 1 producting the "full" dataframe
################################
source("src/packagesFiloSpatial.R")

## Load Dataframes
  an.index <- read.csv(file = "data/Dataframes/Animal_Index_16Feb.csv", header = T)
  hu.index <- read.csv(file = "data/Dataframes/Human_Index_30May.csv", header = T)
  breeding <- read.csv(file = "data/Dataframes/BreedingDB.csv", header = T)
  
## Obtaining centroids for index cases
  afr.poly <- readOGR(dsn = "data/Africa", layer = "AfricanCountires") #reading shape file
  source("src/Index_Cases.R")
  
  ##Animal index case points and merging with ID numbers
    an.cntr <- SpatialPointsDataFrame(gCentroid(animal.poly, byid = T), animal.poly@data)
    an.c <- cbind(an.cntr@coords, an.cntr@data$OUTBREAKS)
    an.p <- cbind(animal.pt@coords, animal.pt@data$UNIQUE_ID)
    colnames(an.p) <-c("x","y","")
    an.pts<- rbind(an.p,an.c)
    colnames(an.pts) <-c("lon","lat","OUTBREAK_ID")   
    an.pts<-as.data.frame(an.pts)
    animal.frame <- merge(an.pts, an.index, by= "OUTBREAK_ID")
  ##Human index case points
    hu.cnter <- SpatialPointsDataFrame(gCentroid(human.poly, byid = T), human.poly@data)
    hu.c <- cbind(hu.cnter@coords, hu.cnter@data$OUTBREAK)
    hu.p <- cbind(human.pt@coords, human.pt@data$OUTBREAK)
    hu.pts <- rbind(hu.c, hu.p)
    colnames(hu.pts) <-c("lon","lat","Outbreak_ID")
    hu.pts <- as.data.frame(hu.pts)  
    human.frame <- merge(hu.pts, hu.index, by= "Outbreak_ID")

## Servicing dataframes for merger
    #Animal
    animal.sub <- cbind(animal.frame[,c("OUTBREAK_ID", "lat", "lon", "Virus", "Country", "Place", "Apparnet.Origin", "Month.Start","Species", "Reference","Class")])
    for(i in 1:nrow(animal.sub)){
      animal.sub$OUTBREAK_ID[i] <- paste(i,"A",sep = "")
    } ## Adding an "A" to the outbreak id 
    colnames <- c("ID","lat","lon","Virus","Country","Place","Origin.Species","M.Start","Species","Ref","Class")
    colnames(animal.sub) <-colnames
    
    #Human
    human.sub <- cbind(human.frame[,c("Outbreak_ID", "lat","lon","Virus","Country", "Apparnet.Origin", "Outbreak.Notes", "Month.Start", "Article.Ref","Class")])
    for(i in 1:nrow(human.sub)){
      human.sub$Outbreak_ID[i] <- paste(i,"H",sep="")
    }
    colnames(human.sub) <- c("ID", "lat", "lon", "Virus","Country","Place", "Outbreak.Notes", "M.Start", "Ref","Class")
    
    #Breeding
    breeding$Start <-round(breeding$Start)
    breeding.sub <-cbind(breeding[,c("Spec_Binom","Lat","Lon","Place_Notes","Start","Reference","Class")])
    colnames(breeding.sub) <- c("Species", "lat", "lon", "Place","M.Start", "Ref", "Class")
    breeding.sub$ID <-1:nrow(breeding)
    for(i in 1:nrow(breeding.sub)){
      breeding.sub$ID[i] <- paste(i,"Q",sep = "")
    }

## Merging all together
    full <- rbind.fill(breeding.sub, human.sub, animal.sub)
    write.csv(x = full,
              row.names = F,
              "data/Dataframes/cache/Full.csv")
    
## Cleaning up 
    rm("afr.poly", "an.c", "an.cntr", "an.index", "an.p", "an.pts", "animal.frame", "animal.poly", "animal.pt",
       "animal.sub", "breeding", "breeding.sub", "colnames", "hu.c", "hu.cnter", "hu.index", "hu.p", "hu.pts",
       "human.frame", "human.poly", "human.pt", "human.sub", "i")
    
    