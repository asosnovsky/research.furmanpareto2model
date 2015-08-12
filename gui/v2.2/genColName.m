function [ colnames ] = genColName( label, len )
    colnames = cell(len,1);
    for i=1:len
        colnames{i} = strcat(label,num2str(i));
    end
end

