clear
clc

addpath('./Fmp2');
addpath('./simulation');
addpath('./chiTest');


num = 1000;
a0 	= 10;
a 	= [2 2 3 4];
s 	= [10 10 5 1];
mu	= [400 20 10 2]; 

X = Fmp2sim(num, a0, a, s, mu);

[ est.mu, est.s, est.a, est.a0, est.aj0, p ] = Fmp2MMEst( X, 'Kendall' );

[ Chi, pVal, nObs, O, E, bins ] = chiTest( X, Fmp2( est.a0, est.a, est.s, est.mu ), false, false,...
    @(x) fprintf('Procces: %s\n', strtrim(rats(x))));
