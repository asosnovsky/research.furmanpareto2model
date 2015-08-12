function [ data, name ] = getFile( )
    clc;
    [name, path] = uigetfile({'*.csv*','Comma seperated files'},'Select Data File');
    disp(path);
    data = csvread(strcat(path,name));
    name = strcat(path,name);
end

