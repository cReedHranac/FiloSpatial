
source("src/Open.R")
comp<-comp.df
sum_rows <- function(x) {
  sum <- rowSums(x, na.rm=TRUE)
  wch_na = rowSums(is.na(x))==ncol(x)
  sum[wch_na] <- NA
  sum
}

# Creating outbreak total column
comp$Ob <- sum_rows(comp[, c("Y4", "Y5", "Y6")])

# Creating animal infection total column
comp$An <- sum_rows(comp[, c("Y1", "Y2", "Y3")])

# Creating total breeding colum
comp$Br <- sum_rows(comp[, c("X1", "X2", "X3")])

coordinates(comp) <- ~ x + y
proj4string(comp) <- proj4string(afr.blnk)
plot(afr.blnk)
spplot(comp@data$Ob, )

# Looking for Corrilations with Outbreaks
cor(comp$Ob, comp$Month,  use = "complete")
  #[1] -0.1364474
cor(comp$Ob,comp$AfrPrecip25,  use = "complete")
  #[1] -0.2807927
cor(comp$Ob, comp$afds00ag, use = "complete")
  #[1] -0.1106221
cor(comp$Ob, comp$Mam_sum, use = "complete")
  #[1] 0.1010447
cor(comp$Ob, comp$Mega_sum, use = "complete")
  #[1] 0.08944123
cor(comp$Ob, comp$Micro_sum, use = "complete")
  #[1] 0.02052483
cor(comp$Ob, comp$Molo_sum, use = "complete")
  #[1] -0.05085858
cor(comp$Ob, comp$An, use = "complete")
  # NA There is 1 instance where it is not null...
cor(comp$Ob, comp$Br, use = "complete")
  # Error in cor(comp$Ob, comp$Br, use = "complete") : 
  #   no complete element pairs

# Looking for corrilations with Animal occurrence
  #doesn't work, I get an error saying that the standard deviation is zero

# Looking for corrilations with breeding
cor(comp$Br, comp$Month, use = "complete")
  #[1] 0.1021142
cor(comp$Br, comp$AfrPrecip25, use = "complete")
  #[1] -0.08051541
cor(comp$Br, comp$afds00ag, use = "complete")
  #[1] -0.02739367
cor(comp$Br, comp$Mam_sum, use = "complete")
  #[1] -0.03709257
cor(comp$Br, comp$Mega_sum, use = "complete")
  #[1] -0.1380906
cor(comp$Br, comp$Micro_sum, use = "complete")
  #[1] -0.05852915
cor(comp$Br, comp$Molo_sum, use = "complete")
  #[1] -0.08332857
cor(comp$Br, comp$An, use = "complete")
  # Error in cor(comp$Br, comp$An, use = "complete") : 
  #   no complete element pairs


