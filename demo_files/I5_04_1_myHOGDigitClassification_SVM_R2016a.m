%% HOG (Histogram of Oriented Gradient) ������ ��
%  SVM (Support Vector Machine) classifier ���g�����i2�N���X���ށj�A�菑�������̎���
clear;clc;close all;imtool close all

%% �g���[�j���O�摜�̏���
% �g���[�j���O�摜�i101��x10������j�ƃe�X�g�摜�i12��x10������j�ւ̐�΃p�X��ݒ�
pathData = [toolboxdir('vision'), '\visiondata\digits']
trainSet = imageDatastore([pathData,'\synthetic'  ], 'LabelSource','foldernames', 'IncludeSubfolders',true)
testSet  = imageDatastore([pathData,'\handwritten'], 'LabelSource','foldernames', 'IncludeSubfolders',true);

%% �g���[�j���O�摜��̕\��:�ꖇ�̂݁i����  2�̊w�K�p�F4���ځj    read��1���̉摜�̂ݓǍ��߂�
figure;imshow(readimage(trainSet, 206));

%% �g���[�j���O�ppos�摜�̕\��
figure;montage(trainSet.Files(trainSet.Labels == '2'), 'Size', [ 6 17]);title('pos�摜','FontSize',14); % pos�摜
%% �g���[�j���O�pneg�摜�̕\��
figure;montage(trainSet.Files(trainSet.Labels ~= '2'), 'Size', [23 40]);title('neg�摜','FontSize',14); % neg�摜
       
%% �S�e�X�g�摜�������^�[�W���\�� (12�� x 10������F�e�菑����������2������)
figure; montage(testSet.Files, 'Size', [10,12]);

%% �O�������ʂ̗� (����2�̗�)�F�����̎��s�E�\��
%    �O�����p�i������l���j�̊֐��F�m�C�Y�������A�����x�N�g���̉��P
exTrainImage  = readimage(trainSet, 206);     % �摜�T�C�Y:16x16 pixels
img = imbinarize(rgb2gray(exTrainImage));

figure;
subplot(1,2,1); imshow(exTrainImage);
subplot(1,2,2); imshow(img);

%% HOG �����ʃp�����[�^(CellSize)�̍œK�� (�摜�T�C�Y:16x16 pixels)

% HOG�����ʂ̒��o (������Bin��9��)�@(Block�T�C�Y��2x2�Z���ABlock�I�[�o�[���b�v��1�Z��)
%    �Z�����ɁA�ePixel�̃G�b�W�����̃q�X�g�O�������쐬�i9�����j
[hog_2x2, vis2x2] = extractHOGFeatures(img,'CellSize',[2 2]);  % �Z���T�C�Y:2x2pixel�A�Z����:8x8�Ablock�ʒu:7x7=49�A�����x�N�g���̒���:9����x(2x2�Z��/�u���b�N)x49=1764����
[hog_4x4, vis4x4] = extractHOGFeatures(img,'CellSize',[4 4]);  % �Z���T�C�Y:4x4pixel�A�Z����:4x4�Ablock�ʒu:3x3= 9�A�����x�N�g���̒����F9����x(2x2�Z��/�u���b�N)x 9= 324����
[hog_8x8, vis8x8] = extractHOGFeatures(img,'CellSize',[8 8]);  % �Z���T�C�Y:8x8pixel�A�Z����:2x2�Ablock�ʒu:1x1= 1�A�����x�N�g���̒����F9����x(2x2�Z��/�u���b�N)   =  36����

% �e�Z�����ɁA���o�����q�X�g�O�����̕\���i�x�N�g���́A"�P�x�̌��z"�̐����j�i�Z�����傫���ƁA�͗l�̈ʒu��񂪌����j
figure; subplot(2,3,1:3); imshow(img);   % ���摜
subplot(2,3,4); plot(vis2x2); 
title({'CellSize = [2 2]'; ['Feature length = ' num2str(length(hog_2x2))]});
subplot(2,3,5); plot(vis4x4); 
title({'CellSize = [4 4]'; ['Feature length = ' num2str(length(hog_4x4))]});
subplot(2,3,6); plot(vis8x8); 
title({'CellSize = [8 8]'; ['Feature length = ' num2str(length(hog_8x8))]});

%% 4x4�̃Z���T�C�Y���g�p (324�����x�N�g��)
cellSize = [4 4];
hogFeatureSize = length(hog_4x4);

%% [SVM���ފ�̊w�K] (������2)�Ffitcsvm() �֐����g�p
% trainingFeatures ���i�[����z������炩���ߍ쐬
trainingFeatures  = zeros(200,hogFeatureSize,'single');

% �S�w�K�p�摜(1010��)����HOG�����ʂ𒊏o (Pos��Neg����)
for i = 1:size(trainSet.Labels,1)
  img = readimage(trainSet, i);  %�g���[�j���O�摜�̓Ǎ���
  img = imbinarize(rgb2gray(img)); % ��l��
  trainingFeatures(i,:) = extractHOGFeatures(img,'CellSize',cellSize); %�����ʂ̒��o
end
trainingLabels = (trainSet.Labels == '2');   % ���x���̐���

% �T�|�[�g �x�N�g�� �}�V���̕��ފ�̊w�K 
svmModel = fitcsvm(trainingFeatures, trainingLabels)

%svmModel = fitcsvm(trainingFeatures, trainingLabels, 'KernelFunction','polynomial', 'KernelOffset', 1, 'KernelScale','auto', 'Standardize','on')

%% [����] �쐬�������ފ�Ŏ菑������(120��)����2�����ʥ�\���Fpredict()
Ir = zeros([16,16,3,120], 'uint8');      % ���ʂ��i�[����z��
cntTrue = 0;
for i = 1:size(testSet.Labels,1)     % �e�������Ƃ�12���̎菑������
  img = readimage(testSet, i);
  BW  = imbinarize(img);     % 2�l��

  testFeatures = extractHOGFeatures(BW,'CellSize',cellSize);
  predictedLabels = predict(svmModel, testFeatures);           % testFeature ��z��ɂ��āA���Ƃł܂Ƃ߂Ĕ������
  % 2�ƔF���������̂ɐԊۂ�}��
  if predictedLabels
    img = insertShape(img,'Circle',[8,8,4],'Color','red');
    cntTrue = cntTrue+1;
  end
    Ir(:,:,:,i)=img;
end

% ���ʂ̕\��     ����'2'�p�̕��ފ�Ŋe�菑���������e�X�g��������
figure;montage(Ir, 'Size', [10,12]);  title(['Correct Prediction: ' num2str(cntTrue)]);
%%












%% ���ފw�K��A�v���P�[�V�����̎g�p
dataTable = table(trainingFeatures, trainingLabels, 'VariableNames',{'features', 'label'});     % 1x324 �̓����x�N�g�� + ���x��   ���A200�s
openvar('dataTable');
classificationLearner
  % �V�K�Z�b�V���� => ���[�N�X�y�[�X����
  % �f�[�^�̃C���|�[�g�F(�f�t�H���g�́A'���ϐ��Ƃ��Ďg�p' ��I��)
  % ��ԉ����A"����"�ɂȂ��Ă���̂��m�F
  %    �\���q�F�w�K�p�̓����ʁi�s:�f�[�^�� x ��:������ �̐��l�z��j
  %    ���� �F ���t�f�[�^�icategorical array, cell array of strings, character array, logical, or numeric �̗�x�N�g���j
  % ���`SVM��I���� -> �w�K�{�^��
  % Confusion Matrix�̕\��
  %   ��������FN�̃O���[�v�ɕ������A#1����菜��#2~#N-1�̃O���[�v�Ŋw�K��#1�Ńe�X�g�A����#2����菜���A�A�A�A�A���J��Ԃ�
  %   �z�[���h�A�E�g����F�ꕔ�̃f�[�^���A�e�X�g�p�̃f�[�^�Ƃ��Ď�菜�����f�[�^�Ŋw�K�F�e�X�g�p�f�[�^�ɑ΂���藦��]��
  %   ����Ȃ�          �F�S�Ă̊w�K�f�[�^�Ŋw�K�F�p�����S�Ă̊w�K�f�[�^�Ō�藦���v�Z
  % ROC (receiver operating characteristic curve) �Ȑ��\��
  
  % ���f���̃G�N�X�|�[�g�F trainedClassifier
  %      �R���p�N�g���f���F�w�K�f�[�^�̓G�N�X�|�[�g���Ȃ�

  % SVM�F�f�[�^�̕W�����̃f�t�H���g���Afitcsvm��false�A���ފw�K���true


%% [����] �A�v���P�[�V�����ō쐬�������ފ�Ŏ菑������(120��)����2�����ʥ�\���F
Ir = zeros([16,16,3,120], 'uint8');      % ���ʂ��i�[����z��
for i = 1:size(testSet.Labels,1)     % �e�������Ƃ�12���̎菑������
  img = readimage(testSet, i);
  BW  = imbinarize(rgb2gray(img));     % 2�l��

  features = extractHOGFeatures(BW,'CellSize',cellSize);
  predictedLabels = trainedClassifier.predictFcn(table(features));    % testFeature ��z��ɂ��āA���Ƃł܂Ƃ߂Ĕ������
  % 2�ƔF���������̂ɐԊۂ�}��
  if predictedLabels
    img = insertShape(img,'Circle',[8,8,4],'Color','red');
  end
    Ir(:,:,:,i)=img;
end
% ���ʂ̕\��     ����'2'�p�̕��ފ�Ŋe�菑���������e�X�g��������
figure;montage(Ir, 'Size', [10,12]);
  

% ClassificationPartitionedModel �������蕪�ފ�̐���
CVSVMModel = crossval(svmModel);
classLoss = kfoldLoss(CVSVMModel)    % �W�{�O�딻�ʗ��𐄒肵�܂��B
  
% Copyright 2013-2014 The MathWorks, Inc.
% �摜�f�[�^�Z�b�g
% �g���[�j���O�摜�FinsertText�֐��Ŏ����쐬 (���͂ɕʂ̐����L��)
% �e�X�g�摜�F�菑���̉摜���g�p
