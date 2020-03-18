%% DeepLab v3+�ɂ��Z�}���e�B�b�N�Z�O�����e�[�V����

%% ������
clear; close all ;clc; rng('default');

%% �w�K�f�[�^�̏���
dataSetDir = fullfile(toolboxdir('vision'),'visiondata','triangleImages');
imageDir = fullfile(dataSetDir,'trainingImages');
imds = imageDatastore(imageDir);

%% ���x���f�[�^�̏���
labelDir = fullfile(dataSetDir, 'trainingLabels');
classNames = ["triangle","background"];
labelIDs   = [255 0];
pxds = pixelLabelDatastore(labelDir,classNames,labelIDs);

%% DeepLab v3+�l�b�g���[�N�̏���
imageSize = [256 256];
numClasses = numel(classNames);
lgraph = deeplabv3plusLayers(imageSize,numClasses,'resnet18');

%% �w�K�f�[�^�̏���
pximds = pixelLabelImageDatastore(imds,pxds,'OutputSize',imageSize,...
    'ColorPreprocessing','gray2rgb');

%% �w�K�I�v�V����
opts = trainingOptions('sgdm',...
    'MiniBatchSize',8,...
    'MaxEpochs',3,...
    'Plots','training-progress');

%% �w�K
net = trainNetwork(pximds,lgraph,opts);

%% �e�X�g�摜�ŕ]��
I = imread('triangleTest.jpg');
I = imresize(I,'Scale',imageSize./32);
C = semanticseg(I,net);
B = labeloverlay(I,C);
figure
imshow(B)

%%
% Copyright 2019 The MathWorks, Inc.