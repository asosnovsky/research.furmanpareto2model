function [ F ] = mgp( k, s, mu )
% mgp::a `distribution maker` for the `Multivariate Generalized Pareto Model`.
% @(param)  k   shape parameters        (defaults to 2)
% @(param)  s   scale parameters        (defaults to 1)
% @(param)  mu  loation parameters      (defaults to 0)
% @(return) F   ddf of multivariate pareto

    % Set defaults
        switch nargin
            case 0
                mu  = 0;
                s   = 1;
                k   = 2;
            case 1
                mu  = zeros(1,length(k));
                s   = ones(1,length(k));
            case 2
                mu  = zeros(1,min([length(k) length(s)]));
        end
        % This function is to make sure we get passeed 
        % the right sort of parameters
        function param = sizeIt(oparam)
            if(size(oparam,2) <= size(oparam,1))
                param = oparam';
            else
                param = oparam;
            end
            if(size(param,1) > 1)
                param = param(1,:);
            end
        end
        mu  = sizeIt(mu);
        s   = sizeIt(s);
        k   = sizeIt(k);
% Return a parametized function
F = @distF;
    % Define the general distribution
    function y = distF(x)
        % find size of addition
        n = min([length(mu) length(s) length(k)]);
        sx = size(x);
        if(sx(1) == n && sx(2)~= n)
            x = x';
        else
            if(sx(1) == 1 && sx(2) > n)
                x = repmat(x',1,n);
            elseif(sx(2) == 1 && sx(1) > n)
                x = repmat(x,1,n);
            end
        end
        m = size(x,1);
        % create proper sized values
        mu_ = repmat(mu(1:n),m,1);
        s_  = repmat(s(1:n),m,1);
        k_  = repmat(k(1:n),m,1);

        % compute all points
        y = (k_== 0).*(exp((mu_-x)./s_));
        y = y + (k_~=0).*((1+k_.*(x-mu_)./s_).^(-1./k_));
        
        % compute points
        y = prod(y,2);
        
    end
end



