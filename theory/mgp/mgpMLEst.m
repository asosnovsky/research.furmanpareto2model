function [ k, s, sigma, alpha ] = mgpMLEst( X )
% mgpMLEst::runs a fit max-likelihood model for the Multiavariate Generalized Pareto
% @(param)  X           Matrix;             Collumns are a data series (require)
% @(return) k           Number;             estimated scale param
% @(return) s           Number;             estimated shape param
%
% Depended Functions:
% gpfit;

    %1 Computed sizes
    nVar    = size(X,2);
    
    %2 Create containers for shape and scale
    k       = zeros(1, nVar);
    s       = zeros(1, nVar);
    
    %3 Compute Scale and Shape
    for(iVar = 1:nVar)
        params = gpfit(X(:,iVar));
        k(iVar) = params(1);
        s(iVar) = params(2);
    end
    
    alpha = -1./k;
    sigma = s./k;
end

