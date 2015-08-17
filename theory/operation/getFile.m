function [ data, name, headers ] = getFile( )
%   getFile::creates a popup message, which lets you select a file
%   @(return) data the csv table, parsed into a matlab-matrix
%   @(return) name the name and path of the file on your device
    clc;
    [name, path] = uigetfile({'*.csv*','Comma seperated files'},'Select Data File');
    headers = YNDialog('Headers', 'Ignore headers?', @(x) x*1);
    data = csvread(strcat(path,name), headers);
    %headers = fread(strcat(path,name));
    name = strcat(path,name);
end

