clc;close all;imtool close all;clear;

%% ���E�̓��摜��Ǎ��ރI�u�W�F�N�g�̍쐬
readerLeft = vision.VideoFileReader('handshake_left.avi', ...
                              'VideoOutputDataType','uint8');
readerRight = vision.VideoFileReader('handshake_right.avi', ...
                              'VideoOutputDataType','uint8');
%% �����\�����邽�߂̃I�u�W�F�N�g���쐬
player3D    = vision.DeployableVideoPlayer();

%% �X�e���I�L�����u���[�V�������ʂ̓Ǎ���
load('handshakeStereoParams.mat');

%% Stop �{�^���\��
a=true;
sz = get(0,'ScreenSize');
figure('MenuBar','none','Toolbar','none','Position',[20 sz(4)-100 100 70])
uicontrol('Style', 'pushbutton', 'String', 'Stop',...
        'Position', [20 20 80 40],...
        'Callback', 'a=false;');
    
%% �����͉摜�̊m�F
while ~isDone(readerLeft) && (a)
    % ���E�̃t���[���̓Ǎ���
    frameLeft = step(readerLeft);
    frameRight = step(readerRight);
    
    step(player3D, [frameLeft, repmat(0, [480 10 3]), frameRight]);

    pause(0.05)
end
a = true;
release(readerLeft);
release(readerRight);
release(player3D);

%% ���C�����[�v
a = true;
readerLeft.PlayCount  = inf;
readerRight.PlayCount = inf;
while (a)
%for i=1:30
    % ���E�̃t���[���̓Ǎ���
    frameLeft = step(readerLeft);
    frameRight = step(readerRight);
    
    % �X�e���I���s��
    [frameLeftRect, frameRightRect] = rectifyStereoImages(frameLeft,...
        frameRight, stereoParams, 'OutputView', 'valid');
    % 3D�t���[���̕\��
    step(player3D, stereoAnaglyph(frameLeftRect, frameRightRect));

    pause(0.04)
end

release(readerLeft);
release(readerRight);
release(player3D);


%% Copyright 2014 The MathWorks, Inc.



