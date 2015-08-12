%% General Method Check
% This is a test to see that the chiTest works for the trivariate case
% Simply running this sheet will run the test
clear
clc
% Simulation
a0      = 1;
a       = [2 3 4];
mu      = [0 0 10];
s       = [2 1 2];
nObs    = 120;
nTest   = 10;
chiLevel=0.99;
F = Fmulpareto2(a0, a, s, mu);
sim = struct('chi',zeros( nTest, 1));
for iTest=1:nTest
    X   = simulate(nObs, a0, a, s, mu);
    fprintf('Test: %d/%d (observations: %d)\n',iTest,nTest,nObs);
    sim.chi(iTest)  = chiTest(X, F);
end

clc
fprintf('> Error Rate: \n   |Min=%2.2f%%,\n   |Median=%2.2f%%,\n   |Avg=%d%%,\n   |Max=%d%%\n',...
    min(chi2cdf(sim.chi,nObs-1))*100,...
    median(chi2cdf(sim.chi,nObs-1))*100,...
    mean(chi2cdf(sim.chi,nObs-1))*100,...
    max(chi2cdf(sim.chi,nObs-1))*100);
fprintf('> Chi-Score: \n   |Min=%2.2f,\n   |Median=%2.2f,\n   |Avg=%d,\n   |Max=%d  \n> Degrees of freedom: %d\n',...
    min(sim.chi),median(sim.chi),mean(sim.chi),max(sim.chi), nObs-1);
fprintf('> # of Times Passed Chi-Test: %d/%d\n',sum(sim.chi < chi2inv(chiLevel,nObs-1)),nTest);
