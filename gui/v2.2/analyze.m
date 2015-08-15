function [ location, scale, shape, shape0, shapes0, p ] = analyze( X, type, waitCB )
% analuze::runs a fit model for the Furman Multiavariate Second Kind
% Pareto, also performs a multivariate chi-test as needed
% @(param)  X           Matrix;             Collumns are a data series (require)
% @(param)  chiLevel [DNE]    Number(0,1)|Bolean; the chi level to test with (optional)
% @(param)  waitCB [TBD]
% @(param)  realVal [DNE]     Structure;          a structure with the real values of the distribution (optional)
% @(return) location    Number;             estimated location param
% @(return) scale       Number;             estimated scale param
% @(return) shape       Number;             estimated shape param
% @(return) shape0      Number;             estimated joint-shape param
% @(return) chi [DNE]        Number;             the chi-square score
% @(return) p           Number;             the correlations
%
% Notes:
% (1) If the chiLevel or the realVal params are passed then a series of
%     messages with the results of their respected test will be shown.
% (2) The chi-score will be calculated regardless of whether the chiLevel
%     is set.
%
% Depended Functions:
% Fmulpareto2; chiTest;

    %1 compute location param
    location= min(X);
    if(exist('waitCB','var')); waitCB(1/6); end;
    %2 Computed sizes
    nRows   = size(X,1);
    nVar    = size(X,2);
    if(exist('waitCB','var')); waitCB(2/6); end;
    %3 Normalize X
    % Get normalized dataset
    X_      = X - repmat(location, nRows,1);
    if(exist('waitCB','var')); waitCB(3/6); end;
    %4 Compute Moments
    m1      = mean(X_);
    m2      = mean(X_.^2);
    if(exist('waitCB','var')); waitCB(4/6); end;
    %5 Compute Shape0k and scale
    shape0k = (2.*m1.^2)./m2+2;
    scale   = m1.*(shape0k-1);
    if(exist('waitCB','var')); waitCB(5/6); end;
    %6 Compute Shape0
    p      = corr(X_,'Type',type);
    shapes0 = zeros(1, nVar-1);
    for iVar=1:(nVar-1)
        shapes0(iVar) = p(iVar,iVar+1).*(shape0k(iVar)+shape0k(iVar+1)-2)./(m1(iVar).*m2(iVar+1)+p(iVar,iVar+1));
    end
    shape0 = mean(shapes0);
    shape = shape0k - shape0;
    if(exist('waitCB','var')); waitCB(6/6); end;
end

