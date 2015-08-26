%% Load Data and set Global Param
clear
clc

addpath('./Fmp2');
addpath('./chiTest');

% Main Param
state = 'Indiana';
alpha = 0.05;
DT = @(x) log(x+10);

% Load State Data
dataFolder = '../data/tidy/ACS_13_5YR_DP03/county.by.income';

data = csvread(strcat(dataFolder,'/',state,'.noanno.csv'));

% Test Individual Data
pVals = zeros(size(data,1),1);
chi2Scores = zeros(size(data,1),1);
Xtemp = zeros(size(data));

for(iState = 1:size(data,2))
    fprintf('    [ Test X%d ]\n',iState);
	Xtemp(:,iState) = DT(data(:,iState));
	[mu, s, a, a0] = Fmp2MMEst(Xtemp(:,iState),'Kendall');
	[ Chi, pVals(iState), nObs, nBin] = chiTest( (Xtemp(:,iState)-mu)./s, Fmp2( a , a0 ));
end

mean(pVals)
sum(pVals < alpha)
size(data,2)