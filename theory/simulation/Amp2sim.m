function [ X ] = Amp2sim( num, a, s, mu )
%	Amp2sim::simulates values using the Arnold 
%   pareto of second kind
%   @(param)    num    Number(1, infty); number of simulates values  (required)
%   @(param)    a      Number(1, infty); shape parameters            (defaults to 2)
%   @(param)    s      Number(1, infty); scale parameters            (defaults to 1)
%   @(param)    mu     Number(0,infty);  loation parameters          (defaults to 0)
%   @(return)   X      Matrix;           simulated values
%

    % Set defaults
    switch nargin
        case 1
            mu  = 0;
            s   = 1;
            a   = 2;
        case 2
            mu  = 0;
            s   = 1;
        case 3
            mu  = 0;
            s   = 1;
        case 4
            mu  = zeros(1,length(s));
    end
    % Determine number of distributions (will ignore if too many are put
    % for something)
    n   = min([length(mu) length(s)]);
    
    % Simulate random Gamma values
    Z   = gamrnd(a,1,num,1);
    
    % Create X container
    X   = zeros(num,n);
    
    % Apply the Model
    for(iX = 1:n)
        W   = wblrnd(s(iX),1,num,1);
        X(:,iX) = mu(iX) + s(iX)*(W./Z);
    end
  

%     if(any(X<0) | any(X<mu))
%         error('MU::MAX:ERROR');
%     end
end

