# Main data source: ACS_13_5YR_DP03.zip
rm(list=ls());

# Working Dir
homeDir = "~/Projects/York/Research/data";#linux
setwd(homeDir);

origPath <- file.path(homeDir,"original/CASdatasets/");
tidyPath <- file.path(homeDir,"tidy/CASdatasets/");

# Clean Old Data
unlink(tidyPath, r = T, f = T);
dir.create(tidyPath, showWarnings = T);

## Analyze and Save Function
source("./CASdatasets/anSave.R")
dir.create(paste0(tidyPath,'/full'), showWarnings = T);

analyzeANDSave(auscathist[c("Type","Year","OriginalCost")],15,'aus');
analyzeANDSave(nzcathist[c("Type","Year","OriginalCost")],15,'nz');

# Partial Data
source("./CASdatasets/getPartial.R")
dir.create(paste0(tidyPath,'/partial'), showWarnings = T);

aus <- getPartial('aus');
nz <- getPartial('nz');

barplot(t(nz), main="New Zealand", legend.text = colnames(nz))
barplot(t(aus),main="Australia", legend.text = colnames(aus))
