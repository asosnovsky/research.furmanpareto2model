function [ Chi, Res, nObs, O, E, bins ] = chiTest( X, F, nBin, SUPWARN, SUPTEST, waitCB)
%   chiTest::Multivariate Chi-Test
%   @(param)   X       Matrix;   multivariate dataset     (required)
%   @(param)   F       Function; multivariate ddf/cdf     (required)
%   @(param)   nBin    Number;   Number of bins           (optional, defaults t0 10)
%   @(param)   SUPWARN Bolean;   suppress any messages    (optional)
%   @(param)   SUPTEST Bolean;   suppress tests           (optional)
%   @(return)  Chi     Number;   chi-square-test score    
%   @(return)  Res     Bolean;   results of test
%   @(return)  nObs    Number;   number of observations
%   @(return)  O       Matrix;   Observed values
%   @(return)  E       Matrix;   Estimated values
%   @(return)  bins    Structure;bins values
%
%   Tip: to speed the process of analysis try disabling warning and tests.

% Helper Warning function
if(~exist('SUPTEST','var'))
    SUPTEST = false;
end
if(~exist('SUPWARN','var'))
    SUPWARN = false;
end

function[] = WARN(m,mx)
    if(m >= mx && ~SUPWARN)
        warning('Running a process of size %c, may take some time. \nSuggested process size should be less than %c for good performance,\nReducing the `bin` size or `number of variables` may increase speed.',...
        m, mx);
    end
end        
%1 Get data
nObs    = size(X,1);
nVar    = size(X,2);
if(~exist('nBin'))
    %set default bin number to 10
    nBin    = 10;
end
maxX    = max(X);
minX    = min(X);minX = minX - 1e-10;
bDim    = (maxX-minX)/nBin;
if(exist('waitCB','var')); waitCB(1/8); end;
%2 Create intervals
bIntv   = zeros(nBin+1,nVar);
for i=1:nVar
    bIntv(:,i) = (minX(i):bDim(i):maxX(i));
end
if(exist('waitCB','var')); waitCB(2/8); end;
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
function [combos] = combos(n,m)
%   combos::lists all the possible combinations for the values in `n`, 
%   `m` times.
%@(param) n array of numbers
%@(param) m number of slots
%@(param) SUPPWARN suppresses warnings
    % If `m` is not specified then resort to using 
    % the length of `n`
    if(~exist('m','var'))
        m = length(n);
    end
    WARN(length(n)^m,35^3);
    % Iniital condition
    combos = [];
    % Define appending function (where the magic happens)
    function [ appArr ] = appTo( arr, nums )
    % appTo:: appends all `nums` to `arr`
    %@(param) arr array which will have values appended to
    %@(param) nums the numbers that will be appended 
        
        % get data and set values
        nArr    = size(arr);
        appArr = [];
        %Run appending algothorithm
        if(nArr(1) <= 1)
           for iNum=nums
               appArr = [appArr; arr iNum];
           end
        else
           for iArr = 1:nArr(1)
                appArr = [appArr; appTo(arr(iArr,:),nums)];
           end
        end
    end
    % Run selection process
    for iMax=1:m
        combos = appTo(combos, n);
    end

    combos = combos';
end

%4 Get all needed combinations
cmb = combos(1:nBin,nVar);
if(exist('waitCB','var')); waitCB(4/8); end;

%5 Bin-Size Test setup
if(SUPTEST == false)
    Tbin     = zeros(2,nVar);
    iComb = ((1:nVar)*0+1);
    for iVar = 1:nVar
        Tbin(1, iVar) = bIntv(iComb(iVar),iVar);
        Tbin(2, iVar) = bIntv(iComb(iVar)+1,iVar);
    end
    sizeTest = prod(abs(diff(Tbin)));
end
if(exist('waitCB','var')); waitCB(5/8); end;

% Warning of size
WARN(length(cmb)^nVar,(7^3)^3);

% Difference Function
function [ res ] = DDn( fin, n, F, minx )
    DDf = @(fin,n,F) F([fin(1:n-1) minx(n) fin(n+1:end)])-F(fin);
    if(n > 1)
        res = DDf( fin, n, @(x) DDn(x,n-1,F,minx) ); 
    else
        res = DDf( fin, 1, F );
    end
end

%6 Computation loop
for iBin = 1:length(cmb)
    iComb   = cmb(:,iBin);
    bin     = zeros(2,nVar);
    for iVar = 1:nVar
        bin(1, iVar) = bIntv(iComb(iVar),iVar);
        bin(2, iVar) = bIntv(iComb(iVar)+1,iVar);
    end
    if(abs(sizeTest - prod(abs(diff(Tbin)))) > 0 && ~SUPTEST)
        error('Wrong bin dimension, bin(%d)== %d ~= %d',...
            iBin, prod(abs(diff(Tbin))), size.test);
    end
    bins{iBin} = bin;
    O(iBin) = sum(sum(repmat(bin(1,:),nObs,1) < X & repmat(bin(2,:),nObs,1) >= X,2)==nVar)/nObs;
    minx = bin(1,:);maxx = bin(2,:);
    n = size(bin,2);
    E(iBin) = abs(DDn(maxx,n,F,minx));
    if(exist('waitCB','var')); waitCB((5 + iBin./length(cmb))/8); end;
end
if(exist('waitCB','var')); waitCB(6/8); end;

%7 Test that all bins were measured
if(abs(sum(O)-1)>1e-10 && ~SUPTEST && ~SUPWARN)
    warning('sum(O) was not complete, |sum(O) - 1| = %d',abs(sum(O)-1));
end
if(exist('waitCB','var')); waitCB(7/8); end;

%8 Compute Results
Chi = sum(sum(((O - E).^2)./E));
Res = Chi < chi2inv(0.99,nObs-1);
if(~SUPTEST)
    disp('----] Chi-Fit Test Results [----');
    fprintf('-> Number of Bins: %d\n-> Chi Score: %2.3f\n-> Degrees of Freedom: %d\n\n',...
        nBin, Chi, nObs-1);
end

if(exist('waitCB','var')); waitCB(8/8); end;
end

