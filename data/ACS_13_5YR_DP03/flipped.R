flipData <- function(){
  data.flip <<- list();
  for(state in sub('.csv',"",dir(paste0(tidyFolder,"/county.by.income")))) {
    data.income <- t(read.csv(paste0(tidyFolder,'/county.by.income/',state,'.csv')));
    data.income.flipped <- data.income[,length(data.income[1,])-(1:length(data.income[1,]))+1];
    data.flip[[state]] <<- data.income.flipped;
    
    write.table(data.income.flipped,paste0(tidyFolder,"/county.by.income.flipped/",
                                   state,
                                   ".anno.csv"),sep = ",");
    
    write.table(data.income.flipped,paste0(tidyFolder,"/county.by.income.flipped/",
                                   state,
                                   ".noanno.csv"),
                row.names = FALSE,col.names = FALSE,sep = ",");
  }
}