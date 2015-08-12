function [tmp] = orderIt(X,c)
        % Initial sort
        x       = sortrows(X,c);
        % Get size
        n      = size(x,1);
        m      = size(x,2);
        % Find lowest divisior 
        divs    = 1:n;
        divs    = divs(rem(n,divs)==0);
        lcd     = divs(2);
        % order it
        tmp = zeros(n/lcd,m);
        for i = 1:(n/lcd)
            tmp(i,:) = x(lcd*i,:);
        end
end