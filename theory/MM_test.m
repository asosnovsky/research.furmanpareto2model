clear
clc

addpath('./Fmp2');
addpath('./simulation');
addpath('./chiTest');


num = 1000;
a0 	= 10;
a 	= [2];
s 	= [10];
mu	= [400]; 

X = Fmp2sim(num, a0, a, s, mu);
[ est.mu, est.s, est.a, est.a0, est.aj0, est.a0s, p ] = Fmp2MMEst( X, 'Kendall' );
est
%%
clc
%t0=now;
[ Chi, pVal, nObs ] = chiTest( X, Fmp2( est.a0, est.a, est.s, est.mu ), 250, false,...
    @(x) fprintf('Procces: %s\n', strtrim(rats(x))));
%disp(now-t0);
