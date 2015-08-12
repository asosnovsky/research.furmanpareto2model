function [ cp ] = SSpCorEst( X, type )
%SSpCorEst::Helper function for test

% Get Size
nVar = size(X,2) -1;
pp   = corr(X,'Type',type);
disp(pp);
% Create container
cp   = zeros(1,nVar);

for iVar = 1:nVar
    cp(iVar) = pp(iVar,iVar+1);
end

end

