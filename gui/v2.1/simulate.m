function [ X ] = simulate( num, a0, a, s, mu )
% simulate Summary 
% This function simulates values for the Furman pareto of second kind
% mu  := loation parameters
% s   := scale parameters
% a   := shape parameters
% a0  := shared-shape parameter
% num := number of simulates values

    % Set defaults
    switch nargin
        case 1
            mu  = 0;
            s   = 1;
            a   = 1;
            a0  = 1;
        case 2
            mu  = 0;
            s   = 1;
            a   = 1;
        case 3
            mu  = zeros(1,length(a));
            s   = ones(1,length(a));
        case 4
            mu  = zeros(1,min([length(a) length(s)]));
    end
    % Determine number of distributions (will ignore if too many are put
    % for something)
    n   = min([length(mu) length(s) length(a)]);
    
    % Create values
    a0_ = repmat(a0,num,1);
    a_  = repmat(a(1:n),num,1);
    s_  = repmat(s(1:n),num,1);
    mu_ = repmat(mu(1:n),num,1);
    
    % Simulate random values
    p0  = 1- rand(num, 1,1);
    p   = 1- rand(num, n,1);
    %p   = repmat(p0,1,n);
    
    % simulate univariate paretos
    Y0  = (p0.^(1./(-a0_))-1);
    Y   = (p.^(1./(-a_))-1).*s_+mu_;
    
    % Apply the multivariate model
    X = min(repmat(Y0,1,n).*s_+mu_,Y);
end

