%% �R���s���[�^�r�W�����f���F
% �Z�N�V�������s
clear; close all; clc; imaqreset; clear videooptflowlines;

% �r�f�I�J�����̏����ݒ�(�I�u�W�F�N�g�쐬)   [��s]
%     (Image Acquisition Toolbox�̃V�X�e���I�u�W�F�N�g)
hVideo = imaq.VideoDevice('winvideo', 1, 'RGB24_640x480', 'ReturnedDataType','uint8');

%% �I�v�e�B�J���t���[���o�̃I�u�W�F�N�g���쐬
opticFlow = opticalFlowLK;
plotScaleFactor = 10;

% PC�̉�ʂɃr�f�I��\������r���[���̍쐬
viewer = vision.DeployableVideoPlayer;
%viewer = vision.VideoPlayer;

% �t���[�����[�g�v�Z�p�Ƀ^�C�}�[���X�^�[�g
fps = single(0.0);cnt = 1;tic;

% Stop �{�^���\��
a=true;
sz = get(0,'ScreenSize');
figure('MenuBar','none','Toolbar','none','Position',[20 sz(4)-100 100 70])
uicontrol('Style', 'pushbutton', 'String', 'Stop',...
        'Position', [20 20 80 40],...
        'Callback', 'a=false;');

%% ���͓��摜��1�t���[�����������郋�[�v
while (a)
  frame = step(hVideo);         % �J��������1�t���[���捞
  
  gFrame = rgb2gray(frame);                    % �O���[�X�P�[���֕ϊ�
  flow  = estimateFlow(opticFlow, gFrame);     % �I�v�e�B�J���t���[�v�Z
  lines = videooptflowlines(flow.Vx + i * flow.Vy, plotScaleFactor); % �x�N�g���̎n�_�I�_�̌v�Z (5x5 �s�N�Z������)
  
  % ���ʂ̏㏑��
  frame1 = insertShape(frame, 'Line', lines, 'Color','red', 'SmoothEdges',false);
  frame2 = insertText(frame1, [50 50], ['Running at ' num2str(fps) 'fps'], 'FontSize',30, 'TextColor','green', 'BoxOpacity', 0);
  step(viewer,frame2);                 % ��ʃt���[���X�V
  
   % 20�t���[���̏��v���Ԃ���t���[�����[�g���v�Z
   cnt = cnt + 1;
   if (mod(cnt,20) == 0)
    t = toc;
    fps = single(20/t);
    tic;
   end
   
   drawnow limitrate;      % �{�^���̍X�V���A20 �t���[��/�b�ɐ���
end

clear videooptflowlines;      %to clear persistent variables.
release(hVideo);
release(viewer);

%% [�I��]  Figure���Stop�{�^���ŏI��

%% ���ɉ��p��̌�Љ�







%% [�Q�l]
%����œ�������jhVideo = imaq.VideoDevice�̑���Ɉȉ����g�p
% hVideo = vision.VideoFileReader('visiontraffic.avi', 'PlayCount', inf);

%�ʂ̃I�v�e�B�J���t���[�A���S���Y���̗�
% opticFlow = opticalFlowHS; plotScaleFactor = 200;
% opticFlow = opticalFlowFarneback; plotScaleFactor = 2;


%% Copyright 2013-2014 The MathWorks, Inc.


