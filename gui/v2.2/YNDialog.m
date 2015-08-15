function [ ret ] = YNDialog( name, text, cb )
%   YNDialog::creates a popup message, which asks a Yes/No question
%   @(param)  name header of the popup
%   @(param)  test the question
%   @(param)  cb  the callback function for the answer
%   @(return) ret the returned transfrom of the callback
 
    d = dialog('Position',[300 300 250 120],'Name',name);

     uicontrol('Parent',d,...
               'Style','text',...
               'Position',[20 60 210 40],...
               'String',text);

    uicontrol('Parent',d,...
               'Position',[135 30 70 25],...
               'String','Yes',...
               'Callback',@YES);

    uicontrol('Parent',d,...
               'Position',[35 30 70 25],...
               'String','No',...
               'Callback',@NO);
       
    uiwait(d);
    function CANCEL()
        error('Analysis Stopped') ;
    end
    function NO(~,~)
      ret = cb(false);
      delete(gcf)
    end
    function YES(~,~)
      ret = cb(true);
      delete(gcf)
    end
end

