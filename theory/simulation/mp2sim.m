function [ X ] = mp2sim( num, a, s, mu )
%	mp2sim::simulates values using the Furman 
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
            mu  = zeros(1,length(a));
    end
    % Determine number of distributions (will ignore if too many are put
    % for something)
    n   = min([length(mu) length(s) length(a)]);
    
    % Create values
    a_  = repmat(a(1:n),num,1);
    s_  = repmat(s(1:n),num,1);
    mu_ = repmat(mu(1:n),num,1);
    
    % Simulate random values
    p   = 1- rand(num, n,1);
    
    % simulate paretos
    X   = (p.^(1./(-a_))-1).*s_+mu_;
 
 end

