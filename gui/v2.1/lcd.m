function [d] = lcd(n,dnum)
    if(~exist('dnum','var'))
        dnum = 2;
    end
    divs    = 1:n;
    divs    = divs(rem(n,divs)==0);
    disp(divs);
    if(strcmp(dnum,'max'))
        dnum = length(divs)-1;
    end
    if(strcmp(dnum,'smax'))
        dnum = length(divs)-2;
    end
    d     = divs(dnum);
end