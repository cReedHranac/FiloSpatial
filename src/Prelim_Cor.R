## Simple regressions of breeding time with normalized precipitation of that location
library(ProjectTemplate)
load.project('FiloSpatial')


#### Linear Regression no offset
  ## All of collected breeding records
  full <- glm(M.Start ~ Precip, data= breed.precip, family = 'binomial')
    summary(full) #Significant p.val = .00863
      plot(full$residuals)
      
  ## Class 1: Megachioptera
  C1 <- subset(breed.precip, breed.precip[,"Class"]==1, family = 'binomial')
    C1.r <- glm(M.Start ~ Precip, data= C1)
    summary(C1.r) # Non-Significant p.val = .75
    plot(C1.r$residuals)

  ## Class 2: Molossidae
  C2 <- subset(breed.precip, breed.precip[,"Class"]==2)
    C2.r <- glm(M.Start ~ Precip, data= C2, family = 'binomial')
    summary(C2.r) # Significant p.val = .000192
    plot(C2.r$residuals)
    
  ## Class 3: Other Microchiroptera
  C3 <- subset(breed.precip, breed.precip[,"Class"]==3)
    C3.r <- glm(M.Start ~ Precip, data= C3, family = 'binomial')
    summary(C3.r) # Significant = .0149
    plot(C3.r$residuals)  

    
## With Precip of previous month (minus 1)
    full.m1 <- glm(M.Start ~ Minus1., data= breed.precip, family = 'binomial')
    summary(full.m1) #Significant p.val= .0109
    
    ## Class 1: Megachioptera
    C1.r.m1 <- glm(M.Start ~ Minus1., data= C1)
    summary(C1.r.m1) #Signigicant p.val = .0165
    
    ## Class 2: Molossidae
    C2.r.m1 <- glm(M.Start ~ Minus1., data= C2, family = 'binomial')
    summary(C2.r.m1) # NOT Significant p.val = .0778
    
    ## Class 3: Other Microchiroptera
    C3.r.m1 <- glm(M.Start ~ Minus1., data= C3, family = 'binomial')
    summary(C3.r.m1) # NOT Significant = .85
    
## With Precip of two months previous (minus 2)
    full.m2 <- glm(M.Start ~ Minus2., data= breed.precip, family = 'binomial')
    summary(full.m2) # NOT Significant p.val= .0973
    
    ## Class 1: Megachioptera
    C1.r.m2 <- glm(M.Start ~ Minus2., data= C1)
    summary(C1.r.m2) # NOT Signigicant p.val = .772
    
    ## Class 2: Molossidae
    C2.r.m2 <- glm(M.Start ~ Minus2., data= C2, family = 'binomial')
    summary(C2.r.m2) # NOT Significant p.val = .269
    
    ## Class 3: Other Microchiroptera
    C3.r.m2 <- glm(M.Start ~ Minus2., data= C3, family = 'binomial')
    summary(C3.r.m2) # Significant = .00526
    
    
##Is there a corrilation between longittude and precipittion in Africa that we could use?
    
    source("src/Load_Precip.R")
    precip.stack  <- stack(afr.precip)
    coordinates(full) <- ~ lon + lat
    ex.full <- extent(full)
    ## Grabing some random points
    xy.r <- sampleRandom(afr.precip[[1]], 2500,ext=ex.full, sp=T)
    xy.rd <- as.data.frame(xy.r)
    xy.rd <- xy.rd[,-1]
    coordinates(xy.rd) <- ~x + y
    xy.p.r <- as.data.frame(raster::extract(precip.stack, xy.rd))
    
    sample.norm <- apply(X = xy.p.r,2, normalize)
    frame <- cbind(as.data.frame(xy.rd), sample.norm)
    
    test <- lm(x~ Afr_Precip1, data = frame)
    summary(test) ## Pass 
    test2 <- lm(x~ Afr_Precip2, data = frame)
    summary(test2) ## DN Pass
    test3 <- lm(x~ Afr_Precip3, data = frame)
    summary(test3) ## Pass
    test4 <- lm(x~ Afr_Precip4, data = frame)
    summary(test4) ## Pass
    test5 <- lm(x~ Afr_Precip5, data = frame)
    summary(test5) ## Pass
    test6 <- lm(x~ Afr_Precip6, data = frame)
    summary(test6) ## Pass
    test7 <- lm(x~ Afr_Precip7, data = frame)
    summary(test7) ## Pass
    test8 <- lm(x~ Afr_Precip8, data = frame)
    summary(test8) ## DN Pass
    test9 <- lm(x~ Afr_Precip9, data = frame)
    summary(test9) ## Pass
    test10 <- lm(x~ Afr_Precip10, data = frame)
    summary(test10) ## Pass
    test11 <- lm(x~ Afr_Precip11, data = frame)
    summary(test11) ## Pass
    test12 <- lm(x~ Afr_Precip12, data = frame)
    summary(test12) ## Pass 

    
## Testing Spatial Autocorrilation:
    source("src/Load_Precip.R")
    afr.moran <- lapply(afr.precip, Moran)
    
    