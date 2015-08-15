clear
clc

%try
    [data, path, headers] = getFile();
%catch
%    errordlg('Could not load file.','File Not Found');
%end
%%
fileID = fopen(path);
A = fread(fileID,'*char')';
fclose(fileID);
%%
clc%strcat(num2str(round(1000*0.25+ 0.5*x)/10),'%')
h = waitbar(0,'Please wait...');

[ mu, s, aj, a0, ~, p ] = analyze(data, 'Kendall' , @(x) waitbar(x/2));

F   = Fmulpareto2(a0, aj, s, mu);
try
    [ chi, chiRes, nObs, O, E, bins ] =...
        chiTest(data, F, 10, false, false, @(x) waitbar((1+x)/2));
catch
    errordlg('Can''t compute Chi2-Score values.','Not Enough Memory!');
end
waitbar(1);
close(h);