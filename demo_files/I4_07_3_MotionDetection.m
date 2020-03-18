%% ���撆�̓����Ă���̈�����o
clc;clear;close all;imtool close all;

%% �����Ǎ��ނ��߂̃I�u�W�F�N�g�̐���
videoSource = vision.VideoFileReader('atrium.mp4');

%% �����Ă���O�i�����o����I�u�W�F�N�g�𐶐�
  detector = vision.ForegroundDetector('NumGaussians', 3, ...
       'NumTrainingFrames', 40, 'MinimumBackgroundRatio', 0.7);

%% �̈�̍��W�擾�p�I�u�W�F�N�g�̐��� �i400�s�N�Z���ȏ�̂��́j
blob = vision.BlobAnalysis( 'AreaOutputPort',false, ...
          'CentroidOutputPort',false, 'BoundingBoxOutputPort',true, ...
          'MinimumBlobArea',400);

%% ����\���p�̃I�u�W�F�N�g�̐���
sz = get(0,'ScreenSize');
videoPlayer = vision.VideoPlayer('Position', [150,sz(4)-490,1000,400]);

%% Stop �{�^���\��
a=true;
sz = get(0,'ScreenSize');
figure('MenuBar','none','Toolbar','none','Position',[20 sz(4)-100 100 70])
uicontrol('Style', 'pushbutton', 'String', 'Stop',...
        'Position', [20 20 80 40], 'Callback', 'a=false;');

while ~isDone(videoSource) && a
  % 1�t���[���擾
  frame  = step(videoSource);       % 1�t���[���擾

  % �����Ă���̈�̌��o��g��}��
  fgMask = step(detector, frame);   % �����Ă���̈�̌��o
  bbox   = step(blob, fgMask);      % �̈�̍��W���擾
  out = insertShape(frame, 'Rectangle', bbox); % �l�p�g��}��
  
  % ���ʂ̕\��
  step(videoPlayer, [repmat(fgMask,[1,1,3]) out]); 
end
%%
release(videoPlayer);
release(videoSource);

%% Copyright 2016 The MathWorks, Inc.
