function [ Chi, O, E, bins ] = chiTest( X, F, nBin, SUPWARN, SUPTEST)
% chiTest::Multivariate Chi-Test
%@(param) X multivariate dataset
%@(param) F multivariate ddf
%@(param) SUPWARN supress warnings
%@(param) SUPTEST supress tests (may speed up process if enabled, but risk
%having mistakes)

% Get data
nObs    = size(X,1);
nVar    = size(X,2);
if(~exist('nBin'))
    %set default bin number to 10
    nBin    = 10;
end
maxX    = max(X);
minX    = min(X);minX = minX - 1e-10;
bDim    = (maxX-minX)/nBin;

% Create intervals
bIntv   = zeros(nBin+1,nVar);
for i=1:nVar
    bIntv(:,i) = (minX(i):bDim(i):maxX(i));
end

% Set Containers
O        = zeros(nBin^nVar,1);
E        = zeros(nBin^nVar,1);
bins     = cell(nBin^nVar,1);

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
    if(length(n)^m >= 35^3 && ~exist('SUPPWARN','var'))
        warning('Running process of size %d, may take some time. Suggested process size should be less than %d',length(n)^m, 35^3);
    end
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

% Get all needed combinations
cmb = combos(1:nBin,nVar);

% Bin-Size Test setup
if(~exist('SUPTEST','var'))
    Tbin     = zeros(2,nVar);
    iComb = ((1:nVar)*0+1);
    for iVar = 1:nVar
        Tbin(1, iVar) = bIntv(iComb(iVar),iVar);
        Tbin(2, iVar) = bIntv(iComb(iVar)+1,iVar);
    end
    sizeTest = prod(abs(diff(Tbin)));
end
% Computation loop
for iBin = 1:length(cmb)
    iComb   = cmb(:,iBin);
    bin     = zeros(2,nVar);
    for iVar = 1:nVar
        bin(1, iVar) = bIntv(iComb(iVar),iVar);
        bin(2, iVar) = bIntv(iComb(iVar)+1,iVar);
    end
    if(abs(sizeTest - prod(abs(diff(Tbin)))) > 0 && ~exist('SUPTEST','var'))
        error('Wrong bin dimension, bin(%d)== %d ~= %d', iBin, prod(abs(diff(Tbin))), size.test);
    end
    bins{iBin} = bin;
    O(iBin) = sum(sum(repmat(bin(1,:),nObs,1) < X & repmat(bin(2,:),nObs,1) >= X,2)==nVar)/nObs;
    E(iBin) = abs(diff(F(bin)));
end
% Test that all bins were measured
if(abs(sum(O)-1)>1e-10 && ~exist('SUPTEST','var') && ~exist('SUPWARN','var'))
    warning('sum(O) was not complete, |sum(O) - 1| = %d',abs(sum(O)-1));
end
Chi = sum(sum(((O - E).^2)./E));
end

