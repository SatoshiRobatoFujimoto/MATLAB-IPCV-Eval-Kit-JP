function varargout = thresholding_usbcam(varargin)
% THRESHOLDING1 MATLAB code for thresholding1.fig
%      THRESHOLDING1, by itself, creates a new THRESHOLDING1 or raises the existing
%      singleton*.
%
%      H = THRESHOLDING_USBCAM returns the handle to a new THRESHOLDING1 or the handle to
%      the existing singleton*.
%
%      THRESHOLDING_USBCAM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in THRESHOLDING_USBCAM.M with the given input arguments.
%
%      THRESHOLDING_USBCAM('Property','Value',...) creates a new THRESHOLDING_USBCAM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before thresholding1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to thresholding1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help thresholding_usbcam

% Last Modified by GUIDE v2.5 23-May-2016 16:50:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @thresholding_usbcam_OpeningFcn, ...
                   'gui_OutputFcn',  @thresholding_usbcam_OutputFcn, ...
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


% --- Executes just before thresholding_usbcam is made visible.
function thresholding_usbcam_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to thresholding1 (see VARARGIN)

% Choose default command line output for thresholding1
handles.output = hObject;

%% �����オ�������̏������L�q %%%%%%%%%%%%%%%%%%%%
handles.timer = timer(...                   % �f�t�H���g�ł́ABusyMode�́Adrop
    'ExecutionMode', 'fixedRate', ...       % Run timer repeatedly
    'Period', 0.1, ...                     % Initial period is 1 sec.
    'StartDelay', 0.1, ...
    'TimerFcn', {@capture_frame, hObject});  % ���̏ꍇ�A�^�C�}�[�I�u�W�F�N�g�ƃC�x���g�\���̂�hObject���A�����Ƃ���call�����
                                             % �֐��o���h���ƒǉ��������܂܂��Z���z��Ƃ��Ďw��
handles.vidobj = videoinput('winvideo', 1, 'RGB24_640x480');
handles.src = getselectedsource(handles.vidobj);
src.FrameRate = '10.0000';
triggerconfig(handles.vidobj, 'manual')       % �}�j���A���g���K�ŁAgetsnapshot�̃I�[�o�[�w�b�h���팸
start(handles.vidobj);

axes(handles.axes1);              % �\������Axes��I��
I = getsnapshot(handles.vidobj);
hImage1 = imshow(I);
preview(handles.vidobj, hImage1);      % �o�b�N�O���E���h��Preview���s������

handles.svalue = 128;
axes(handles.axes2);              % �\������Axes��I��
handles.hImage2 = imshow(rgb2gray(I) > handles.svalue); drawnow;       % ����臒l(128)��2�l���摜�\��
% Update handles structure
guidata(hObject, handles);
start(handles.timer);           % �Ō�ɒu��

% UIWAIT makes thresholding_usbcam wait for user response (see UIRESUME)
% uiwait(handles.figure);


% --- Outputs from this function are returned to the command line.
function varargout = thresholding_usbcam_OutputFcn(hObject, eventdata, handles) 
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
handles.svalue = get(hObject,'Value');         % �X���C�_�[�̒l���擾
set(handles.text2, 'string', handles.svalue);  % �X���C�_�[�l��\��
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
stop(handles.timer);
stoppreview(handles.vidobj);
stop(handles.vidobj);

% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Figure (GUI)�����Ƃ��̓�����L�q
stop(handles.timer);
delete(handles.timer);
stop(handles.vidobj);
delete(handles.vidobj);

%% �^�C�}�[�ŁA�������Ŏ��s���铮����L�q
function capture_frame(obj, event, hObject)
% capture_frame�́AGUIDE�ɂ���Đ������ꂽ�R�[���o�b�N�ł͂Ȃ����߁A������handles���܂܂Ȃ��̂ŁAguidata�֐��Ńf�[�^�\���̂̃R�s�[���擾
handles=guidata(hObject);
in = rgb2gray(getsnapshot(handles.vidobj));
I = in > handles.svalue;       % 2�l�摜�𐶐�
%imshow(I, 'Parent', handles.axes1); drawnow;     % 2�l�摜��\�� 
set(handles.hImage2, 'CData', I);drawnow;          % 2�l�摜��\�� 

% Copyright 2018 The MathWorks, Inc.