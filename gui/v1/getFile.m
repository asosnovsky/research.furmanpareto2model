function [ data, name ] = getFile( )
    [name, path] = uigetfile({'*.csv*','Comma seperated files'},'Select Data File');
    data = csvread(strcat(path,name),1);
    %name = strcat(path,name);
end

