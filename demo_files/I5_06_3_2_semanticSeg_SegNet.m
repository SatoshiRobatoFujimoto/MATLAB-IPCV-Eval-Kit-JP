%% SegNet�ɂ��Z�}���e�B�b�N�Z�O�����e�[�V����

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

%% SegNet�̏���
imageSize = [32 32];
numClasses = 2;
lgraph = segnetLayers(imageSize,numClasses,2)

%% �w�K�I�v�V����
opts = trainingOptions('sgdm', ...
    'InitialLearnRate',1e-3, ...
    'MaxEpochs',20, ...
    'MiniBatchSize',64,...
    'Plots','training-progress');

%% ���x���̕p�x����d�݌v�Z
tbl = countEachLabel(trainingData)
totalNumberOfPixels = sum(tbl.PixelCount);
frequency = tbl.PixelCount / totalNumberOfPixels;
classWeights = 1./frequency
pxLayer = pixelClassificationLayer('Name','labels','ClassNames',tbl.Name,'ClassWeights',classWeights)
lgraph = removeLayers(lgraph,'pixelLabels');
lgraph = addLayers(lgraph, pxLayer);
lgraph = connectLayers(lgraph,'softmax','labels');
analyzeNetwork(lgraph);

%% �w�K
net = trainNetwork(trainingData,lgraph,opts);

%% �e�X�g�摜�ŕ]��
testImage = imread('triangleTest.jpg');
imshow(testImage)
C = semanticseg(testImage,net);
B = labeloverlay(testImage,C);
imshow(B)

%%
% Copyright 2018 The MathWorks, Inc.