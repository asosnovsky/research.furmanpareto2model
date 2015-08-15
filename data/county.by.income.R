# Working Dir
homeDir = "~/Projects/York/Research/data";#linux
setwd(homeDir);

# Load Data
fam.data <- read.csv("tidy/family.bygroup.anno.csv");
us.states <- unlist(read.csv("original/wiki/us.states.csv")["State"]);

dir.create(
  file.path(homeDir, "tidy","family.county.by.income"), 
  showWarnings = FALSE);

for(iState in 1:length(us.states)) {
  temp.stor <- t(fam.data[grep(us.states[iState],unlist(fam.data[,1])),]);
  colnames(temp.stor) <- temp.stor[1,]
  temp.stor <-(temp.stor[2:length(temp.stor[,1]),]);
  class(temp.stor) = "numeric";
  write.table(temp.stor,paste0("tidy/family.county.by.income/",
                             us.states[iState],
                             ".family.county.by.income.csv"),
            row.names = FALSE,
            #col.names = FALSE,
            sep = ",");
};
