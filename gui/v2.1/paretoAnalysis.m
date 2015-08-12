function [ anaData ] = paretoAnalysis( X , opt)
% This function runs a fit model for the Furman Multiavariate Second Kind
% Pareto model on the data passed into `X`.
% @parameter X := Matrix; Collumns are a data series
    % get sizes
    m   = size(X,1);
    n   = size(X,2);
    % Set anaData
    anaData = cell(8, n);
    % find location parameters
    location        = min(X);
    X_              = X-repmat(location,m,1);
    anaData(3,:)    = num2cell(location);
    % get moments
    E               = mean(X_);
    E2              = mean((X_).^2);
    anaData(5,:)    = num2cell(E);
    anaData(6,:)    = num2cell(E2);
    %get the 0k paremeters
    %shape0k = scale ./E + 1;
    shape0k         = 2.*(E2-E.^2)./(E2-2.*E.^2);
    
    % get scale parameters
    %scale = ( 1 + (2.*E.^2)./E2 ).*E;  
    %scale           = (shape0k-1).*E;
    %scale           = (shape0k-2).*E2./(2.*E);
    scale           = (E.*E2)./(E2-2.*E.^2);
    anaData(4,:)    = num2cell(scale);
    
    %get shape parameters
    % deal with options
    p = {};
    if(~exist('opt','var'))
        opt = 1;
    end
    if(opt == 2)
        p{opt} = corr(X_,'Type','Kendall');
    end
    if(opt == 1)
        p{opt} = corr(X_,'Type','Pearson');
    end
    if(opt == 3)
        p{opt} = corr(X_,'Type','Spearman');
    end
    
    % get the shape parameters based on a given
    % correlation
    function [] = getShapes(corr)
        if(corr)
            shape0 = [];
            for i = 1:(n-1);
                for j = 1:(n-i);
                    corr = p{opt}(i,i+j);
                    shape0 = [shape0 (corr.*(sum(shape0k([i,i+j]))-2))./(prod(E([i,i+j]))+corr)];
                    anaData(7,i) = num2cell(corr);
                end
            end
            %disp(shape0);disp(p{opt});
            anaData(1,1) = num2cell(mean(shape0));
            anaData(2,:) = num2cell(shape0k - mean(shape0));
        end
    end
    getShapes(opt);
end

