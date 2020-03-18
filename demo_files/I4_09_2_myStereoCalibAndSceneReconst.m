%% Stereo Calibration and Scene Reconstruction 
% 1: �X�e���I�J�����̃L�����u���[�V����
% 2: �X�e���I���s�� (Rectification)
% 3: ����(Disparity)�̌v�Z
% 4: Reconstruct the 3-D point cloud
clc;close all;imtool close all;clear;

%% 1: �X�e���I�J�����̃L�����u���[�V���� %%%%%%%%%%%%%%%
% �t�@�C�����̎w��i���E10�����j
leftImages = imageDatastore(fullfile(toolboxdir('vision'),'visiondata', ...
    'calibration','stereo','left'));
rightImages = imageDatastore(fullfile(toolboxdir('vision'),'visiondata', ...
    'calibration','stereo','right'));
imageFileNames1 = leftImages.Files;
imageFileNames2 = rightImages.Files;

%% �ꖇ���Ƃ��đ傫���\��
image1 = imread(imageFileNames1{1});
figure;imshow(image1);

%% �摜�̕\��: ��i�����摜�E���i���E�摜
figure;montage([imageFileNames1 imageFileNames2], 'Size', [2 10]);truesize;   

%% ���E�̑S�摜�Z�b�g����A�p�^�[���̃R�[�i�[�_�����o��ꖇ�ڂ̉摜�̕\��
[imagePoints, boardSize, pairsUsed] = ...
                 detectCheckerboardPoints(imageFileNames1, imageFileNames2);
figure;imshow(insertMarker(image1, imagePoints(:,:,1,1), 'o', 'Color', 'green', 'Size', 5));  %�P���ڂ̍��摜

% �R�[�i�[�_�� �����E�ł̈ʒu(world coordinates) ���v�Z
squareSize = 108; % �P�ʁFmm
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

%% �X�e���I�J�����p�����[�^�̐���(Apps)
[leftFolder,~,~] = fileparts(leftImages.Files{1});
[rightFolder,~,~] = fileparts(rightImages.Files{1});
stereoCameraCalibrator(leftFolder,rightFolder,squareSize);

%% �X�e���I�J�����p�����[�^�̐���
stereoParams = estimateCameraParameters(imagePoints, worldPoints);

%% �L�����u���[�V�����덷�̕\��
figure; showReprojectionErrors(stereoParams);

%% �J�����̊O���p�����[�^�̉����i�J�������Œ�j
figure; showExtrinsics(stereoParams);

%% �J�����̊O���p�����[�^�̉����i�`�F�b�J�[�p�^�[�����Œ�j
figure; showExtrinsics(stereoParams, 'patternCentric');
 
%% 2: �X�e���I���s�� (Rectification) %%%%%%%%%%%%%%%%%%%%%%
% ���E�y�A�̉摜��Ǎ��݁E�\��
I1 = imread(imageFileNames1{1});
I2 = imread(imageFileNames2{1});
figure;imshowpair(I1, I2, 'montage');
%% �d�˂ĕ\��
figure; imshow(stereoAnaglyph(I1, I2), 'InitialMagnification', 50);

%% �L�����u���[�V�����f�[�^��p���A�X�e���I���s���E�\��
[J1, J2] = rectifyStereoImages(I1, I2, stereoParams);
% �\��
figure; imshow(stereoAnaglyph(J1, J2), 'InitialMagnification', 50);

%% ����(�J��������̋����ɔ����)�̌v�Z�E�����}�b�v�̕\���i�߂������j
%     disparityMap�́AJ1��Pixel�ʒu�ɑΉ��BSingle�^�C�v�z��B�ŏ��P��:1/16 Pixels
disparityMap = disparity(J1, J2);
figure; imshow(disparityMap, [0, 64], 'InitialMagnification', 50);

%% �摜�́A3�������W�n�ւ̍č\�z�E�\��
%  �����}�b�v��̊e�_��3���� world ���W�n�̓_�փ}�b�s���O
%  I1�̌��w���S��world���W�n�̌��_
pointCloud = reconstructScene(disparityMap, stereoParams);      %    % 799x1122x3 single: disparityMap�̊e�s�N�Z���ɑ΂��AWorld���W�n��[x,y.z]���v�Z��3���������ɑ}��
pointCloud = pointCloud / 1000;  %�P�ʂ� mm ���� m �֕ϊ�

% �J��������0�`4m���ꂽ�_�̂݃v���b�g
z = pointCloud(:, :, 3);    % �����̂ݒ��o
zdisp = z;
zdisp(z < 0 | z > 4) = NaN;   % 4m���߂��E0m��藣��Ă���_������
pointCloud(:,:,3) = zdisp;
figure;showPointCloud(pointCloud, J1, 'VerticalAxis', 'Y',...
    'VerticalAxisDir', 'Down' );
xlabel('X');ylabel('Y');zlabel('Z');
xlim([-1 3]); ylim([-2 1]);
box on;

%% �ʉ摜�ɑ΂��Ă̍č\����

%% �摜�ǂݍ���
I1 = imread('sceneReconstructionLeft.jpg');
I2 = imread('sceneReconstructionRight.jpg');
figure, imshowpair(I1,I2,'montage');

%% �L�����u���[�V�����f�[�^��p���A�X�e���I���s���E�\��
load('webcamsSceneReconstruction.mat')    %�ۑ����Ă���L�����u���[�V�����f�[�^�p����Ƃ�
[J1, J2] = rectifyStereoImages(I1, I2, stereoParams);
% �\��
figure; imshow(stereoAnaglyph(J1, J2), 'InitialMagnification', 50);

%% ����(�J��������̋����ɔ����)�̌v�Z�E�����}�b�v�̕\���i�߂������j
%     disparityMap�́AJ1��Pixel�ʒu�ɑΉ��BSingle�^�C�v�z��B�ŏ��P��:1/16 Pixels
disparityMap = disparity(rgb2gray(J1), rgb2gray(J2));
figure; imshow(disparityMap, [0, 64], 'InitialMagnification', 50);



%% �摜�́A3�������W�n�ւ̍č\�z�E�\��
%  �����}�b�v��̊e�_��3���� world ���W�n�̓_�փ}�b�s���O
%  I1�̌��w���S��world���W�n�̌��_
pointCloud = reconstructScene(disparityMap, stereoParams);      %    % 799x1122x3 single: disparityMap�̊e�s�N�Z���ɑ΂��AWorld���W�n��[x,y.z]���v�Z��3���������ɑ}��
pointCloud = pointCloud / 1000;  %�P�ʂ� mm ���� m �֕ϊ�

% �J��������3�`7m���ꂽ�_�̂݃v���b�g
z = pointCloud(:, :, 3);    % �����̂ݒ��o
zdisp = z;
zdisp(z < 3 | z > 7) = NaN;   % 3m���߂��E7m��藣��Ă���_������
pointCloud(:,:,3) = zdisp;
figure;showPointCloud(pointCloud, J1, 'VerticalAxis', 'Y',...
    'VerticalAxisDir', 'Down' );
xlabel('X');ylabel('Y');zlabel('Z');
xlim([-1 3]); ylim([-2 1]);
box on;
%%
% Copyright 2014 The MathWorks, Inc.
