%% FCN(Fully Convolutional Network)�ɂ��Z�}���e�B�b�N�Z�O�����e�[�V����

%% ������
clear; close all ;clc; rng('default');

%% �w�K�f�[�^�̏���
dataSetDir = fullfile(toolboxdir('vision'),'visiondata','triangleImages');
imageDir = fullfile(dataSetDir,'trainingImages');
imds = imageDatastore(imageDir);

%% ���x���f�[�^�̏���
classNames = ["triangle","background"];
labelIDs   = [255 0];
labelDir = fullfile(dataSetDir,'trainingLabels');
pxds = pixelLabelDatastore(labelDir,classNames,labelIDs);

%% �w�K�f�[�^�ƃ��x���f�[�^�̉���
I = read(imds);
C = read(pxds);

I = imresize(I,5);
L = imresize(uint8(C),5);
figure, imshowpair(I,L,'montage')

%% �w�K�f�[�^�̏���
augmenter = imageDataAugmenter('RandRotation',[-10 10],'RandXReflection',true)
trainingData = pixelLabelImageDatastore(imds,pxds,'DataAugmentation',augmenter)

%% FCN�̏���
numFilters = 64;
filterSize = 3;
numClasses = 2;
layers = [
    imageInputLayer([32 32 1])
    convolution2dLayer(filterSize,numFilters,'Padding',1)
    reluLayer()
    maxPooling2dLayer(2,'Stride',2)
    convolution2dLayer(filterSize,numFilters,'Padding',1)
    reluLayer()
    transposedConv2dLayer(4,numFilters,'Stride',2,'Cropping',1);
    convolution2dLayer(1,numClasses);
    softmaxLayer()
    pixelClassificationLayer()
    ]

% VGG16�x�[�X��FCN���\�z����fcnLayers���g�p�\
% (�������A�摜��224x224�ȏ�K�v)
% layers = fcnLayers([224 224],numClasses);

%% �w�K�I�v�V����
opts = trainingOptions('sgdm', ...
    'InitialLearnRate',1e-3, ...
    'MaxEpochs',100, ...
    'MiniBatchSize',64,...
    'Plots','training-progress');

%% ���x���̕p�x����d�݌v�Z
tbl = countEachLabel(trainingData)
totalNumberOfPixels = sum(tbl.PixelCount);
frequency = tbl.PixelCount / totalNumberOfPixels;
classWeights = 1./frequency
layers(end) = pixelClassificationLayer('Classes',tbl.Name,'ClassWeights',classWeights);

%% �w�K
net = trainNetwork(trainingData,layers,opts);

%% �e�X�g�摜�ŕ]��
testImage = imread('triangleTest.jpg');
imshow(testImage)
C = semanticseg(testImage,net);
B = labeloverlay(testImage,C);
imshow(B)

%%
% Copyright 2018 The MathWorks, Inc.