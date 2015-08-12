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

% Last Modified by GUIDE v2.5 07-Jul-2015 12:28:41

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
function anaGUI_OpeningFcn(hObject, eventdata, handles, varargin)
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
function varargout = anaGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in selectbtn.
function selectbtn_Callback(hObject, ~, handles)
% hObject    handle to selectbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[data, path] = getFile();
handles.filepath.String = path;
handles.data = data;
disp(data);
handles.anaData = {{};{};{}};
guidata(hObject, handles);

% --- Executes on selection change in corrsel.
function corrsel_Callback(hObject, eventdata, handles)
% hObject    handle to corrsel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns corrsel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from corrsel


% --- Executes during object creation, after setting all properties.
function corrsel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to corrsel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in gobtn.
function gobtn_Callback(hObject, ~, handles)
% hObject    handle to gobtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
if(isfield(handles,'data'))
    if(~isempty(handles.anaData{handles.corrsel.Value}))
       handles.resultstab.Data = handles.anaData{handles.corrsel.Value};
    else
        ana = paretoAnalysis(handles.data, handles.corrsel.Value);
    
        a = cell2mat(ana(2,:));
        mu = cell2mat(ana(3,:));
        s = cell2mat(ana(4,:)); 
        F = Fmulpareto2(ana{1}, a, s, mu);
        
        ana(8,1) = num2cell(chiTest(handles.data, F));
        handles.resultstab.Data = ana;
        handles.anaData{handles.corrsel.Value} = ana;
        guidata(hObject, handles);
    end
else
    msgbox('No data, please load a proper file!','Error');
end
