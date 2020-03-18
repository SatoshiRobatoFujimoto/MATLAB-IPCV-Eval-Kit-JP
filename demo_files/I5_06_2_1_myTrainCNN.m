%% �􍞂݃j���[�����l�b�g���[�N�̃g���[�j���O *****************************************
% Computer Vision System Toolbox, Image Processing Toolbox
% Deep Learning Toolbox,Statistics and Machine Learning Toolbox,
% Parallel Computing Toolbox, CUDA-capable GPU card�iComputeCapability3.0�ȏ�j

%% ������
clear;close all;imtool close all;clc;rng('default')

%% �摜�f�[�^�̐ݒ�i�����������_���ȃA�t�B���ϊ��ŕό`�������̂��g�p�j
%     28x28�s�N�Z����8�r�b�g�O���[�X�N�[���摜��10000��
%     �f�B���N�g���������x���� (10000x1�̃J�e�S���J���z��)
digitDatasetPath = fullfile(matlabroot,'toolbox','nnet','nndemos', ...
    'nndatasets','DigitDataset');
digitData = imageDatastore(digitDatasetPath,...
        'IncludeSubfolders',true, 'LabelSource','foldernames')

%% �摜�̈ꕔ��\���i500���j
figure; montage(digitData.Files(1:20:end)); truesize;

%% �e�N���X�̉摜���̊m�F
digitData.countEachLabel

%% �w�K�p(75%)�ƌ��ؗp(25%)�̃f�[�^�Z�b�g�ɕ����i�e�J�e�S�����ɔ��X�j
[trainDigitData, testDigitData] = splitEachLabel(digitData, 0.75, 'randomize')
trainDigitData.countEachLabel

%% Layer�N���X�iCNN�p�̃N���X�j���g�p���ACNN�̍\�����`
%         DropOut�w��p����ꍇ�F��) dropoutLayer(0.4) % �w�K�f�[�^���ƂɁA���̓m�[�h��40%�������_����0�ɂ��ĉߊw�K��h�~
layers = [imageInputLayer([28 28 1]);       % ���͉摜�T�C�Y�F28x28x1�A���͂Ŗ��邳�̐��K��:0�Z���^�[
          convolution2dLayer(5,20);         % 5x5x1�̃t�B���^��20�Z�b�g(�}�b�v) (�o�́F24x24x20) ���͂̃p�f�B���O�Ȃ�
          reluLayer();                      % ReLU(Rectified Linear Unit)�������֐��w
          crossChannelNormalizationLayer(5, 'K',1);   % 5�`�����l���͈̔͂ŁA�`���l���Ԃ̐��K���i�p�����[�^�͘_���Q�Ɓj
          maxPooling2dLayer(2,'Stride',2);  % max pooling�w�F2x2�̗̈���̍ő�l���o��  (�o�́F12x12x20) �̈���̕��ψړ��ւ̑Ή�
            
          convolution2dLayer(5,16);         % 5x5x20�̃t�B���^��16�Z�b�g(�}�b�v) (�o�́F8x8x16) ���͂̃p�f�B���O�Ȃ�
          reluLayer();                      % ReLU
          maxPooling2dLayer(2,'Stride',2);  % max pooling�w�F(�o�́F4x4x16 = 256����)
               
          fullyConnectedLayer(10);          % �S�����w�F����256�����A�o��10����=�J�e�S����
          softmaxLayer();                   % 10�̓��͂Ɋ������֐��Ƃ��Đ��K���w���֐���K��(�S�o�͂Ő��K��)���m���l�֕ϊ�
          classificationLayer()]            % �e�J�e�S�����Ƃ̃X�R�A�ƁA�\�����ꂽ�J�e�S�����o��

%% Deep Network Designer��CNN�̃��C���[���`�\
deepNetworkDesigner

%% �w�K�p�I�v�V�������AtrainingOptions�֐���p���ݒ�
%     �m���I���z�~���@�istochastic gradient descent with momentum�j�w�K�f�[�^�̈ꕔ�̒l�Ńp�����[�^���X�V
%     �K�v�ł���΁AGPU�̃������ʂɉ�����MiniBatchSize�𒲐�
opts = trainingOptions('sgdm', 'MaxEpochs',10, 'InitialLearnRate', 0.001,...
    'ValidationData',testDigitData,...
    'Plots','training-progress');     % �ő�10����܂Ŋw�K�A

%% [�w�K] �l�b�g���[�N�����t�t���w�K�iSeriesNetwork �N���X�̃I�u�W�F�N�g���w�K��ɐ��������j
net = trainNetwork(trainDigitData, layers, opts);
%       load('I5_06_2_1_net.mat');           % ���炩���ߊw�K�������ʂ�p����ꍇ

%% [���ފ�̌���] ���ؗp�摜2500���̈ꕔ�i250���j��\�� ************************
figure; montage(testDigitData.Files(1:10:end)); truesize;

%% ���ؗp�̉摜���ꖇ�Ǎ���
I = imread(testDigitData.Files{521});
figure; imshow(I);

%% �w�K�����l�b�g���[�N�ŕ���
YPredClass = classify(net, I)

%% �N���X�֕���(2500x1) �� ���̍ۂ̃X�R�A(2500x10) �̌v�Z
[YPredClass, YPredScore] = classify(net, testDigitData);             % predict�֐��̓X�R�A�̂ݏo�́B�K�v�ł���΁AGPU�̃������ʂɉ�����MiniBatchSize�𒲐�

%% ���ʂ̕\���F�����s��̌v�Z �i1�s��:0�̕�����F������������)
[confMat order] = confusionmat(testDigitData.Labels, YPredClass)

%% �S�̂̐��x(����)���v�Z
accuracy = sum(YPredClass == testDigitData.Labels)/numel(YPredClass)

%% �I��














%% �����s��̒P�ʂ��p�[�Z���g�֕ϊ��i�v�f�P�ʉ��Z�j
confMat = bsxfun(@rdivide, confMat, sum(confMat,2))     % 1�����̕������A����̃T�C�Y�Ɋg�����č��킹��

%% �ʂ̃e�X�g�摜�������iComputer Vision Toolbox�j**********************
%        imageDataset�ցA�e�X�g�摜�i12��x10������j�ւ̐�΃p�X���w��
pathData = [toolboxdir('vision'), '\visiondata\digits'];
testSet  = imageDatastore([pathData,'\handwritten'], 'LabelSource','foldernames', 'IncludeSubfolders',true)

%% �S�e�X�g�摜�������^�[�W���\�� (12�� x 10������)
figure; montage(testSet.Files, 'Size', [10,12]);

%% [����] �쐬�������ފ�Ŏ菑������(120��)������
%        �摜��Ǎ��ލۂɌ`�������낦��F28x28pixel�A�������A�O���[�X�P�[���Adouble�^
testSet.ReadFcn = @(filename) imresize(imcomplement(rgb2gray(imread(filename))), [28 28]);
YPredClass2 = classify(net, testSet);

%% [����] ���ʂ̕\��
Ir = zeros([28,28,3,120], 'uint8');      % ���ʂ��i�[����z��
for k = 1:size(testSet.Labels,1)
  if YPredClass2(k) == testSet.Labels(k)    %���������ʂ͐F�A��F���͐ԐF
    labelC = 'blue';
  else
    labelC = 'red';
  end
  Ir(:,:,:,k) = insertText(readimage(testSet,k),[6 4],char(YPredClass2(k)),'FontSize',16,'TextColor',labelC,'BoxOpacity',0.4); 
end
figure;montage(Ir, 'Size', [10,12]);

%% �I��




%% ��2�w�ځi�ŏ��̃t�B���^��ݍ��ݑw�j�̓���������
%       �i�ŏ��̑w�͊�{�I�ȉ摜�̓���:�G�b�W��`��𒊏o�j
%        20�Z�b�g�̃t�B���^�W���i�d�݁j������
net.Layers(2) 
w1 = gather(net.Layers(2).Weights);      % 5x5x1 �� 20�Z�b�g(�}�b�v)
w1g = mat2gray(w1);              % w1�̗v�f�͈̔͂�0~1�փX�P�[�����O
for k = 1:size(w1g, 4)
  w1a(:,:,k) = imadjust(imresize(w1g(:,:,:,k), 5, 'cubic'));   % 25x25�s�N�Z���֊g��A�R���g���X�g����
end
figure; montage(gather(reshape(w1a,[25 25 1 20])));    % �\��

%% �r�����ʂ�mat�t�@�C���֕ۑ��Ɏg�p�����֐�
%save('I5_06_2_1_net.mat', 'net');


%% Copyright 2016 The MathWorks, Inc.
