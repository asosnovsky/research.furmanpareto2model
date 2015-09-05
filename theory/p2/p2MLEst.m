function [ location, scale, shape ] = mgpMLEst( X )
% mgpMLEst::runs a fit max-likelihood model for the Multiavariate Generalized Pareto
% @(param)  X           Matrix;             Collumns are a data series (require)
% @(return) location    Number;             estimated location param
% @(return) scale       Number;             estimated scale param
% @(return) shape       Number;             estimated shape param
%
% Depended Functions:
% gpfit;

nVar = size(X,2);
nObs = size(X,1);

location = min(X);
X_ = X - repmat(location,nObs,1);

phat = zeros(nVar,2);

for(iVar = 1:nVar)
    phat(iVar,:) = mle(X_(:,iVar), 'pdf',@(x, a, s) p2pdf( x, a, s, location(iVar) ),'start',[ 1 1 ]);
end

shape = phat(:,1);
scale = phat(:,2);

end