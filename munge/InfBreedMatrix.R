#################################################
## Spript for creating large spatial infection matrix
#################################################

source("src/Open.R")

## Working to create a dataframe with the structure of
  ## Raster block ID | Lat | Long | Month | Rainfall (raw) | Outbreak (Logical) | Outbreak (Animal count) | Outbreak (Human count) |
    ## Bat Birth C1 | Bat Brith C2 | Bat Brith C3 | Bat Diversity C1 | Bat Diversity C2 | Bat Diversity C3 | Total Mammalian Diversity
  # C1: Megachiroptera, C2: Molossidae, C3: Non-molossidae microchiprotpera, C4: Infection likely due to contact with reservoir species (bat)
  # C5: Infection due to contact with other infected mammal, C6: Unknown infection origin 

  ## Covariate stack
# Loading precip stack
source("src/Load_Precip_25.R")
# creating column vectors
precip.25 <- stack(precip.25)

# Loading pop density
source("src/Load_Afr_Pop.R")

# Loading diversity rasters
source("src/DiversityRasters.R")
div.stk <- stack(div.rast)

covar.stk <- stack(pop.25, div.stk)
covar.df <- as.data.frame(covar.stk)
covar.df$id <- 1:nrow(covar.df)
covar.df <- cbind(covar.df, xyFromCell(afr.blnk, cell = covar.df$id ))
  
  ##Temporal dataframes (breed and outbreaks in cache)
tempo.df <- cbind(outbreaks.df, breed.df, as.data.frame(precip.25))
tempo.df$id <- 1:nrow(tempo.df)

tempo.g <- tempo.df %>% gather(Variable, Value, -id)
tempo.split <- tempo.g %>% tidyr::extract(Variable, into=c("Variable", "Month"), regex="(.*)[\\._]([0-9]+)$", convert=TRUE)
tempo.fin <- tempo.split %>% spread(Variable, Value)

rm(precip.25, breed.df, full, outbreaks.df, afr.blnk, as.1, pop.25, div.rast, div.stk, tempo.df, tempo.g, tempo.split, covar.stk)
comp.df <- left_join(tempo.fin, covar.df)


write.csv(comp.df, "data/DataFrames/cache/complete_df.csv", row.names = F)
