clc;close all;imtool close all;clear;imaqreset;

%% �J��������摜����荞�ނ��߂̃I�u�W�F�N�g�̐���
%vidobj = videoinput('winvideo', 1, 'RGB24_640x480')      % ���ɍ��킹�āAWebcam�̔ԍ���ݒ�
vidobj = videoinput('winvideo', 1, 'RGB24_1920x1080') 
triggerconfig(vidobj, 'manual')       % �}�j���A���g���K�ŁAgetsnapshot�̃I�[�o�[�w�b�h���팸
start(vidobj);

%% �r�f�I��\�����邽�߂̃I�u�W�F�N�g�̐���
viewer = vision.DeployableVideoPlayer;

%% �X�g�b�v�{�^���̕\��
a=true;
sz = get(0,'ScreenSize');
figure('MenuBar','none','Toolbar','none','Position',[20 sz(4)-100 100 70])
uicontrol('Style', 'pushbutton', 'String', 'Stop',...
        'Position', [20 20 80 40],...
        'Callback', 'a=false;');

%% 1�t���[�����ɏ������邽�߂̃��[�v����
while (a)
% for i=1:200 
  I = getsnapshot(vidobj);   %1�t���[���捞�� (uint8)
  step(viewer,I);            %1�t���[���\��

  drawnow limitrate;
end

%%
stop(vidobj);
delete(vidobj);
release(viewer);

%%
%  Copyright 2014 The MathWorks, Inc.


