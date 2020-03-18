%% ��܂ł̋����̑���
clc;clear;close all;imtool close all;

%% �J����1�E2�́A�����E�O��(���i�E��])�p�����[�^�̓Ǎ���
load('I4_09_4b_params.mat');

%% �J����1�E2�́A�J�����s��i���[���h���W�Ɖ摜��s�N�Z�����W�̊֌W�j�̌v�Z
camMatrix1 = cameraMatrix(cameraParams1, cam1R, cam1T);
camMatrix2 = cameraMatrix(cameraParams2, cam2R, cam2T);

%% ���E�̃J�����̉摜��Ǎ��ݥ�\��
I1 = imread('sceneReconstructionLeft.jpg');
I2 = imread('sceneReconstructionRight.jpg');
figure; imshowpair(I1, I2, 'montage'); truesize;

%% �����Y�c�̏���
I1u = undistortImage(I1, cameraParams1);
I2u = undistortImage(I2, cameraParams2);
figure; imshowpair(I1u, I2u, 'montage'); truesize;

%% �����̉摜����A���ʂ������Ă����̌��o�E�\��
faceDetector = vision.CascadeObjectDetector;
face1 = step(faceDetector,I1)           % (x0, y0, ��, ����)
face2 = step(faceDetector,I2)
I1i = insertShape(I1u,'Rectangle',face1, 'LineWidth', 5);
I2i = insertShape(I2u,'Rectangle',face2, 'LineWidth', 5);
imshowpair(I1i, I2i, 'montage'); shg;

%% ��̒��S�_���W�̌v�Z
center1 = face1(1:2) + face1(3:4)/2
center2 = face2(1:2) + face2(3:4)/2

%% �O���p�����[�^�ŗp�������[���h���W���_����A
%              ��̒��S�ւ̋������v�Z (mm�P��)�F X�EY�EZ
point3d = triangulate(center1, center2, camMatrix1, camMatrix2)

%% �J����1�̌��w���S�̃��[���h���W�l
x0 = -1 * cam1T * cam1R'

%% �J����1�̌��w���S����A��̒��S�ւ̋������v�Z (mm�P��)�F X�EY�EZ
point3d = point3d - x0

%% ���[�g���P�ʂ̒��������֕ϊ�
distanceInMeters = norm(point3d)/1000

%% �I��

















%% (�Q�l)�����ŗp�����J����1�E2�̃J���������E�O���p�����[�^�̐���
load('webcamsSceneReconstruction.mat');   % �X�e���I�J�����p�����[�^�̓Ǎ���
cameraParams1 = stereoParams.CameraParameters1;
cameraParams2 = stereoParams.CameraParameters2;
cam1T = cameraParams1.TranslationVectors(1,:)
cam2T = stereoParams.CameraParameters2.TranslationVectors(1,:)
cam1R = stereoParams.CameraParameters1.RotationMatrices(:,:,1)
cam2R = stereoParams.CameraParameters2.RotationMatrices(:,:,1)

save('I4_09_4b_params.mat', 'cameraParams1', 'cameraParams2', 'cam1T', 'cam2T', 'cam1R', 'cam2R');


%% �J����1�2�̈ʒu��p���̊֌W����A
%  ���ꂼ��̃J�����s��(World���W�Ɖ摜�̍��W�̊֌W)���v�Z����ꍇ
%  �i�����ł�World���W�̌��_���摜1�̃J�����ʒu�A�J�����̕�����Z���̐��ɂ���j
t1 = [0 0 0];      % �J����1��World���W���_�Ɛݒ�i���i�ړ��Ȃ��j
R1 = eye(3);       % �J����1��World���WZ���̐������Ɛݒ�i��]�Ȃ��j
t2 = stereoParams.TranslationOfCamera2    % L=[-95.6895 1.1788 -6.8476]
R2 = stereoParams.RotationOfCamera2
camMatrix1 = cameraMatrix(stereoParams.CameraParameters1, R1, t1);
camMatrix2 = cameraMatrix(stereoParams.CameraParameters2, R2, t2);

%% Copyright 2015 The MathWorks, Inc.
