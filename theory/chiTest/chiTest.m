function [ Chi, pVal, nObs, O, E, bins ] = chiTest( X, F, nBin, SUPMSG, waitCB)
%   chiTest::Multivariate Chi-Test
%   @(param)   X       Matrix;   multivariate dataset     (required)
%   @(param)   F       Function; multivariate ddf/cdf     (required)
%   @(param)   nBin    Number;   Number of bins           (optional, defaults to 50)
%   @(param)   SUPMSG  Bolean;   suppress any messages    (optional)
%   @(return)  Chi     Number;   chi-square-test score    
%   @(return)  pVal    Numbar;   P-value
%   @(return)  nObs    Number;   number of observations
%   @(return)  O       Matrix;   Observed values
%   @(return)  E       Matrix;   Estimated values
%   @(return)  bins    Structure;bins values
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
    nBin    = exp(log(2^64)/nVar^2);
    nBin    = max([floor(nBin) 10]);
    fprintf('Defaulting to %d bins\n', nBin);
end
maxX    = max(X);
minX    = min(X);minX = minX - 1e-10;
bDim    = (maxX-minX)/nBin;
    if(exist('waitCB','var')); waitCB(1/6); end;
%2 Create intervals
bIntv   = zeros(nBin+1,nVar);
for i=1:nVar
    bIntv(:,i) = (minX(i):bDim(i):maxX(i));
end
    if(exist('waitCB','var')); waitCB(2/6); end;
%3 Set Containers
try
    O        = zeros(nBin^nVar,1);
    E        = zeros(nBin^nVar,1);
    bins     = cell(nBin^nVar,1);
catch
    [~, maxSize] = computer;
    error('Not enough memory to create containers. Size of %d^%d=%s is too big. Max Size is %s',...
        nBin,nVar,nBin^nVar,maxSize);
end
    if(exist('waitCB','var')); waitCB(3/6); end;
%4 Get all needed combinations
cmb = combos(1:nBin,nVar);
    if(exist('waitCB','var')); waitCB(4/6); end;

% Warning of size
WARN(length(cmb)^nVar,2^32);

% Difference Function
function [ tot ] = DDn( a , b )
    ab = [a; b];
    n = size(ab,2);
    WARN(n, 20, 'Current Var: %s, Usage of RAM might max-out when running the function on more than %s');
    cmbs = (dec2bin(0:2^n-1)=='1')'+1;
    keven = mod(sum(cmbs == 1),2) == 0;

    sgn = keven-~keven;

    tot = (cmbs==2).*repmat(ab(2,:)',1,size(cmbs,2)) +(cmbs==1).*repmat(ab(1,:)',1,size(cmbs,2));
    
    tot = sgn*F(tot);
end

%5 Computation loop
for iBin = 1:length(cmb)
    iComb   = cmb(:,iBin);
    bin     = zeros(2,nVar);
    for iVar = 1:nVar
        bin(1, iVar) = bIntv(iComb(iVar),iVar);
        bin(2, iVar) = bIntv(iComb(iVar)+1,iVar);
    end
    bins{iBin} = bin;
    O(iBin) = sum(sum(repmat(bin(1,:),nObs,1) < X & repmat(bin(2,:),nObs,1) >= X,2)==nVar)/nObs;
    minx = bin(1,:);maxx = bin(2,:);
    n = size(bin,2);
    E(iBin) = abs(DDn(minx,maxx));
        % if(exist('waitCB','var')); waitCB((4 + iBin./length(cmb))/6); end;
end
if(exist('waitCB','var')); waitCB(5/6); end;

%6 Compute Results
Chi = sum(sum(((O - E).^2)./E));
pVal = chi2cdf(Chi,nObs-1);
if(~SUPMSG)
    disp('----] Chi2-Fit Test Results [----');
    fprintf('-> Number of Bins: %d\n-> Chi Score: %2.3f\n-> P-Value: %1.6f\n-> Degrees of Freedom: %d\n\n',...
        nBin, Chi, pVal, nObs-1);
end

if(exist('waitCB','var')); waitCB(6/6); end;
end

