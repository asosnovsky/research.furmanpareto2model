function [ Chi ] = chiTestP( X, a, s, mu  )

% Sort the acquired data
x   = sortrows(X,1);
n   = size(x,1);

% Find greatest divisior 
% (I think this would be the best choice for the 
% number of section we divide x into)
divs    = 1:n;
divs    = divs(rem(n,divs)==0);
dg      = divs(length(divs)-1);

% set bp as the number of sections we will have
bp = n./dg;
% create containers
mx = [];O = [];
% loop
for i=1:(dg-1)
	% temporary storage
	tmp = x((1:bp)+i.*bp,:);
	% add any xi<max(tmp) (since tmp is ordered, the last value is the max)
	O = [O; sum(x(:,1)>tmp(length(tmp),1))./n];
	% store max values
	mx = [mx ; tmp(length(tmp),:)];
end

E = (1 + (mx-mu)./s).^-a;
Chi = sum(((O -E).^2)./E);


end