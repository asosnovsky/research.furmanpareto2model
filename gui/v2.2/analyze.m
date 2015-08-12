function [ location, scale, shape, shape0, chi, shapes0, p, ana, O, E, bins ] = analyze( X, type, chiLevel, realVal, waitCB )
% analuze::runs a fit model for the Furman Multiavariate Second Kind
% Pareto, also performs a multivariate chi-test as needed
% @(param)  X           Matrix;             Collumns are a data series (require)
% @(param)  chiLevel    Number(0,1)|Bolean; the chi level to test with (optional)
% @(param)  realVal     Structure;          a structure with the real values of the distribution (optional)
% @(param)  waitCB [TBD]
% @(return) location    Number;             estimated location param
% @(return) scale       Number;             estimated scale param
% @(return) shape       Number;             estimated shape param
% @(return) shape0      Number;             estimated joint-shape param
% @(return) chi         Number;             the chi-square score
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

    %2 Computed sizes
    nRows   = size(X,1);
    nVar    = size(X,2);
    if(exist('waitCB','var')); waitCB(2/12); end;
    %3 Normalize X
    % Get normalized dataset
    X_      = X - repmat(location, nRows,1);
    if(exist('waitCB','var')); waitCB(3/12); end;
    %4 Compute Moments
    m1      = mean(X_);
    m2      = mean(X_.^2);
    if(exist('waitCB','var')); waitCB(4/12); end;
    %5 Compute Shape0k and scale
    shape0k = (2.*m1.^2)./m2+2;
    scale   = m1.*(shape0k-1);
    if(exist('waitCB','var')); waitCB(5/12); end;
    %6 Compute Shape0
    p      = corr(X_,'Type',type);
    shapes0 = zeros(1, nVar-1);
    for iVar=1:(nVar-1)
        shapes0(iVar) = p(iVar,iVar+1).*(shape0k(iVar)+shape0k(iVar+1)-2)./(m1(iVar).*m2(iVar+1)+p(iVar,iVar+1));
        shape0 = mean(shapes0);
        shape = shape0k - shape0;
    end
    if(exist('waitCB','var')); waitCB(6/12); end;
    %7 Chi Results
    F   = Fmulpareto2(shape0, shape, scale, location);
    [ chi, chiRes, O, E, bins ] = chiTest(X, F, 10, false, false, waitCB);
    if(exist('realVal','var'))
        if(realVal ~= false)
        % Messages
        fprintf('Averaged Values: \n');
        fprintf('-----------------------------------------\n');
        fprintf('> Name  | Estimated | Real | Diff |\n');
        fprintf('> --------------------------------------- \n');
        fprintf('> alpha0  %2.2f       %2.2f    %2.2f    \n', shape0,realVal.a0, abs(shape0-realVal.a0));
        fprintf('> alpha%d  %2.2f       %2.2f    %2.2f   \n', [1:length(realVal.a); shape; realVal.a; abs(shape-realVal.a)]);
        fprintf('> mu%d     %2.2f       %2.2f    %2.2f   \n', [1:length(realVal.mu); location; realVal.mu; abs(location-realVal.mu)]);
        fprintf('> s%d      %2.2f       %2.2f    %2.2f   \n', [1:length(realVal.s); scale; realVal.s; abs(scale-realVal.s)]);
        fprintf('> --------------------------------------- \n');
        end
    end
    nObs = size(X,1);
    ana = struct('errR',chi2cdf(chi,nObs-1)*100,...
                 'dg',nObs-1,...
                 'chires',chiRes...
                 );
    if(exist('chiLevel','var'))
        if(chiLevel ~= false)
            fprintf('> Error Rate: %d%%\n',...
                ana.errR);
            fprintf('> Chi-Score: %2.4f  \n> Required Score: %2.4f\n> Degrees of freedom: %d\n',...
                chi, chi2inv(chiLevel,nObs-1), ana.dg);
            fprintf(' [ Alpha resultion method used: `MEAN` ] \n');
        end
    end
end

