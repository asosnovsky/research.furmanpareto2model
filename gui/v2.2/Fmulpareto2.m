function [ F ] = Fmulpareto2( a0, a, s, mu )
% Fmulpareto2::a `distribution maker` for the `Furman-Multivariate Second kind
% Pareto Model`.
% @(param)  a0  shared-shape parameter  (defaults to 2)
% @(param)  a   shape parameters        (defaults to 2)
% @(param)  s   scale parameters        (defaults to 1)
% @(param)  mu  loation parameters      (defaults to 0)
% @(return) F   ddf of second kind multivariate pareto

    % Set defaults
        switch nargin
            case 0
                mu  = 0;
                s   = 1;
                a   = 2;
                a0  = 2;
            case 1
                mu  = 0;
                s   = 1;
                a   = 2;
            case 2
                mu  = zeros(1,length(a));
                s   = ones(1,length(a));
            case 3
                mu  = zeros(1,min([length(a) length(s)]));
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
        a   = sizeIt(a);
        a0  = a0(1);
% Return a parametized function
F = @distF;
    % Define the general distribution
    function y = distF(x)
        % find size of addition
        n = min([length(mu) length(s) length(a)]);
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
        a_  = repmat(a(1:n),m,1);

        % compute all points
        y = (x-mu_>0).*(x-mu_);
        y = (1+y./s_);
        
        % compute points
        y = prod(y.^(-a_),2).*(max(y,[],2).^(-a0));
        
    end
end

