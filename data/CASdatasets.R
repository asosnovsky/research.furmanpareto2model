# Working Dir
setwd("C:/Box/Research/data");# My home dir

path <- "original/CASdatasets/";

load(paste0(path, "auscathist.rda"));
load(paste0(path, "nzcathist.rda"));
 
data <- split(auscathist,auscathist$Type)
View(data[[1]])

dat = data[[1]][c("FirstDay","Location", "OriginalCost", "NormCost2011","NormCost2014")];
colnames(dat)[-(1:2)] = paste(data[[i]]$Type[1], colnames(dat)[-(1:2)]);
dt = dat;

for(i in 2:length(data)){
  dat = data[[i]][c("FirstDay","Location", "OriginalCost", "NormCost2011","NormCost2014")];
  colnames(dat)[-(1:2)] = paste(data[[i]]$Type[1], colnames(dat)[-(1:2)]);
  dt = merge(dat, dt, all.x=TRUE, all.y=TRUE);
}


View(createMini(data[[1]]))
