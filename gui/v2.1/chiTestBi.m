function[Chi, O, E, bins] = chiTestBi(X,a0, a, s, mu, nBin)
    % Get needed data
    nObs    = size(X,1);
    nVar    = size(X,2);
    if(~exist('nBin','var'))
        nBin    = lcd(nObs,'smax');
    end
    maxX    = max(X);
    bDim    = maxX/nBin;
    % Create a multivariate distribution
    F = Fmulpareto2(a0, a, s, mu);
    
    % get bin intervals
    bIntv   = zeros(nBin+1,nVar);
    for i=1:nVar
        bIntv(:,i) = (mu(i):bDim(i):maxX(i))';
    end
    % Set Outputs
    O        = zeros(nBin,nBin);
    E        = zeros(nBin,nBin);
    bins     = cell(nBin,nBin);
    bTest    = prod([bIntv(2,1) bIntv(2,2)]-[bIntv(1,1) bIntv(1,2)]);
    % Compute bins
    for i=1:nBin
        for j=1:nBin
           bin = [[bIntv(i+1,1) bIntv(j+1,2)]; [bIntv(i,1) bIntv(j,2)]];
           if(abs(bTest - prod(diff(bin)) > 1e-10))
               error('Bad bin dim');
           end
           bins{i,j} = bin;
           O(i,j) = sum(sum(repmat(bin(1,:),nObs,1) >= X & X > repmat(bin(2,:),nObs,1),2)==2)/nObs;
           E(i,j) = diff(F(bin));
        end
    end
    % Compute Chi
    Chi = sum(sum(((O - E).^2)./E));
end