%% Faster R-CNN�ɂ�镨�̌��o��̊w�K

%% ������
clear; close all force; clc; rng('default');

%% �w�K�f�[�^�̓ǂݍ���
data = load('fasterRCNNVehicleTrainingData.mat');
trainingData = data.vehicleTrainingData;
trainingData.imageFilename = fullfile(toolboxdir('vision'),'visiondata', ...
    trainingData.imageFilename);
layers = data.layers
analyzeNetwork(layers);

%% �w�K�I�v�V�����̎w��
options = trainingOptions('sgdm', ...
    'MiniBatchSize', 1, ...
    'InitialLearnRate', 1e-3, ...
    'MaxEpochs', 5, ...
    'VerboseFrequency', 200);

%% Faster R-CNN���̌��o����w�K
% GPU�̎g�p����
detector = trainFasterRCNNObjectDetector(trainingData, layers, options)

%% �w�K����Faster R-CNN���̌��o����e�X�g
img = imread('highway.png');
[bbox, score, label] = detect(detector, img);

%% ���ʂ�\��
detectedImg = insertShape(img, 'Rectangle', bbox);
figure
imshow(detectedImg)

%%
% Copyright 2018 The MathWorks, Inc.