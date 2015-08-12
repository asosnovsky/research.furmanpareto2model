function varargout = anaGUI(varargin)
% ANAGUI MATLAB code for anaGUI.fig
%      ANAGUI, by itself, creates a new ANAGUI or raises the existing
%      singleton*.
%
%      H = ANAGUI returns the handle to a new ANAGUI or the handle to
%      the existing singleton*.
%
%      ANAGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANAGUI.M with the given input arguments.
%
%      ANAGUI('Property','Value',...) creates a new ANAGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before anaGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to anaGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help anaGUI

% Last Modified by GUIDE v2.5 27-Jul-2015 15:14:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @anaGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @anaGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before anaGUI is made visible.
function anaGUI_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to anaGUI (see VARARGIN)

% Choose default command line output for anaGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes anaGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = anaGUI_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in uploadbtn.
function uploadbtn_Callback(hObject, ~, handles)
% hObject    handle to uploadbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[ data, name ] = getFile( );
hObject.String = 'Upload New File';
handles.filepath.String = name;
handles.data = data;
guidata(hObject, handles);


% --- Executes on button press in gobtn.
function gobtn_Callback(~, ~, handles)
% hObject    handle to gobtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isfield(handles,'data'))
    clc%strcat(num2str(round(1000*0.25+ 0.5*x)/10),'%')
    h = waitbar(0,'Please wait...');
    [ mu, s, a, a0, chi, ~, p, ana ] = analyze( handles.data, 'Kendall', 0.99 , false, @(x) waitbar(0.25+ 0.5*x));
    handles.corrmat.Data = num2cell(p);
    handles.results.Data(1) = num2cell(a0);
    handles.results.Data(2,1:length(a)) = num2cell(a);
    handles.results.Data(3,1:length(s)) = num2cell(s);
    handles.results.Data(4,1:length(mu)) = num2cell(mu);
    handles.results.Data(5,1:length(a)) = num2cell(mean(handles.data));
    handles.results.Data(6,1:length(a)) = num2cell(mean(handles.data.^2));
    handles.results.Data(7,1:length(a)) = num2cell(var(handles.data));
    handles.errorrate.String = strcat(num2str(ana.errR),'%');
    handles.chiscore.String = chi;
    handles.df.String = ana.dg;
    waitbar(0.9);
    handles.chitest.String = native2unicode(ana.chires*'Pass'+(1-ana.chires)*'Fail');
    handles.results.ColumnName = genColName('X',length(a));
    handles.corrmat.ColumnName = genColName('X',length(a));
    handles.corrmat.RowName = genColName('X',length(a));
    close(h);
else
    msgbox('No data, please load a proper file!','Error');
end
