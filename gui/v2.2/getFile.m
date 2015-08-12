function [ data, name ] = getFile( )
%   getFile::creates a popup message, which lets you select a file
%   @(return) data the csv table, parsed into a matlab-matrix
%   @(return) name the name and path of the file on your device
    clc;
    [name, path] = uigetfile({'*.csv*','Comma seperated files'},'Select Data File');
    data = csvread(strcat(path,name),YNDialog('Headers', 'Ignore headers?', @(x) x*1));
    name = strcat(path,name);
end

