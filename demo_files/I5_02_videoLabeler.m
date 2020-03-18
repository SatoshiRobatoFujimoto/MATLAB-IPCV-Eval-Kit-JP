%% Video Labeler�ɂ�郉�x�����O�ƌ��o��w�K

%% ������
clc;clear;close all;imtool close all; rng('default');

%% �\�߃��x�����O����groundTruth�I�u�W�F�N�g�̃p�X���C��
d = load('I5_02_videoLabeler_GroundTruth.mat');
gTruth = d.gTruth;
oldPathDataSource = "C:\Program Files\MATLAB\R2018b\toolbox\vision\visiondata";
newPathDataSource= fullfile(toolboxdir('vision'),"visiondata");
alterPaths = [oldPathDataSource newPathDataSource];
unresolvedPaths = changeFilePaths(gTruth,alterPaths);

%% Video Labeler ���N���F���L�R�}���h�������̓A�v���^�u����
videoLabeler('visiontraffic.avi')

% ROI���x���̒�`�v�Z�N�V�����́u�V����ROI���x���̒�`�v�Łucar�v��Rectangle�Ƃ��č��
% �e�摜�Ŏԗ����h���b�O�ň͂�
% ���x�����O�ς݃f�[�^����荞�ޏꍇ�́u���x�����C���|�[�g�v���u���[�N�X�y�[�X����v��
%�@gTruth��I��

b%% groundTruth�I�u�W�F�N�g����w�K�f�[�^����
imDir = 'I5_02_trainingImages';
[~,~,~] = mkdir(imDir);
trainingData  = objectDetectorTrainingData(d.gTruth,'WriteLocation',imDir);

%% �e�X�g�摜1���Ǝc��̊w�K�摜�ɕ�����
testData = trainingData(15,:);
trainingData(15,:) = [];

%% �w�K�I�v�V�����̎w��
options = trainingOptions('sgdm', ...
    'MiniBatchSize', 1, ...
    'InitialLearnRate', 1e-3, ...
    'MaxEpochs', 3, ...
    'VerboseFrequency', 200);

%% Faster R-CNN���̌��o����w�K
% GPU�̎g�p����
detector = trainFasterRCNNObjectDetector(trainingData, 'alexnet', options)

%% �w�K����Faster R-CNN���̌��o����e�X�g
% �e�X�g�摜�ǂݍ���
img = imread(testData.imageFilename{1});
% ���̌��o
[bboxes, scores, labels] = detect(detector, img);
% ���ʂ�\��
detectedImg = insertObjectAnnotation(img, 'Rectangle', bboxes, cellstr(labels));
figure, imshow(detectedImg)

%%
% Copyright 2018 The MathWorks, Inc.