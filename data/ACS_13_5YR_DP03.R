# Working Dir
setwd("C:/Box/Research/data");# My home dir

# Read data
data <- read.csv("C:/Box/Research/data/original/ACS_13_5YR_DP03/ACS_13_5YR_DP03_with_ann.csv");

# Extract partials
data.estimates <- data[grepl("Estimate",unlist(data[1,]))];
data.income <- data.estimates[grepl("INCOME AND BENEFITS",unlist(data.estimates[1,]))];

# Family
data.income.family <- data.income[grep("Families",unlist(data.income[1,]))];
## Get desired data
family <- list(
  by.group=data.frame(data.income.family[grep("to|or|Less",unlist(data.income.family[1,]))][-1,]
    ,row.names=data$GEO.display.label[-1]
  ),
  totals=data.frame(data.income.family[!grepl("to|or|Less",unlist(data.income.family[1,]))][-1,]
    ,row.names=data$GEO.display.label[-1]
  )
)
## Set collumns
colnames(family$by.group) <- sub("^.*?Families - ","",unlist(data.income.family[1,grep("to|or|Less",unlist(data.income.family[1,]))]),perl=T);
colnames(family$totals) <- sub("^.*?Families - ","",unlist(data.income.family[1,!grepl("to|or|Less",unlist(data.income.family[1,]))]),perl=T);

## Write tables
write.table(family$by.group,file="./tidy/family.bygroup.noanno.csv", row.names=FALSE, col.names=FALSE, sep=",");
write.table(family$totals,file="./tidy/family.totals.noanno.csv", row.names=FALSE, col.names=FALSE, sep=",");
write.csv(family$by.group,file="./tidy/family.bygroup.anno.csv");
write.csv(family$totals,file="./tidy/family.totals.anno.csv");

# Household
data.income.house <- data.income[grep("Total [Hh]ousehold",unlist(data.income[1,]))];
## Get wanted data
house <- list(
  by.group=data.frame(data.income.house[grep("to|or|Less",unlist(data.income.house[1,]))][-1,]
                      ,row.names=data$GEO.display.label[-1]
  ),
  totals=data.frame(data.income.house[!grepl("to|or|Less",unlist(data.income.house[1,]))][-1,]
                    ,row.names=data$GEO.display.label[-1]
  )
)
## Collumns
colnames(house$by.group) <- sub("^.*?Families - ","",unlist(data.income.house[1,grep("to|or|Less",unlist(data.income.family[1,]))]),perl=T);
colnames(house$totals) <- sub("^.*?Families - ","",unlist(data.income.house[1,!grepl("to|or|Less",unlist(data.income.family[1,]))]),perl=T);

## Write tables
write.table(family$by.group,file="./tidy/house.bygroup.noanno.csv", row.names=FALSE, col.names=FALSE, sep=",");
write.table(family$totals,file="./tidy/house.totals.noanno.csv", row.names=FALSE, col.names=FALSE, sep=",");
write.csv(family$by.group,file="./tidy/house.bygroup.anno.csv");
write.csv(family$totals,file="./tidy/house.totals.anno.csv");
