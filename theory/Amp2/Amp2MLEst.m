function [ a, mu_ ] = Amp2MLEst( X )
% Amp2MLEst::runs a fit max-likelihood model for the Arnold Multiavariate Pareto of 2nd Kind
% @(param)  X           Matrix;             Collumns are a data series (require)
% @(return) a           Number;             estimated shape param
%
    
    %1 Computed sizes
    nVar    = size(X,2);
    nObs    = size(X,1);

    %2 Compute mu
    mu_ 		= min(X);
    
    %3 Normalize X
    X_      = X - repmat(mu_, nObs,1);
    
    %4 Compute Constant
    Xn = ( sum(log(1+sum(X_)))./nObs )./2;
    
    %5 Compute alpha
    a = 1 - Xn.* ( 1 + [1 -1].*sqrt( 1+Xn.^(-2) ) );
    a = sum((a>0).* a);

end

