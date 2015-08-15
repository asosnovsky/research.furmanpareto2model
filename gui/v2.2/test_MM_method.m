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
waitCB = @(x) false;

disp('---------------[Analysis]----------------');
[ location, scale, shapes, shape0, shapes0, p ] = ...
    analyze( X, 'Kendall', waitCB);

%% Chi Results
    F   = Fmulpareto2(shape0, shapes, scale, location);
    [ chi, chiRes, nObs, O, E, bins ] = chiTest(X, F, 10, false, false, waitCB);
% Messages
    fprintf('Averaged Values: \n');
    fprintf('-----------------------------------------\n');
    fprintf('> Name  | Estimated | Real | Diff |\n');
    fprintf('> --------------------------------------- \n');
    fprintf('> alpha0  %2.2f       %2.2f    %2.2f    \n', shape0,a0, abs(shape0-a0));
    fprintf('> alpha%d  %2.2f       %2.2f    %2.2f   \n', [1:length(a); shapes; a; abs(shapes-a)]);
    fprintf('> mu%d     %2.2f       %2.2f    %2.2f   \n', [1:length(mu); location; mu; abs(location-mu)]);
    fprintf('> s%d      %2.2f       %2.2f    %2.2f   \n', [1:length(s); scale; s; abs(scale-s)]);
    fprintf('> --------------------------------------- \n');
    fprintf('> Error Rate: %d%%\n',chi2cdf(chi,nObs-1)*100);
    fprintf('> Chi-Score: %2.4f  \n> Required Score: %2.4f\n> Degrees of freedom: %d\n',...
        chi, chi2inv(0.95,nObs-1), nObs-1);
    fprintf(' [ Alpha resultion method used: `MEAN` ] \n');
 
