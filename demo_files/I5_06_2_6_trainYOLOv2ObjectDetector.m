%% YOLO v2�ɂ�镨�̌��o��̊w�K

%% ������
clear; close all force; clc; rng('default');

%% �ԗ����o��p�̊w�K�f�[�^�Z�b�g�����[�h
data = load('vehicleTrainingData.mat');
trainingData = data.vehicleTrainingData;
dataDir = fullfile(toolboxdir('vision'),'visiondata');
trainingData.imageFilename = fullfile(dataDir,trainingData.imageFilename);

%% YOLO v2�l�b�g���[�N���`
% ���͉摜�T�C�Y
imageSize = [128 128 3];

% �N���X��(����͎ԗ��݂̂Ȃ̂�1��)
numClasses = width(trainingData)-1;

% �A���J�[�{�b�N�X
anchorBoxes = [
    43 59
    18 22
    23 29
    84 109
];

% �w�K�ς݃��f��
baseNetwork = resnet50;

% �������o�̑w���w��
featureLayer = 'activation_40_relu';

% YOLO v2���o�l�b�g���[�N�̍쐬
lgraph = yolov2Layers(imageSize,numClasses,anchorBoxes,baseNetwork,featureLayer);

%% �[�w�w�K�l�b�g���[�N�A�i���C�U�[�Ő����m�F
analyzeNetwork(lgraph)

%% YOLO v2�̊w�K�I�v�V�������w��
options = trainingOptions('sgdm',...
          'InitialLearnRate',0.001,...
          'Verbose',true,...
          'MiniBatchSize',16,...
          'MaxEpochs',30,...
          'Shuffle','every-epoch',...
          'VerboseFrequency',30,...
          'CheckpointPath',tempdir);

%% YOLO v2���̌��o����w�K
[detector,info] = trainYOLOv2ObjectDetector(trainingData,lgraph,options);

%% �����֐��̐��ڂ��m�F
figure
plot(info.TrainingLoss)
grid on
xlabel('�J��Ԃ���')
ylabel('�����֐�')

%% �e�X�g�摜�̓ǂݍ��݂ƌ��o
img = imread('detectcars.png');
[bboxes,scores] = detect(detector,img);
if(~isempty(bboxes))
    img = insertObjectAnnotation(img,'rectangle',bboxes,scores);
end
figure
imshow(img)

%%
% _Copyright 2019 The MathWorks, Inc._
