function [ p ] = SSpCorReal( a0, a, s, mu )
%SSpCorEstimates::Helper function for test

    % Get Size
    nVar = min([length(a) length(s) length(mu)]) -1;
    % Compute helper
    a0k_1 = a0+a-1;
    % Create container
    p = zeros(1,nVar);

    for iVar = 1:nVar
        p(iVar) = (a0.*s(iVar).*s(iVar+1))./(a0k_1(iVar).*a0k_1(iVar+1).*(a0+a(iVar)+a(iVar+1)-2));
    end
end

