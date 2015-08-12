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

% Last Modified by GUIDE v2.5 19-Jun-2015 13:38:17

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
function varargout = anaGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in corrselect.
function corrselect_Callback(~, eventdata, handles)
% hObject    handle to corrselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns corrselect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from corrselect


% --- Executes during object creation, after setting all properties.
function corrselect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to corrselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in uploadbtn.
function uploadbtn_Callback(hObject, eventdata, handles)
% hObject    handle to uploadbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[data, path] = getFile();
handles.filename.String = path;
handles.data = data;
guidata(hObject, handles);


% --- Executes on selection change in scalemethodtext.
function scalemethod_Callback(~, ~, ~)
% hObject    handle to scalemethodtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns scalemethodtext contents as cell array
%        contents{get(hObject,'Value')} returns selected item from scalemethodtext


% --- Executes during object creation, after setting all properties.
function scalemethod_CreateFcn(hObject, ~, ~)
% hObject    handle to scalemethodtext (see GCBO)
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
if(isfield(handles,'data'))
    if(isfield(handles,'anaData'))
        handles.datatable.Data = handles.anaData{handles.corrselect.Value}{handles.scalemethod.Value};
    else
        handles.anaData = analyze(handles.data);
        guidata(hObject, handles);
         handles.datatable.Data = handles.anaData{handles.corrselect.Value}{handles.scalemethod.Value};
    end
else
    msgbox('No data, please load a proper file!','Error');
end
