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

% Last Modified by GUIDE v2.5 18-Jun-2015 14:05:40

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


% --- Executes on button press in loadbtn.
function loadbtn_Callback(~, ~, handles)
% hObject    handle to loadbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [data name] = getFile();
    handles.loadbtn.String = 'Select New';
    handles.loadtext.String = name;
    data = analyze(data);
    disp(data.Pearson);
    % corr values
    handles.datatable.Data(1,1) = num2cell(data.Spearman.corr);
    handles.datatable.Data(1,2) = num2cell(data.Pearson.corr);
    handles.datatable.Data(1,3) = num2cell(data.Kendall.corr);
    % a0 values
    handles.datatable.Data(2,1) = num2cell(data.Spearman.a0);
    handles.datatable.Data(2,2) = num2cell(data.Pearson.a0);
    handles.datatable.Data(2,3) = num2cell(data.Kendall.a0);
    % a1 values
    handles.datatable.Data(3,1) = num2cell(data.Spearman.a(1));
    handles.datatable.Data(3,2) = num2cell(data.Pearson.a(1));
    handles.datatable.Data(3,3) = num2cell(data.Kendall.a(1));
    % a2 values
    handles.datatable.Data(4,1) = num2cell(data.Spearman.a(2));
    handles.datatable.Data(4,2) = num2cell(data.Pearson.a(2));
    handles.datatable.Data(4,3) = num2cell(data.Kendall.a(2));
    