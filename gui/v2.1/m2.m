clear
clc

a0  = 1;
a   = [2 3];
mu  = [0 0];
s   = [2 1];
num = 100;
C   = zeros(num,1);
for i = 1:num
    X       = simulate(120, a0, a, s, mu);
    Chi     = chiTest(X, a0, a, s, mu);
    C(i)    = Chi;
end
disp(sprintf('Average Chi score: %d',mean(C)));
disp(sprintf('Correct %d times out of %d trials',sum(C<chi2inv(0.95,10)), num));

%%
clear 
clc

a0  = 1;
a   = [2 3];
mu  = [0 0];
s   = [2 1];
num = 200;
C   = zeros(num,1);
for i = 1:num
    X       = simulate(500, a0, a, s, mu);
    ana     = paretoAnalysis(X,1);
    ea0     = ana{1};
    ea      = cell2mat(ana(2,:));
    emu     = cell2mat(ana(3,:));
    es      = cell2mat(ana(4,:));
    Chi     = chiTest(X, ea0, ea, es, emu);
    C(i)    = Chi;
end
disp(sprintf('Average Chi score: %d',mean(C)));
disp(sprintf('Correct %d times out of %d trials',sum(C<chi2inv(0.95,10)), num));

%%
a0  = 1;
a   = [2 3];
mu  = [0 0];
s   = [2 1];
X   = simulate(120, a0, a, s, mu);
 
e = X;
for i = 1:size(X,2)
    e = orderIt(e,i);
end

n = size(X,1);
m = size(e,1);

O = zeros(m,1);
for i=1:m
    O(i) = sum(sum(X>=repmat(e(i,:),n,1),2) == 2)./n;
end

% Create a multivariate distribution
F = Fmulpareto2(a0, a, s, mu);
% Get the precetages from that distribution
E = F(e);

% compute Chi
sum(((O - E).^2)./E)