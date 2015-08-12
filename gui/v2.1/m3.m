clear
clc

a0  = 1;
a   = [2 3];
mu  = [0 0];
s   = [2 1];
X   = simulate(20, a0, a, s, mu);
[Chi, O, E, bins] = chiTestBi(X, a0, a, s, mu);
disp(Chi);

%%
clear
clc
% Simulation
a0      = 1;
a       = [2 3 4];
mu      = [0 0 10];
s       = [2 1 2];
nObs    = 120;
nTest   = 100;
F = Fmulpareto2(a0, a, s, mu);
cnt = 0;
for i=1:nTest
    X   = simulate(nObs, a0, a, s, mu);
    disp(i/nTest);
    cnt = cnt + chiTest(X,F);
end
disp(chi2cdf(cnt/nTest,nObs));
%%
% Get data
nObs    = size(X,1);
nVar    = size(X,2);
nBin    = lcd(nObs,'smax');%nBin = 2;
maxX    = max(X);
minX    = min(X);minX = minX - 1e-10;
bDim    = (maxX-minX)/nBin;

% Create intervals
bIntv   = zeros(nBin+1,nVar);
for i=1:nVar
    bIntv(:,i) = (minX(i):bDim(i):maxX(i));
end

% Set Containers
O        = zeros(nBin^nVar,1);
E        = zeros(nBin^nVar,1);
bins     = cell(nBin^nVar,1);
bTest    = prod(diff(bIntv(1:2,:)));

% Get all needed combinations
cmb = combos(1:nBin,nVar);

% Bin-Size Test setup
    Tbin     = zeros(2,nVar);
    iComb = ((1:nVar)*0+1);
    for iVar = 1:nVar
        Tbin(1, iVar) = bIntv(iComb(iVar),iVar);
        Tbin(2, iVar) = bIntv(iComb(iVar)+1,iVar);
    end
    size.test = prod(abs(diff(Tbin)));
% Computation loop
for iBin = 1:length(cmb)
    iComb   = cmb(:,iBin);
    bin     = zeros(2,nVar);
    for iVar = 1:nVar
        bin(1, iVar) = bIntv(iComb(iVar),iVar);
        bin(2, iVar) = bIntv(iComb(iVar)+1,iVar);
    end
    if(abs(size.test - prod(abs(diff(Tbin)))) > 0)
        error('Wrong bin dimension, bin(%d)== %d ~= %d', iBin, prod(abs(diff(Tbin))), size.test);
    end
    bins{iBin} = bin;
    O(iBin) = sum(sum(repmat(bin(1,:),nObs,1) < X & repmat(bin(2,:),nObs,1) >= X,2)==nVar)/nObs;
    E(iBin) = abs(diff(F(bin)));
end
disp(sum(O));
Chi = sum(sum(((O - E).^2)./E));
disp(Chi);



