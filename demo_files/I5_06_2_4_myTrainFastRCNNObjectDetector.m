%% Fast R-CNN�ɂ�镨�̌��o��̊w�K

%% ������
clear; close all force; clc; rng('default');

%% �w�K�f�[�^�̓ǂݍ���
data = load('rcnnStopSigns.mat', 'stopSigns', 'fastRCNNLayers');
stopSigns = data.stopSigns;
fastRCNNLayers = data.fastRCNNLayers;

%% �摜�t�@�C���̃t���p�X�w��
stopSigns.imageFilename = fullfile(toolboxdir('vision'),'visiondata', ...
    stopSigns.imageFilename);

%% �w�K�I�v�V�����̎w��
options = trainingOptions('sgdm', ...
    'MiniBatchSize', 1, ...
    'InitialLearnRate', 1e-3, ...
    'MaxEpochs', 10);

%% Fast R-CNN���̌��o����w�K
% GPU�̎g�p����
frcnn = trainFastRCNNObjectDetector(stopSigns, fastRCNNLayers , options, ...
    'NegativeOverlapRange', [0 0.1], ...
    'PositiveOverlapRange', [0.7 1], ...
    'SmallestImageDimension', 600);

%% �w�K����Fast R-CNN���̌��o����e�X�g
img = imread('stopSignTest.jpg');
[bbox, score, label] = detect(frcnn, img);

%% ���ʂ�\��
detectedImg = insertShape(img, 'Rectangle', bbox);
figure
imshow(detectedImg)

%%
% Copyright 2018 The MathWorks, Inc.