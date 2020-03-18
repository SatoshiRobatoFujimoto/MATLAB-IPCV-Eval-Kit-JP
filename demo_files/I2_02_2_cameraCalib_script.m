%% �X�N���v�g�ł́A�J�����L�����u���[�V���� %%%%%%%%%%
%      GUI�ōs���Ƃ��́AcameraCalibrator    ���g�p
clear;clc;close all;imtool close all

%% �摜�t�@�C�����̎w��
images = imageDatastore(fullfile(toolboxdir('vision'), 'visiondata', ...
    'calibration', 'mono'));
imFileNames = images.Files;

%% �摜�̕\��
figure;montage(imFileNames, 'Size', [3 5]);truesize

%% �摜���̃`�F�b�J�[�{�[�h�̃p�^�[���̌��o�i�s�K�؂ȉ摜�͎����I�ɏ����j
[imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(imFileNames);
imFileNames = imFileNames(imagesUsed);

%% ��Ƃ��Ĉ�ڂ̉摜�̌��ʂ̕\��
J = insertMarker(imread(imFileNames{1}), imagePoints(:,:,1), 'o', 'Color', 'green', 'Size', 8);
figure;imshow(J);
  
%% �R�[�i�[�_�� �����E�ł̈ʒu(world coordinates) ���v�Z�F�ŏ��̃R�[�i�[=(0,0)
squareSize = 150;  % ���ڈ�̃T�C�Y�i�P�ʁFmm�j
worldPoints = generateCheckerboardPoints(boardSize, squareSize);   % boardSize:�c���̃`�F�b�J�[��

%% �J�����p�����[�^�̐���
cameraParams = estimateCameraParameters(imagePoints, worldPoints);    % �f�t�H���g�̒P�ʂ� mm

%% �L�����u���[�V�����덷�̕\��
figure; showReprojectionErrors(cameraParams, 'BarGraph');

%% �J�����̊O���p�����[�^�̉����i�J�������Œ�j�J�����̒��S�����_
figure; showExtrinsics(cameraParams, 'CameraCentric');

%% �J�����̊O���p�����[�^�̉����i�`�F�b�J�[�p�^�[�����Œ�j�`�F�b�J�[�p�^�[���̒[�����_
figure; showExtrinsics(cameraParams, 'patternCentric');


%%
% Copyright 2014 The MathWorks, Inc.
