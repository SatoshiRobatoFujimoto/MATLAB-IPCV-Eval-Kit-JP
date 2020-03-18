%% ���჌���Y�ŎB�e�����摜�̘c�␳
clear;clc;close all;imtool close all

%% �J�����L�����u���[�V�����p�̉摜�̊m�F
imageFolder = [toolboxdir('vision'),'\visiondata\calibration\gopro'];
winopen(imageFolder);

%% �A�v���P�[�V�����ɂ�鋛�჌���Y�c����(R2018a)
squareSize = 29;      % ���ڈ�̃T�C�Y�i�P�ʁFmm�j
cameraCalibrator(imageFolder,squareSize);
% �J�������f�����u����v�ɐݒ肵�āu�L�����u���[�V�����v�����s

%% �J�����p�����[�^����p�́A�L�����u���[�V�����p�^�[���̉摜�w��
images = imageDatastore(imageFolder);
figure; montage(images.Files)

%% �摜���̃`�F�b�J�[�{�[�h�̃p�^�[���̌��o
[imagePoints, boardSize] = detectCheckerboardPoints(images.Files);

%% �R�[�i�[�_�� �����E�ł̈ʒu(world coordinates) ���v�Z�F�ŏ��̃R�[�i�[=(0,0)
squareSize = 29;      % ���ڈ�̃T�C�Y�i�P�ʁFmm�j
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

%% �J�����p�����[�^�̐���
I = readimage(images,1); imageSize = [size(I,1),size(I,2)];  % �摜�T�C�Y�̎擾
params = estimateFisheyeParameters(imagePoints, worldPoints, imageSize);

%% ���肵���O���p�����[�^�̉���
figure; showExtrinsics(params);

%% �c�␳�E���ʂ̕\��
J1 = undistortFisheyeImage(I, params.Intrinsics,'OutputView','full');
figure; imshowpair(I,J1,'montage'); truesize;

%% ���ʂ̕\���i���͂̏������A���̉摜�Ɠ��T�C�Y�ցj
J2 = undistortFisheyeImage(I,params.Intrinsics);
figure; imshowpair(I,J2,'montage'); truesize;

%%
% Copyright 2014 The MathWorks, Inc.
