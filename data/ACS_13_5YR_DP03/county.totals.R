countTot <- function(origFolder, tidyFolder) {
  # Load Data
  fam.data <- read.csv(file.path(tidyFolder,"family/totals.anno.csv"));
  us.states <- unlist(read.csv(file.path(origFolder,"wiki/us.states.csv"))["State"]);
  mean.id <- grep('Mean',names(fam.data));

  Sys.setlocale('LC_ALL','C');
  for(state in unlist(us.states)) {
    mean.data <- fam.data[grep(state,unlist(fam.data[,1])),];
    rnames <- mean.data[,1];
    temp.stor <-mean.data[,mean.id];
    class(temp.stor) = "numeric";
    mean.data <- data.frame(mean.data,row.names = sub(paste0(' County, ', state), '',rnames))
    write.table(mean.data,paste0(tidyFolder,"/county.totals/",
                                 state,
                                 ".csv"),
                row.names = TRUE,
                sep = ",");
  };
}