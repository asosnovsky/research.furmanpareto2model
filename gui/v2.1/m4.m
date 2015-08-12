%% General Method Check
clear
clc
% Simulation
a0      = 1;
a       = [2 3 4];
mu      = [0 0 10];
s       = [2 1 2];
nObs    = 120;
nTest   = 100;
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

%%
clc
fprintf('Average Error level at |%d%% | \n',chi2cdf(cnt/nTest,nObs-1)*100);
fprintf('Average Chi Score: |%d|, for |%d degrees of freedom| \n',cnt/nTest,nObs-1);
fprintf('Passed |%d| out of %d times.\n',pass,nTest);

%% Methods of Moments Check
clear
clc
% Simulation
a0      = 1;
a       = [2 3 4];
mu      = [0 0 10];
s       = [2 1 2];
nObs    = 60;
nTest   = 100;
sim     = struct(...
    'a0',zeros( nTest, 1),...
    'a',zeros( nTest, length(a)),...
    'mu',zeros( nTest, length(mu)),...
    's',zeros( nTest, length(s)),...
    'chi',zeros( nTest, 1)...
);
% Test
for iTest=1:nTest
    X   = simulate(nObs, a0, a, s, mu);
    fprintf('Test: %d/%d (observations: %d)\n', iTest, nTest, nObs);
    ana             = paretoAnalysis(X,1);
    sim.a0(iTest)   = ana{1};
    sim.a(iTest,:)  = cell2mat(ana(2,:));
    sim.mu(iTest,:) = cell2mat(ana(3,:));
    sim.s(iTest,:)  = cell2mat(ana(4,:));
    F               = Fmulpareto2(sim.a0(iTest), sim.a(iTest,:), sim.s(iTest, :), sim.mu(iTest,:));
    sim.chi(iTest)  = chiTest(X, F);
end
printMyResults( sim, nTest, nObs, a0, a, s, mu, 0.99 )
%%
clear
clc

a0      = 1;
a       = [2 3 4];
mu      = [0 0 10];
s       = [2 1 2];
nObs    = 120;
X   = simulate(nObs, a0, a, s, mu);
ana     = paretoAnalysis(X,1);
ea0     = ana{1};
ea      = cell2mat(ana(2,:));
emu     = cell2mat(ana(3,:));
es      = cell2mat(ana(4,:));
F = Fmulpareto2(ea0, ea, es, emu);
disp(ana);
disp(chiTest(X,F));