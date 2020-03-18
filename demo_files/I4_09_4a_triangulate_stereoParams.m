%% ��܂ł̋����̑���
%    �X�e���I�p�����[�^�A���E�̉摜�̑Ή��_�����m�̏ꍇ
clc;clear;close all;imtool close all;

%%  �X�e���I�J�����p�����[�^�̓Ǎ���
load('webcamsSceneReconstruction.mat');

%% ���E�̃J�����̉摜��Ǎ��ݥ�\��
I1 = imread('sceneReconstructionLeft.jpg');
I2 = imread('sceneReconstructionRight.jpg');
figure; imshowpair(I1, I2, 'montage'); truesize;

%% �����Y�c�̏���
I1u = undistortImage(I1, stereoParams.CameraParameters1);     % �f�t�H���g�ݒ�ł�newOrigin=[0 0], i.e., ���S�͕s��
I2u = undistortImage(I2, stereoParams.CameraParameters2);     % �f�t�H���g�ݒ�ł�newOrigin=[0 0], i.e., ���S�͕s��
figure; imshowpair(I1u, I2u, 'montage'); truesize;

%% �����̉摜����A���ʂ������Ă����̌��o�E�\��
faceDetector = vision.CascadeObjectDetector;
face1 = step(faceDetector,I1u)           % (x0, y0, ��, ����)
face2 = step(faceDetector,I2u)
I1i = insertShape(I1u,'Rectangle',face1, 'LineWidth', 5);
I2i = insertShape(I2u,'Rectangle',face2, 'LineWidth', 5);
imshowpair(I1i, I2i, 'montage'); shg;

%% ��̒��S�_���W�̌v�Z
center1 = face1(1:2) + face1(3:4)/2
center2 = face2(1:2) + face2(3:4)/2

%% �J�����P�̌��w���S����A��̒��S��X�Y�Z�����̋������v�Z (mm�P��)
point3d = triangulate(center1, center2, stereoParams)

%% ���[�g���P�ʂ̒��������֕ϊ�
distanceInMeters = norm(point3d)/1000

%% Copyright 2015 The MathWorks, Inc.
