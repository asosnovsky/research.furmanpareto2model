%% Method of Moments Test
clear
clc
% Set Chi Level
chiLevel = 0.99;
% Simulation parameters
a0      = 1;
a       = [2 3 2];
mu      = [0 0 5];
s       = [2 2 1];
nObs    = 1000;
% Simulation
X   = simulate(nObs, a0, a, s, mu);

% Pre-Analysis
%  ------------
clc
disp('-------------[Pre-Analysis]--------------');
% Computing anticipated values
ant = struct('mean',mu+s./(a+a0-1),...
    'var',((a+a0).*s.^2)./(((a+a0-1).^2).*(a+a0-2)),....
    'm2',(2.*s.^2)./(((a+a0-1).^2).*(a+a0-2)),...
    'corr',SSpCorReal( a0, a, s, mu )...
    );
% Computing simulated values
sim = struct('mean',mean(X),...
    'var',var(X),....
    'm2',mean(X.^2),...
    'corr', SSpCorEst( X, 'Kendall')...
    );
clear p;
disp('Anticipated Values:');disp(ant);
disp('Simulated Values:');disp(sim);

% Analysis
%  --------
%clc
disp('---------------[Analysis]----------------');
[ location, scale, shapes, shape0, chi, shapes0, p, ana, O, E, bins ] = analyze( X, 'Kendall', chiLevel, struct('a',a,'a0',a0,'s',s,'mu',mu) );
