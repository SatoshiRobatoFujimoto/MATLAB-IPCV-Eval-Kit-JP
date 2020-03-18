%% �L�����u���[�V�����ςݒP��J�����ɂ��,
%        �J�������Ȉʒu��p������A�Ώە��̂�3�����ʒu����
%   - ���[���h���W�Ɖ摜���W�����m�̕����̓_���g�p
%   - �Ώە��̂́A���[���h���W�n��Z=0��ɕK�v
clc;clear;close all;imtool close all;

%% ���炩���߁A�g�p�̃J�����ŃJ�����L�����u���[�V�����������ʂ�Ǎ���
load('I4_09_1_cameraParams.mat');

%% ����Ώۂ̕��̂̉摜��Ǎ��ݥ�\��
imOrig = imread([matlabroot '\toolbox\vision\visiondata\calibration\slr\image9.jpg']);
figure; imshow(imOrig);

%% �J�����p�����[�^��p���A�����Y�c������ => ���߂������͉̂摜���W(2455, 1060)
[im, newOrigin] = undistortImage(imOrig, cameraParams);      % �f�t�H���g�ݒ�ł�newOrigin=[0 0], i.e., ���S�͕s��
imtool(im);
imagePoints1 = [2455, 1060]        % ��O�̃R�C���̒��S���W

%% �O���p�����[�^�𐄒�
% �摜���̃`�F�b�J�[�{�[�h�̌�_�����o
[imagePoints, boardSize] = detectCheckerboardPoints(im);
% ���[���h���W�n�ł́A�`�F�b�J�[�p�^�[���̌�_�̗��z���W���v�Z
squareSize = 29;      % 29mm
worldPoints = generateCheckerboardPoints(boardSize, squareSize);
% �O���p�����[�^�̐���i�����Y�c�̖����摜��̓_���W���g�p�j
[R, t] = extrinsics(imagePoints, worldPoints, cameraParams)

%% �J�����̌��w���S�́A���[���h���W�ł̈ʒu��p�����v�Z
Location    = -t * R'        % [1x3]
Orientation = R'             % [3x3]

%% �R�C���̒��S�_�́A���[���h���W�𐄒�i���[���h���W�nZ=0���ʏ��XY���W�j
worldPoints1 = pointsToWorld(cameraParams, R, t, imagePoints1)

%% �J��������R�C�����S�_�܂ł̋����̌v�Z
distanceToCamera = norm([worldPoints1 0] + t*R');

%% �I��















%% [�Q�l] I4_09_1_cameraParams.mat�̐���
%% �J�����L�����u���[�V�����p�̉摜�̏���
numImages = 9;
files = cell(1, numImages);
for i = 1:numImages
    files{i} = fullfile(matlabroot, 'toolbox', 'vision', 'visiondata', ...
        'calibration', 'slr', sprintf('image%d.jpg', i));
end

%% �J�����L�����u���[�V����
% �`�F�b�J�[�{�[�h�̉摜����A�`�F�b�J�[�̌�_�����o
[imagePoints, boardSize] = detectCheckerboardPoints(files);

% �`�F�b�J�[�p�^�[���̃��[���h���W�𐶐�
squareSize = 29; % 29mm
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

% �J�����L�����u���[�V�����̎��s
cameraParams = estimateCameraParameters(imagePoints, worldPoints);
save('I4_09_1_cameraParams.mat', 'cameraParams');
  
  
%%   Copyright 2013-2014 The MathWorks, Inc.

