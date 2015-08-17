analyzeANDSave <- function(data, m, ...)	{
  data.split <- split(data,data$Type);
  data.agg <- data.frame(matrix(NA,ncol=1));
  colnames(data.agg) <- "Year";
  for(t in data.split) {
    tmp <- (aggregate(t[c("OriginalCost")],list(t$Year),mean));
    colnames(tmp) <- c("Year", as.character(t$Type[[1]]));
    data.agg <- merge(data.agg, tmp, all=T);
  }
  data.agg[is.na(data.agg)] <- 0
  
  maxY = max(data$Year);
  minY = min(data$Year);
  
  n = ceiling((maxY-minY)/m);
  data.aggs <- matrix(NA,ncol=length(data.agg)-1,nrow=m);
  incs <- (0:m)*n+minY;
  
  for(iDate in 2:length(incs)) {
    cond <- (data.agg$Year < incs[iDate] & data.agg$Year >= incs[iDate-1])
    data.aggs[iDate - 1,] <- colSums(data.agg[cond,-1])
  }
  
  data.aggs <- data.frame(data.aggs);
  colnames(data.aggs) <- colnames(data.agg)[-1];
  rownames(data.aggs) <- paste0('[',(1:m-1)*n+minY,'-',(1:m)*n+minY,')');
  
  write.table(data.aggs,paste0(tidyPath,"/full/",...,".noanno.csv"),
              row.names = FALSE,col.names = FALSE,sep = ",");
  
  write.table(data.aggs,paste0(tidyPath,"/full/",...,".anno.csv"),
              sep = ",");
}

# Load Data
load(paste0(origPath, "auscathist.rda"));
load(paste0(origPath, "nzcathist.rda"));
