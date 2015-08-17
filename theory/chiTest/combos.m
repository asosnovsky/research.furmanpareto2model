function y = combos(n,m)
%   combos::lists all the possible combinations for the values in `n`, 
%   `m` times.
%@(param) n array of numbers
%@(param) m number of slots

y = n;
for i=2:m
    z = n;
    y = [copy_blocked(y,size(z,2)); copy_interleaved(z,size(y,2))]; 
end

function b = copy_blocked(m,n)
    [mr,mc] = size(m);
    b = zeros(mr,mc*n);
    ind = 1:mc;
    for i=[0:(n-1)]*mc
      b(:,ind+i) = m;
    end
end
function b = copy_interleaved(m,n)
    [mr,mc] = size(m);
    b = zeros(mr*n,mc);
    ind = 1:mr;
    for i=[0:(n-1)]*mr
      b(ind+i,:) = m;
    end
    b = reshape(b,mr,n*mc);
end

end