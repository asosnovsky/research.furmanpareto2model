function [combos] = combos(n,m, SUPPWARN)
%   combos::lists all the possible combinations for the values in `n`, 
%   `m` times.
%@(param) n array of numbers
%@(param) m number of slots
%@(param) SUPPWARN suppresses warnings
    % If `m` is not specified then resort to using 
    % the length of `n`
    if(~exist('m','var'))
        m = length(n);
    end
    if(length(n)^m >= 35^3 && ~exist('SUPPWARN','var'))
        warning('Running process of size %d, may take some time. Suggested process size should be less than %d',length(n)^m, 35^3);
    end
    % Iniital condition
    combos = [];
    % Define appending function (where the magic happens)
    function [ appArr ] = appTo( arr, nums )
    % appTo:: appends all `nums` to `arr`
    %@(param) arr array which will have values appended to
    %@(param) nums the numbers that will be appended 
        
        % get data and set values
        nArr    = size(arr);
        appArr = [];
        %Run appending algothorithm
        if(nArr(1) <= 1)
           for iNum=nums
               appArr = [appArr; arr iNum];
           end
        else
           for iArr = 1:nArr(1)
                appArr = [appArr; appTo(arr(iArr,:),nums)];
           end
        end
    end
    % Run selection process
    for iMax=1:m
        combos = appTo(combos, n);
    end

    combos = combos';
end
