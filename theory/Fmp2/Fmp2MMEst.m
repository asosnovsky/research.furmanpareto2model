function [ location, scale, shape, shape0, shape0k, shapes0, p ] = Fmp2MMEst( X, waitCB )
% Fmp2MMEst::runs a fit moment-based model for the Furman Multiavariate Second Kind
% Pareto
% @(param)  X           Matrix;             Collumns are a data series (require)
% @(param)  waitCB      Function;           a waiting callback (optional)
% @(return) location    Number;             estimated location param
% @(return) scale       Number;             estimated scale param
% @(return) shape       Number;             estimated shape param
% @(return) shape0      Number;             estimated joint-shape param
% @(return) p           Number;             the correlations
%
% Depended Functions:
% Fmulpareto2;

    %1 compute location param
    location= min(X);
        if(exist('waitCB','var')); waitCB(1/6); end;
    %2 Computed sizes
    nRows   = size(X,1);
    nVar    = size(X,2);
        if(exist('waitCB','var')); waitCB(2/6); end;
    %3 Normalize X
    X_      = X - repmat(location, nRows,1);
        if(exist('waitCB','var')); waitCB(3/6); end;
    %4 Compute Moment/variance
    m1      = mean(X_);
    m2      = mean(X_.^2);
    v       = var(X_);
        if(exist('waitCB','var')); waitCB(4/6); end;
    %5 Compute basic shape/scale
    shape0k = m2./(m2-2.*m1.^2)+1;
    scale = m1.*(shape0k - 1 );

        if(exist('waitCB','var')); waitCB(5/6); end;

    %6 Compute Parameters
    if(nVar > 1)
        p      = corr(X_,'Type','Kendall');
        shapes0 = zeros(1, nVar-1);
        for iVar=1:(nVar-1)
            shapes0(iVar) = ((shape0k(iVar).*shape0k(iVar+1))*p(iVar,iVar+1))./(1+p(iVar,iVar+1)); 
            shapes0(iVar) = (shapes0(iVar)>0)*shapes0(iVar)+(shapes0(iVar)<=0);
        end
        shape0  = mean(shapes0); 
    else
        p = 1;
        shapes0 = 0;
        shape0  = 0;
    end
    shape   = shape0k - shape0;

        if(exist('waitCB','var')); waitCB(6/6); end;
end

