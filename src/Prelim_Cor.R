## Simple regressions of breeding time with normalized precipitation of that location
library(ProjectTemplate)
load.project('FiloSpatial')

Class1 <- subset(breed.precip, breed.precip$Class==1)
Class2 <- subset(breed.precip, breed.precip$Class==2)
Class3 <- subset(breed.precip, breed.precip$Class==3)

all.full <- glm(M.Start ~ Precip, data = breed.precip, family = 'binomial')
all.m1 <- glm(M.Start ~ Minus1., data = breed.precip, family = 'binomial')
all.m2 <- glm(M.Start ~ Minus2., data = breed.precip, family = 'binomial')
all.all <-  glm(M.Start ~ Precip + Minus1. + Minus2., data = breed.precip, family = 'binomial')
resid(all.all))



#Class 1 
all.full.c1 <- glm(M.Start ~ Precip, data = Class1, family = 'binomial')
all.m1.c1 <- glm(M.Start ~ Minus1., data = Class1, family = 'binomial')
all.m2.c1 <- glm(M.Start ~ Minus2., data = Class1, family = 'binomial')

#Class 2
all.full.c2 <- glm(M.Start ~ Precip, data = Class2, family = 'binomial')
all.m1.c2 <- glm(M.Start ~ Minus1., data = Class2, family = 'binomial')
all.m2.c2 <- glm(M.Start ~ Minus2., data = Class2, family = 'binomial')

#Class 3 
all.full.c3 <- glm(M.Start ~ Precip, data = Class3, family = 'binomial')
all.m1.c3 <- glm(M.Start ~ Minus1., data = Class3, family = 'binomial')
all.m2.c3 <- glm(M.Start ~ Minus2., data = Class3, family = 'binomial')

coordinates(breed.precip) <- ~Lon + Lat
coordinates(outbreaks) <- ~ lat + lon

source("src/Load_Precip_25.R")
for(i in 1:12){
  plot(precip.25[[i]],main=i)
  t<-subset(breed.precip, breed.precip$Month==i & breed.precip$M.Start==1)
  plot(t, add=T, col="red")
  z<- subset(outbreaks, outbreaks$M.Start==i)
  plot(z, add=T, col="blue")
}