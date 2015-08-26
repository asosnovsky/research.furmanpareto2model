countIncome <- function(origFolder, tidyFolder) {
  # Load Data
  fam.data <- read.csv(file.path(tidyFolder,"family/bygroup.anno.csv"));
  us.states <- unlist(read.csv(file.path(origFolder,"wiki/us.states.csv"))["State"]);
  data.all <- list();
  for(state in us.states) {
    temp.stor <- t(fam.data[grep(state,unlist(fam.data[,1])),]);
    colnames(temp.stor) <- sub(paste0(' County, ', state), '',temp.stor[1,]);
    temp.stor <-(temp.stor[2:length(temp.stor[,1]),]);
    rownames(temp.stor) <- sub('X.','',sub('.or.more','<',sub('Less.than..','<',sub('.to..','-',rownames(temp.stor)))));
    class(temp.stor) = "numeric";
    write.table(temp.stor,paste0(tidyFolder,"/county.by.income/",
                                 state,
                                 ".csv"),sep = ",");
    write.table(temp.stor,paste0(tidyFolder,"/county.by.income/",
                                 state,
                                 ".noanno.csv"),
                row.names = FALSE,col.names = FALSE,sep = ",");
    data.all[[state]] <- temp.stor;
    };
  return(data.all);
}