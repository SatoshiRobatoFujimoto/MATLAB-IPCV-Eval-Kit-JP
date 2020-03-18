clc;close all;imtool close all;clear;

%% ���E�̓��摜��Ǎ��ރI�u�W�F�N�g�̍쐬
readerLeft = vision.VideoFileReader('handshake_left.avi', ...
    'VideoOutputDataType','uint8', 'ImageColorSpace','Intensity', 'PlayCount',inf);
readerRight = vision.VideoFileReader('handshake_right.avi', ...
     'VideoOutputDataType', 'uint8', 'ImageColorSpace','Intensity', 'PlayCount',inf);
%% �����\�����邽�߂̃I�u�W�F�N�g���쐬
playerDisparity = vision.DeployableVideoPlayer();
playerRGB = vision.DeployableVideoPlayer();
%% �l�����o�̃I�u�W�F�N�g���쐬
detector = vision.PeopleDetector('MinSize',[160 80], 'MaxSize',[400 200], 'UseROI',true);  % �l�����o

%% �X�e���I�L�����u���[�V�������ʂ̓Ǎ���
load('handshakeStereoParams.mat');

%% Stop �{�^���\��
a=true;
sz = get(0,'ScreenSize');
figure('MenuBar','none','Toolbar','none','Position',[20 sz(4)-100 100 70])
uicontrol('Style', 'pushbutton', 'String', 'Stop',...
        'Position', [20 20 80 40],...
        'Callback', 'a=false;');

%% ���C�����[�v
badDisparity = -realmax('single');
previousDisparityMap = [];
while (a)
%for i=1:30
    % ���E�̃t���[���̓Ǎ���
    frameLeft = step(readerLeft);
    frameRight = step(readerRight);
    
    % �X�e���I���s��
    [frameLeftRect, frameRightRect] = rectifyStereoImages(frameLeft,...
        frameRight, stereoParams, 'OutputView', 'valid');
    
    % ����(���E�̉摜�̍��F�߂��Ƒ傫��)�v�Z
    disparityMap = disparity(frameLeftRect, frameRightRect, 'DisparityRange',[0 32]);
    
    % ����������ł��Ă��Ȃ������́A�O�t���[���l����
    badIdx = (disparityMap == badDisparity);
    if ~isempty(previousDisparityMap)         %1st�t���[���ł͍s��Ȃ�
      disparityMap(badIdx) = previousDisparityMap(badIdx);
    end
    step(playerDisparity, disparityMap / 64);  %�����摜�̕\�� (�ő�Disparity�l��64)
    previousDisparityMap = disparityMap;      %���t���[���p�Ɍ��݂̎����摜��ۑ�
    
    % 3D�č\�z�Fworld(��)���W�n�֕ϊ��iframeLeft�̌��w���S�����W�̒��S�j
    pointCloud = reconstructScene(disparityMap, stereoParams);
    
    % �l�����o�E���S���W�E���S���`�C���f�b�N�X�̌v�Z
    bboxes = step(detector, frameRightRect, [100,100,460,410]);
    centroids = round(bboxes(:, 1:2) + bboxes(:, 3:4) / 2);
    centroidsIdx = sub2ind(size(disparityMap), centroids(:, 2), centroids(:, 1));
    
    % �l���̒��S���W�̋��������߂�
    Z = pointCloud(:, :, 3);       %������2�����s��𐶐�
    zs = Z(centroidsIdx) / 1000;   %�P�ʂ�mm����m�֕ϊ�
    
    colors = zeros(size(bboxes, 1), 3);
    tooClose = 3;
    colors(zs > tooClose, 2) = 255;  % 3m�ȉ��ł���ΗΐF�g
    colors(zs <= tooClose, 1) = 255; % 3m�ȓ��ł���ΐԐF�g
    
    % �l���̎���ɐF�t�����E�{�b�N�X�E�l���܂ł̋�����\��
    dispFrame = insertObjectAnnotation(frameRightRect, 'rectangle', bboxes,...
        cellstr([num2str(zs) repmat('m',size(zs))]), 'Color', colors, 'FontSize',22);

    % RGB�t���[���̕\��
   step(playerRGB, dispFrame);
    
    % �t���[���̃X�L�b�v
    frameLeft = step(readerLeft);frameRight = step(readerRight);
    frameLeft = step(readerLeft);frameRight = step(readerRight);
    
   drawnow limitrate;             % �v�b�V���{�^���̃C�x���g�̊m�F
end

release(readerLeft);
release(readerRight);
release(playerDisparity);
release(playerRGB);
release(detector);


%% Copyright 2014 The MathWorks, Inc.




