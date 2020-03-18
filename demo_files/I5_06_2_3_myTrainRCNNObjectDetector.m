%% Train R-CNN (regions with convolutional neural networks) Stop Sign Detector
% �]�ڊw�K���g�p
% Image Processing Toolbox, Computer Vision System Toolbox
% Neural Network Toolbox, Statistics and Machine Learning Toolbox, Parallel Computing Toolbox�̃��C�Z���X���K�v�B�i���ނ̎��s�݂̂ł����l�j
clc;clear;close all;imtool close all;

%% �f�[�^�̓Ǎ���
% 'stopSigns'�F�摜�t�@�C������ROI�A'layers'�F�w�K�ς� Network Layers.
load('rcnnStopSigns.mat', 'stopSigns', 'layers')
layers         % 15�w�F�w�K�ς� Network Layers�̊m�F
% �摜�ւ̃p�X��ݒ�
imDir = [matlabroot, '\toolbox\vision\visiondata\stopSignImages'];
addpath(imDir);

%% �Ǎ���ROI�̊m�F
imageLabeler     % stopSigns�����[�N�X�y�[�X����Ǎ���

%% �g���[�j���O�I�v�V�����̐ݒ�
options = trainingOptions('sgdm', ...
  'MiniBatchSize', 32, ...            % �f�t�H���g��128���牺����iGPU�������g�p�ʒጸ�j
  'InitialLearnRate', 1e-6, ...       % �f�t�H���g�F0.01���炳����iPreTraining���f������FineTuning���邽�߁j
  'MaxEpochs', 10);

%% R-CNN�̃g���[�j���O�̎��s�i���x�����O�ς݉摜�f�[�^�ƁA�w�K�ς݃l�b�g���[�N����́j
%rcnn = trainRCNNObjectDetector(stopSigns, layers, options, 'NegativeOverlapRange', [0 0.3]);
load('I5_06_2_3_myRcnn.mat');      % ���炩���ߊw�K�����l�b�g���[�N��Ǎ���


%% �e�X�g�p�摜�̓Ǎ��݁E�\��
I = imread('stopSignTest.jpg');
figure; imshow(I)

%% ���o�����ʂ��摜��ɕ\���iCPU�ł͎��s���ԕK�v�j
[bbox, score, label] = detect(rcnn, I, 'MiniBatchSize', 32);    % RCNN�Ō��o

I1 = insertObjectAnnotation(I, 'rectangle', bbox, char(label), 'FontSize',18);
figure; imshow(I1)        % �\��

%% �摜�ւ̃p�X������
rmpath(imDir); 

%%










%% R-CNN�̃g���[�j���O�̎��s�i���x�����O�ς݉摜�f�[�^�ƁA�w�K�ς݃l�b�g���[�N����́j
% When the network is a SeriesNetwork, the network layers are automatically adjusted to support
% the number of object classes defined within the groundTruth training data.
% The background is added as an additional class.

% When the network is an array of Layer objects, the network must have a classification layer
% that supports the number of object classes, plus a background class. Use this input type to
% customize the learning rates of each layer. You can also use this input type to resume training
% from a previous session. Resuming the training is useful when the network requires additional
% rounds of fine-tuning, and when you want to train with additional training data.

% ���s�����ۂ̃��b�Z�[�W
% *******************************************************************
% Training an R-CNN Object Detector for the following object classes:
% 
% * stopSign
% 
% Step 1 of 3: Extracting region proposals from 27 training images...done.
% 
% Step 2 of 3: Training a neural network to classify objects in training data...
% 
% |=========================================================================================|
% |     Epoch    |   Iteration  | Time Elapsed |  Mini-batch  |  Mini-batch  | Base Learning|
% |              |              |  (seconds)   |     Loss     |   Accuracy   |     Rate     |
% |=========================================================================================|
% |            3 |           50 |         6.13 |       0.2895 |       96.88% |     0.000001 |
% |            5 |          100 |        10.23 |       0.2443 |       93.75% |     0.000001 |
% |            8 |          150 |        14.50 |       0.0013 |      100.00% |     0.000001 |
% |           10 |          200 |        18.64 |       0.1524 |       96.88% |     0.000001 |
% |=========================================================================================|
% 
% Network training complete.
% 
% Step 3 of 3: Training bounding box regression models for each object class...100.00%...done.
% 
% R-CNN training complete.
% *******************************************************************
% Copyright 2018 The MathWorks, Inc.