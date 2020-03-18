clear; close all; clc; imaqreset;

%% USB �J��������r�f�I���捞�ރI�u�W�F�N�g�̒�`
vidobj = imaq.VideoDevice('winvideo', 1, 'RGB24_640x480');
%vidobj = vision.VideoFileReader('visionface.avi');

%% ���̔F���I�u�W�F�N�g�̒�`
%     ��F���p�̃g���[�j���O���ꂽ�f�[�^�͓���
faceDetector = vision.CascadeObjectDetector('MinSize', [40 40]);

%% PC�̉�ʂɃr�f�I��\������r���[���̒�`
viewer = vision.DeployableVideoPlayer;

%% Stop �{�^���\��
a=true;
sz = get(0,'ScreenSize');
figure('MenuBar','none','Toolbar','none','Position',[20 sz(4)-100 100 70])
uicontrol('Style', 'pushbutton', 'String', 'Stop',...
        'Position', [20 20 80 40],'Callback', 'a=false;');

%% �J��������1�t���[�����Ǎ��ݏ���������
while (a) 
    frame = step(vidobj);              % �J��������1��ʎ捞��
    bbox = step(faceDetector, frame);  % ��̌��o
    % ���o������̈ʒu�ɁA�l�p�ƘA�Ԃ�\��
    if ~isempty(bbox)
      frame = insertObjectAnnotation(frame,'rectangle',bbox,[1:size(bbox,1)], 'FontSize',24);
    end
    step(viewer, frame);          % 1��ʕ\��
    
    drawnow limitrate;    % �v�b�V���{�^���̃C�x���g�̊m�F
end

release(vidobj);
release(faceDetector);
release(viewer);

%% 
% Copyright 2014 The MathWorks, Inc.
