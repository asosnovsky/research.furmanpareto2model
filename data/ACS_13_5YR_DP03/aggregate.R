
aggData <- function(origFolder, tidyFolder, nVar) {
  # Get US States
  us.states <- unlist(read.csv(file.path(origFolder,"wiki/us.states.csv"))["State"]);
  data.main <- list();
  # Loop
  for(state in us.states){
    ## Load Data
    data.income <- t(read.csv(paste0(tidyFolder,'/county.by.income/',state,'.csv')));
    data.tot <- read.csv(paste0(tidyFolder,'/county.totals/',state,'.csv'));
    
    ## Ordered data
    ord.data <- data.income[order(data.tot[,4]),];
    
    ## Aggragate Data
    incs <- c(0,floor((1:nVar)*length(ord.data[,1])/nVar));
    data.agg <- matrix(,nrow=nVar,ncol=length(ord.data[1,]));
    rnames <- c();
    for(iVar in 1:nVar+1) {
      tt <- ord.data[(incs[iVar - 1] + 1):incs[iVar],];
      if(length(tt) != length(ord.data[1,])) {
        data.agg[iVar-1,] <- apply(tt,2,sum);
        rnames[iVar-1] <- paste0('Q',iVar-1);
      } else {
        data.agg <- ord.data;
        rnames <- row.names(ord.data);
      }
    }
    
    ## Save
    rownames(data.agg) <- rnames
    colnames(data.agg) <- colnames(data.income);
    write.table(t(data.agg),paste0(tidyFolder,"/aggregate/",
                                   state,
                                   ".anno.csv"),sep = ",");
    
    write.table(t(data.agg),paste0(tidyFolder,"/aggregate/",
                                   state,
                                   ".noanno.csv"),
                row.names = FALSE,col.names = FALSE,sep = ",");
    data.main[[state]] <- data.agg;
  };
  return(data.main);
}