function []= printMyResults( sim, nTest, nObs, a0, a, s, mu, chiLevel )
clc
fprintf('Averaged Values (%d simulations): \n',nTest);
fprintf('----------------------------------\n');
fprintf('> Name  | Estimated Values | Real Values |\n');
fprintf('> --------------------------------------- \n');
fprintf('> alpha0  %2.2f              %2.2f        \n', mean(sim.a0),a0);
fprintf('> alpha%d  %2.2f              %2.2f       \n', [1:length(a); mean(sim.a); a]);
fprintf('> mu%d     %2.2f              %2.2f       \n', [1:length(mu); mean(sim.mu); mu]);
fprintf('> s%d      %2.2f              %2.2f       \n', [1:length(s); mean(sim.s); s]);
fprintf('> --------------------------------------- \n');
fprintf('> Error Rate: \n   |Min=%2.2f%%,\n   |Median=%2.2f%%,\n   |Avg=%d%%,\n   |Max=%d%%\n',...
    min(chi2cdf(sim.chi,nObs-1))*100,...
    median(chi2cdf(sim.chi,nObs-1))*100,...
    mean(chi2cdf(sim.chi,nObs-1))*100,...
    max(chi2cdf(sim.chi,nObs-1))*100);
fprintf('> Chi-Score: \n   |Min=%2.2f,\n   |Median=%2.2f,\n   |Avg=%d,\n   |Max=%d  \n> Degrees of freedom: %d\n',...
    min(sim.chi),median(sim.chi),mean(sim.chi),max(sim.chi), nObs-1);
fprintf('> # of Times Passed Chi-Test: %d/%d\n',sum(sim.chi < chi2inv(chiLevel,nObs-1)),nTest);
end