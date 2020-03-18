%% U-Net�ɂ��Z�}���e�B�b�N�Z�O�����e�[�V����

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
trainingData = pixelLabelImageDatastore(imds,pxds)

%% U-Net�̏���
imageSize = [32 32];
numClasses = 2;
lgraph = unetLayers(imageSize, numClasses)
analyzeNetwork(lgraph);

%% �w�K�I�v�V����
opts = trainingOptions('sgdm', ...
    'InitialLearnRate',1e-3, ...
    'MaxEpochs',20, ...
    'Plots','training-progress');

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