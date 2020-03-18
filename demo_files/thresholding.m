function varargout = thresholding(varargin)
% THRESHOLDING1 MATLAB code for thresholding1.fig
%      THRESHOLDING1, by itself, creates a new THRESHOLDING1 or raises the existing
%      singleton*.
%
%      H = THRESHOLDING returns the handle to a new THRESHOLDING1 or the handle to
%      the existing singleton*.
%
%      THRESHOLDING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in THRESHOLDING.M with the given input arguments.
%
%      THRESHOLDING('Property','Value',...) creates a new THRESHOLDING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before thresholding1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to thresholding1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help thresholding

% Last Modified by GUIDE v2.5 05-Apr-2013 09:09:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @thresholding_OpeningFcn, ...
                   'gui_OutputFcn',  @thresholding_OutputFcn, ...
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


% --- Executes just before thresholding is made visible.
function thresholding_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to thresholding1 (see VARARGIN)

% Choose default command line output for thresholding1
handles.output = hObject;

%% �����オ�������̏������L�q %%%%%%%%%%%%%%%%%%%%
handles.in      = varargin{1};  % �֐��R�[���̈���������͉摜���擾
imshow(handles.in > 128);       % ����臒l(128)��2�l���摜�\��

% Update handles structure
guidata(hObject, handles);

% figure��������邩�Auiresume�֐������s�����܂ő҂�
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = thresholding_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%% �X���C�_�[�𓮂������ۂ̓�����L�q %%%%%%%%%%%%%%%%%%%
svalue = get(hObject,'Value');         % �X���C�_�[�̒l���擾
set(handles.text2, 'string', svalue);  % �X���C�_�[�l��\��
handles.I = handles.in > svalue;       % 2�l�摜�𐶐�
imshow(handles.I);                     % 2�l�摜��\��
guidata(hObject, handles);     % �ێ����Ă��鐶���摜��Update

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Done �{�^�����������Ƃ��̓�����L�q
% MATLAB�̃��[�N�X�y�[�X�i'base'�j�ցAOUT�Ƃ����ϐ����ŕۑ�
assignin('base', 'OUT', handles.I);

% Copyright 2018 The MathWorks, Inc.