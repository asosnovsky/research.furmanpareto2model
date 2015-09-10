clear
clc

addpath('./Fmp2');
addpath('./Amp2');
addpath('./p2');
addpath('./chiTest');
addpath('./simulation');

data = csvread('../data/tidy/ACS_13_5YR_DP03/county.by.income/Texas.noanno.csv');

X = data([5 6],:)';
X = log(X+10);
nBin = 75;% Test Calibration

[ est.mu, est.s, est.a, est.a0, ~, est.a0s, tau ] = Fmp2MMEst( X );
[Chi pVal] = chiTest(X, Fmp2(est.a0,est.a,est.s,est.mu), nBin );
disp(tau);
[ est.a, est.mu ] = Amp2MLEst(X);est.s = [1 1];
[ Chi, pVal, ~ ] = chiTest( X, Amp2( est.a, est.s, est.mu ), nBin );
