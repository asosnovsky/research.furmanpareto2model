function [ f ] = p2pdf( x, a, s, mu )
    f = zeros(size(x));
    f(x>mu) = (a./s).*(1+(x(x>mu)-mu)./s).^(-a-1);
    f(f<=0) = 1e-7;
end



