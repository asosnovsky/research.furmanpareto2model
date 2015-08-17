getPartial <- function(...) {
  data <- read.csv(paste0(tidyPath,'full/',...,'.anno.csv'));
  top4 <- data[,order(colSums(data == 0))[1:4]];
  
  write.table(top4,paste0(tidyPath,"partial/",...,".noanno.csv"),
              row.names = FALSE,col.names = FALSE,sep = ",");
  
  write.table(top4,paste0(tidyPath,"partial/",...,".anno.csv"),
              sep = ",");
  return(top4);
}