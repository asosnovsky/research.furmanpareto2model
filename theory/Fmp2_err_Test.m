clear
clc

addpath('./Fmp2');
addpath('./Amp2');
addpath('./p2');
addpath('./simulation');
addpath('./chiTest');

% Params
num     = 700;
a0 	    = 2;
a 	    = [2 2];
s 	    = [1 1];
mu	    = [0 0];
nBin    = 100;
simNum  = 250;

% Containers
MF.pVal     = [];
MF.Chi      = [];
MF.Params   = struct('a0',[],'a',[],'s',[],'mu',[]);

MI.pVal     = [];
MI.Chi      = [];
MI.Params   = struct('a',[],'s',[],'mu',[]);

MA.pVal     = [];
MA.Chi      = [];
MA.Params   = struct('a',[],'s',[],'mu',[]);

corrM   = [];

% Messages Function
MSGs = @(iN,N,iSim,MF,MI,MA) fprintf(...
        '%2.3f%% Complete (%3.1f/%3.1f) \n MF:\n > mean( pVal:%1.3f, Chi:%3.2f )\n > suc:%2.3f%%\n MI:\n > mean( pVal:%1.3f, Chi:%3.2f )\n > suc:%2.3f%%\n MA:\n > mean( pVal:%1.3f, Chi:%3.2f )\n > suc:%2.3f%%\n\n',...
        100*(iN/N+iSim-1)/simNum, iSim + 0.1*iN, simNum+0.1*N,...
        mean(MF.pVal),mean(MF.Chi),100*sum(MF.pVal<0.05)/iSim,...);
        mean(MI.pVal),mean(MI.Chi),100*sum(MI.pVal<0.05)/(iSim - (iN < 2)),...);
        mean(MA.pVal),mean(MA.Chi),100*sum(MA.pVal<0.05)/(iSim - (iN < 3)));

for(iSim = 1:simNum)
    X = Fmp2sim(num, a0, a, s, mu);
    
    % Furman
    [ est.mu, est.s, est.a, est.a0, ~, est.a0s, tau ] = Fmp2MMEst( X );
    [Chi pVal] = chiTest(X, Fmp2(est.a0,est.a,est.s,est.mu), nBin );
        MF.pVal = [MF.pVal pVal];
        MF.Chi  = [MF.Chi Chi];
        corrM   = [corrM tau];
        MF.Params.a = [MF.Params.a; est.a];
        MF.Params.a0 = [MF.Params.a0; est.a0];
        MF.Params.s = [MF.Params.s; est.s];
        MF.Params.mu = [MF.Params.mu; est.mu];

    MSGs(1,3,iSim,MF,MI,MA)

    % Independent
    % [ est.mu, est.s, est.a ] = p2MLEst(X);
    % [ Chi, pVal, ~ ] = chiTest( X, p2ddf( est.a, est.s, est.mu ), nBin );
    %     MI.pVal = [MI.pVal pVal];
    %     MI.Chi  = [MI.Chi Chi];
    %     MI.Params.a = [MI.Params.a; est.a];
    %     MI.Params.s = [MI.Params.s; est.s];
    %     MI.Params.mu = [MI.Params.mu; est.mu];

    % MSGs(2,3,iSim,MF,MI,MA)
    
    % Arnold
    %[ est.a, est.mu ] = Amp2MLEst(X);est.s = [1 1];
    pA = corr(X);
    [ Chi, pVal, ~ ] = chiTest( X, Amp2( 1/pA(1,2), [1 1], [0,0] ), nBin );
        MA.pVal = [MA.pVal pVal];
        MA.Chi  = [MA.Chi Chi];
        MA.Params.a = [MA.Params.a; est.a];
        MA.Params.s = [MA.Params.s; est.s];
        MA.Params.mu = [MA.Params.mu; est.mu];
        
    MSGs(3,3,iSim,MF,MI,MA)
        
end
    MA.Params.est = struct('a', mean(MA.Params.a), 's',mean(MA.Params.s), 'mu', mean(MA.Params.mu));
    MI.Params.est = struct('a', mean(MI.Params.a), 's',mean(MI.Params.s), 'mu',mean(MI.Params.mu));
    MF.Params.est = struct('a0', mean(MF.Params.a0),'a', mean(MF.Params.a), 's',mean(MF.Params.s), 'mu', mean(MF.Params.mu));
%%
    clc
    disp('---------------[Data]---------------');
    disp('Correlation Matrix');disp(corrM);
    disp('Real Parameters:');disp(struct('a0',a0,'a',a,'s',s,'mu',mu));
    fprintf('Number of Observations: %dx%d\n\n', size(a,2), num);

    disp('--------------[Models]--------------');
    MMSG = @(title,MM) fprintf('%s\n - Model:\n    mean(pVal): %1.4f\n    mean(Chi): %3.2f\n - Correctness\n    Pr(pVal < 5%%): %3.2f%%\n',...
        title, mean(MM.pVal), mean(MM.Chi), 100*sum(MM.pVal < 0.05)/iSim);

    MMSG('Furman Pareto', MF);
    disp(' - Parameters');
    disp(MF.Params.est);

    MMSG('Independent Pareto', MI);
    disp(' - Parameters');
    disp(MI.Params.est);
    
    MMSG('Arnold Pareto', MA);
    disp(' - Parameters');
    disp(MA.Params.est);
%%
clear k
clc
k = MF.pVal < 0.05;
mean(MF.Chi(k))
mean(MA.Chi(k))

k = (MF.Chi < MA.Chi);
mean((MA.Chi(k) - MF.Chi(k))./MF.Chi(k))

