clear
clc

addpath('./Fmp2');
addpath('./chiTest');

% Main Param
state = 'Alaska';
ind.X1 = 2;
ind.X2 = 3;
alpha = 0.05;
nBins = 30;

% Load State Data
dataFolder = '../data/tidy/ACS_13_5YR_DP03/county.by.income';

data = csvread(strcat(dataFolder,'/',state,'.noanno.csv'));

% Test Individual Data
clc
pVals = zeros(size(data,1),1);
chi2Scores = zeros(1,size(data,1));
Xtemp = zeros(size(data))';
for varId = 1:size(data,1)
	Xtemp(:,varId) = (flipud(log(data(varId,:))))';
	% Estimate
    [ mu, s, a, a0, aj0, a0s ] = Fmp2MMEst( Xtemp(:,varId), 'Kendall' );
	
    % Test
    [ Chi.(strcat('X',num2str(varId))),...
	  pVal.(strcat('X',num2str(varId))),...
	  nObs ...
	] = chiTest( (Xtemp(:,varId)-mu)./s,Fmp2( a0, a ),nBins,false);
    pVals(varId) = pVal.(strcat('X',num2str(varId)));
    chi2Scores(varId) = Chi.(strcat('X',num2str(varId)));
end
Test.IND = (pVal.X1 < alpha) & (pVal.X2 < alpha);
%%
clc
disp('|---- Independent Test Results ----|');
fprintf('-> X%d:\n | p-Value: %s\n | chi^2-Score: %3.2f\n----\n', [1:length(pVals); pVals'; chi2Scores] );
fprintf('\n-> Degress of Freedom: %3.2f\n-> Number of Bins: %3.2f\n', nObs-1, nBins);
if(Test.IND)
	fprintf('-> All variables passed at the %2.2f%% level!\n', 100*alpha);
else
	fprintf('-> Not every variable passed the %2.2f%% level!\n', 100*alpha);
end
fprintf('\n|---- Independent Test Results ----|\n\n');
%%
clc
% Find Proper Data
cTemp = corr(Xtemp, 'type', 'Kendall');
ind = find(cTemp==(max(cTemp(cTemp<1))));
[m,n] = ind2sub(size(cTemp),ind(1));
fprintf('Using X%d and X%d\n',m,n);

% Test Joint Data
X = Xtemp(:,[m n]);

[ est.X.mu, est.X.s, est.X.a, est.X.a0, est.X.aj0, est.X.a0s, p ] = Fmp2MMEst( X, 'Kendall' );

[ Chi.X, pVal.X, nObs ] = chiTest( X, Fmp2( est.X.a0, est.X.a, est.X.s, est.X.mu ));
%%
clc
fprintf('|---- X%d vs X%d Test Results ----|\n\n', m, n);
fprintf('-> p-Value: %s\n-> chi^2-Score: %3.2f\n', pVal.X, Chi.X );
fprintf('-> Degress of Freedom: %3.2f\n-> Number of Bins: %3.2f\n\n', nObs-1, nBins);
if(pVal.X < alpha)
	fprintf('-> Passed at the %2.2f%% level!\n', 100*alpha);
else
	fprintf('-> Did not pass the %2.2f%% level!\n', 100*alpha);
end
fprintf('\n|---- X%d vs X%d Test Results ----|\n\n', m, n);
