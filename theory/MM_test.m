clear
clc

addpath('./Fmp2');
addpath('./simulation');
addpath('./chiTest');


num = 300;
a0 	= 2;
a 	= [2 2];
s 	= [1 1];
mu	= [0 0]; 

ps = [];
for(iSim = 1:100)
    X = Fmp2sim(num, a0, a, s, mu);
    [ est.mu, est.s, est.a, est.a0, ~, est.a0s, p ] = Fmp2MMEst( X );
    [chi p] = chiTest(X, Fmp2(est.a0,est.a,est.s,est.mu),100);
    ps = [ps p];

    disp(iSim);
    disp(sum(ps<0.05)/iSim);
end
