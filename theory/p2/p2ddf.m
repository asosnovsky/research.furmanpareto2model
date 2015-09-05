function [ F ] = p2ddf( a, s, mu )
% p2ddf::a `distribution maker` for the `Independent-Multivariate Second kind
% Pareto Model`.
% @(param)  a  shared-shape parameter  (defaults to 2)
% @(param)  s   scale parameters        (defaults to 1)
% @(param)  mu  loation parameters      (defaults to 0)
% @(return) F   ddf of second kind multivariate pareto

    % Set defaults
        switch nargin
            case 0
                mu  = 0;
                s   = 1;
                a   = 2;
            case 1
                mu  = 0;
                s   = 1;
            case 2
                mu  = zeros(1,length(s));
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
        a   = a(1);
% Return a parametized function
F = @distF;
    % Define the general distribution
    function y = distF(x)
        % find size of addition
        n = min([length(mu) length(s)]);
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

        % compute all points
        y = (1+(x-mu_)./s_).^-a;
        y = prod(y,2);
        
    end
end

