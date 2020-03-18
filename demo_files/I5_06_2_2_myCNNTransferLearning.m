%% �f�B�[�v���[�j���O�]�ڊw�K�ɂ��摜����

%% ������
clear; close all; imtool close all; clc;rng('default');

%% �w�K���������摜�Z�b�g�̏����i�����ł͂U�̃J�e�S���̉摜���g�p�j
%  http://www.vision.caltech.edu/Image_Datasets/Caltech101 Caltech 101
if ~exist('101_ObjectCategories','dir')
    websave('101_ObjectCategories.tar.gz','http://www.vision.caltech.edu/Image_Datasets/Caltech101/101_ObjectCategories.tar.gz');
    gunzip('101_ObjectCategories.tar.gz');
    untar('101_ObjectCategories.tar','101_ObjectCategories');
end
rootFolder = fullfile('101_ObjectCategories','101_ObjectCategories');          % �摜�Z�b�g�ւ̃p�X
categ = {'cup', 'pizza', 'watch', 'laptop'};

%% ImageDatastore �N���X�֊w�K�摜�̏���o�^
% �R�̃J�e�S���̉摜�̃t�@�C������荞�ށi�t�H���_�̖��O���A���x�����ɂ���j�F�摜���̂��̂͂܂��Ǎ��܂Ȃ�
%       Files�F �t�@�C�����F�Z���z��
%       Labels�F���x��    �F�J�e�S���J���z��
imds = imageDatastore(fullfile(rootFolder, categ), 'LabelSource', 'foldernames')
% �e�J�e�S���̉摜�̖����̊m�F
tbl = countEachLabel(imds)
% �e�J�e�S���̃f�[�^�����A�ŏ��̂��̂ɂ��낦��
imds = splitEachLabel(imds, min(tbl{:,2}));  % randomize�I�v�V�������L
countEachLabel(imds)                         % �e�J�e�S���̉摜�̖����̊m�F

%% �w�K�f�[�^�ƃe�X�g�f�[�^�ɕ�����
[imdsTrain,imdsValidation] = splitEachLabel(imds,0.9);

%% �w�K�摜�̉���
numTrainImages = numel(imdsTrain.Labels);
idx = randperm(numTrainImages,16);
figure
for i = 1:16
    subplot(4,4,i)
    I = readimage(imdsTrain,idx(i));
    imshow(I)
end

%% �w�K�ς݃��f�������[�h
net = alexnet;
analyzeNetwork(net) % ����
inputSize = net.Layers(1).InputSize

%% �]�ڊw�K�p�Ɍ�i��ύX
layersTransfer = net.Layers(1:end-3); % ��i�̑w������
numClasses = numel(categories(imdsTrain.Labels)) % �N���X���擾
layers = [
    layersTransfer
    fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
    softmaxLayer
    classificationLayer];

%% �w�K�f�[�^�̐�����
pixelRange = [-30 30]; % -30��f����30��f�Ń����_���ɏ㉺�ɓ�����
imageAugmenter = imageDataAugmenter( ...
    'RandXReflection',true, ...
    'RandXTranslation',pixelRange, ...
    'RandYTranslation',pixelRange);
augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain, ...
    'DataAugmentation',imageAugmenter,...
    'ColorPreprocessing','gray2rgb'); % ���͉摜�T�C�Y�ύX
augimdsValidation = augmentedImageDatastore(inputSize(1:2),imdsValidation,...
    'ColorPreprocessing','gray2rgb');

%% �w�K�I�v�V�����̎w��
options = trainingOptions('sgdm', ...
    'MiniBatchSize',16, ...
    'MaxEpochs',3, ...
    'InitialLearnRate',1e-4, ...
    'ValidationData',augimdsValidation, ...
    'ValidationFrequency',10, ...
    'ValidationPatience',Inf, ...
    'Verbose',false, ...
    'Plots','training-progress');

%% �w�K�����s
netTransfer = trainNetwork(augimdsTrain,layers,options);

%% �w�K�������f�����g���ăe�X�g
[YPred,scores] = classify(netTransfer,augimdsValidation);
accuracy = mean(YPred == imdsValidation.Labels)

%% ����
idx = randperm(numel(imdsValidation.Files),4);
figure
for i = 1:4
    subplot(4,1,i)
    I = readimage(imdsValidation,idx(i));
    imshow(I)
    label = YPred(idx(i));
    title(string(label));
end

%% �����������ފ��ۑ�
save('I5_06_2_2_myCNNTransferLearning.mat', 'netTransfer');

%% 
% Copyright 2018 The MathWorks, Inc.
