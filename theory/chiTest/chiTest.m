function [ Chi, pVal, nObs, nBin] = chiTest( X, F, nBin, SUPMSG, waitCB)
%   chiTest::Multivariate Chi2-Test goodness of fit test
%   @(param)   X       Matrix;   multivariate dataset     (required)
%   @(param)   F       Function; multivariate ddf/cdf     (required)
%   @(param)   nBin    Number;   Number of bins           (optional, defaults to 50)
%   @(param)   SUPMSG  Bolean;   suppress any messages    (optional)
%   @(return)  Chi     Number;   chi-square-test score    
%   @(return)  pVal    Numbar;   P-value
%   @(return)  nObs    Number;   number of observations
%
%   Tip: to speed the process of analysis try disabling warning and tests.

% Helper Warning function
if(~exist('SUPMSG','var'))
    SUPMSG = false;
end

function[] = WARN(m,mx,msg)
    if(~exist('msg','var'))
        msg = 'Running a process of size %c, may take some time. \nSuggested process size should be less than %c% for good performance,\nReducing the `bin` size or `number of variables` may increase speed.';
    end
    if(m >= mx && ~SUPMSG)
        warning(msg,...
        m, mx);
    end
end

%1 Get data
nObs    = size(X,1);
nVar    = size(X,2);
if(~exist('nBin') | ~nBin)
    nBin    = floor(nObs/2);
end
nBin    = max([nBin 2]);
    fprintf('[chiTest Alert] Using %d bins\n', nBin);
maxX    = max(X);
minX    = min(X) - 1e-10;
bDim    = (maxX-minX)/nBin;
    if(exist('waitCB','var')); waitCB(1/6); end;

%2 Create intervals
bIntv   = zeros(nBin+1,nVar);
for i=1:nVar
    bIntv(:,i) = (minX(i):bDim(i):maxX(i));
end
    if(exist('waitCB','var')); waitCB(2/6); end;

%3 Get all needed combinations
cmb = combos(1:nBin,nVar);
    if(exist('waitCB','var')); waitCB(3/6); end;

% Warning of size
WARN(nVar, 20, 'Current Var: %s, Usage of RAM might max-out when running the function on more than %s');

%4 Define helper-variables
if(nVar > 1)
    cmbs = (dec2bin(0:2^nVar-1)=='1')'+1;
    sgn = mod(sum(cmbs == 1),2) == 0;
    sgn = sgn-~sgn;
else
    cmbs    = [1 2];
    sgn     = [-1 1];
end
Chi = 0; 
    if(exist('waitCB','var')); waitCB(4/6); end;

%5 Computation loop
for iBin = 1:length(cmb)
    iComb   = cmb(:,iBin);
    bin     = zeros(2,nVar);
    for iVar = 1:nVar
        bin(1, iVar) = bIntv(iComb(iVar),iVar);
        bin(2, iVar) = bIntv(iComb(iVar)+1,iVar);
    end
    O = sum(sum(repmat(bin(1,:),nObs,1) < X & repmat(bin(2,:),nObs,1) >= X,2)==nVar)/nObs;
    E = (cmbs==2).*repmat(bin(2,:)',1,size(cmbs,2)) +(cmbs==1).*repmat(bin(1,:)',1,size(cmbs,2));
    E = abs(sgn*F(E));
        % if(exist('waitCB','var')); waitCB((4 + iBin./length(cmb))/6); end;
    Chi = Chi + ((O - E).^2)./E;
    if(exist('waitCB','var')); waitCB(4/6 + (iBin/length(cmb))/6); end;
end
    if(exist('waitCB','var')); waitCB(5/6); end;
%6 Compute Results
pVal = chi2cdf(Chi,nObs-1);
if(~SUPMSG)
    fprintf('\n----] Chi2-Fit Test Results [----\n');
    fprintf('-> Number of Bins: %d\n', nBin);
    fprintf('-> Chi2-Score: %2.3f\n', Chi );
    fprintf('-> p-Value: %1.6f\n', pVal );
    fprintf('-> Degrees of Freedom: %d\n', nObs-1  );
    %fprintf('-> Number of Bins: %d\n-> Chi Score: %2.3f\n-> P-Value: %1.6f\n-> Degrees of Freedom: %d\n\n',...
       % nBin, Chi, pVal, nObs-1);
    fprintf('----] Chi2-Fit Test Results [----\n\n');

end
if(exist('waitCB','var')); waitCB(6/6); end;
end

