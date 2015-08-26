# Main data source: ACS_13_5YR_DP03.zip
rm(list=ls());

# Working Dir
homeDir = "~/Projects/York/Research/data";#linux
setwd(homeDir);

# Create Tidy-folder if not already there
dir.create(file.path(homeDir,"tidy/"), showWarnings = F);

# Reset Main Folders
tidyFolder = file.path(homeDir, 'tidy/ACS_13_5YR_DP03');
origFolder = file.path(homeDir, 'original/ACS_13_5YR_DP03');

## Clean
unlink(tidyFolder, r = T, f = T);
unlink(origFolder, r = T, f = T);

## Make
dir.create(tidyFolder, showWarnings = T);
unzip(file.path(homeDir,'ACS_13_5YR_DP03/ACS_13_5YR_DP03.zip'),exdir=origFolder);

### Make Family/House Data
dir.create(file.path(tidyFolder,'family'), showWarnings = FALSE);
dir.create(file.path(tidyFolder,'house'), showWarnings = FALSE);

source(file.path(homeDir,'ACS_13_5YR_DP03','home.family.R'));
famHouse(origFolder,tidyFolder);

### Make family county by income data
dir.create(file.path(tidyFolder,'county.by.income'), showWarnings = FALSE);

source(file.path(homeDir,'ACS_13_5YR_DP03','county.by.income.R'));
data.all <- countIncome(file.path(homeDir,'original'), tidyFolder);

### Make family county by totals data
dir.create(file.path(tidyFolder,'county.totals'), showWarnings = FALSE);

source(file.path(homeDir,'ACS_13_5YR_DP03','county.totals.R'));
countTot(file.path(homeDir,'original'), tidyFolder);

### Flipped data
dir.create(file.path(tidyFolder,'county.by.income.flipped'), showWarnings = FALSE);

source(file.path(homeDir,'ACS_13_5YR_DP03','flipped.R'));
flipData();

### Make Aggregate Data
dir.create(file.path(tidyFolder,'aggregate'), showWarnings = FALSE);
source(file.path(homeDir,'ACS_13_5YR_DP03','aggregate.R'));
data.aggs <- aggData(file.path(homeDir,'original'), tidyFolder,4);


for(state in names(data.aggs)) {
  barplot((data.aggs[[state]]), main=state, legend.text = colnames(data.aggs[[state]]));
}

for(state in names(data.aggs)) {
  barplot(t(data.all[[state]]), main=state 
          #,legend.text = colnames(data.all[[state]])
          );
}
