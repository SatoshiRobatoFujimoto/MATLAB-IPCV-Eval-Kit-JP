%% �f�B�[�v���[�j���O�]�ڊw�K(SVM)�ɂ��摜����
% �w�K�ς�CNN��SVM���g�����]�ڊw�K

%% ������
clear; close all; imtool close all; clc;rng('default')

%% �w�K���������摜�Z�b�g�̏����i�����ł͂U�̃J�e�S���̉摜���g�p�j%%%%%%%%%%%%%%%%%%%%%%
%  http://www.vision.caltech.edu/Image_Datasets/Caltech101 Caltech 101
if ~exist('101_ObjectCategories','dir')
    websave('101_ObjectCategories.tar.gz','http://www.vision.caltech.edu/Image_Datasets/Caltech101/101_ObjectCategories.tar.gz');
    gunzip('101_ObjectCategories.tar.gz');
    untar('101_ObjectCategories.tar','101_ObjectCategories');
end
rootFolder = fullfile('101_ObjectCategories','101_ObjectCategories');          % �摜�Z�b�g�ւ̃p�X
categ = {'cup', 'pizza', 'watch', 'laptop'};

%% �J�b�v
winopen(fullfile(rootFolder,categ{1}));

%% �s�U
winopen(fullfile(rootFolder,categ{2}));

%% �r���v
winopen(fullfile(rootFolder,categ{3}));

%% ���b�v�g�b�vPC
winopen(fullfile(rootFolder,categ{4}));

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

%% Pre-trained Convolutional Neural Network (CNN) �̓Ǎ��� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
convnet = alexnet   % SeriesNetwork�N���X�F25�w

%% �\������Ă���w�̕\���i��ݍ��ݑw:5�w�A�S�����w:3�w�j
convnet.Layers

%% ���w�ځi���͑w�j�̏ڍו\��
convnet.Layers(1)      % ���͉摜�T�C�Y�́A227x227x3�ŌŒ�A���K���L��

%% �l�b�g���[�N�ɉ摜����͂��邽�߂̑O�����֐�
% convnet�ւ̓��͉摜�T�C�Y�F227x227�s�N�Z����RGB�摜�֑�����ׁB�\���̍ۂ����̃T�C�Y�֕ϊ������
% ImageDatastore �� ReadFcn �֐���ݒ�
imds.ReadFcn = @(filename) I5_06_2_2_readAndPreproc(filename);

%% CNN�����̏�����F��2�w�ځi�ŏ��̃t�B���^��ݍ��ݑw�j�̓���������
%       �i�ŏ��̑w�͊�{�I�ȉ摜�̓���:�G�b�W��`��𒊏o�j
% 96�Z�b�g�̃t�B���^�W���i�d�݁j������
convnet.Layers(2)                  % ��2�w�ڂ̏ڍ�
w1 = convnet.Layers(2).Weights;    % 11x11x3 Single�� 96�Z�b�g(�}�b�v)
w1s = mat2gray(w1);                 % w1�̗v�f�͈̔͂�0~1�փX�P�[�����O
for k = 1:size(convnet.Layers(2).Weights, 4)
  I = imresize(w1s(:,:,:,k), 5, 'nearest');     % 33x33�s�N�Z���֊g��A�R���g���X�g����
  w1a(:,:,:,k) = imadjust(I, stretchlim(I));
end
figure; montage(w1a);               % �\��

%% ��j63�Ԗڂ̃t�B���^�ŏ􍞂ݏ����E�\��
figure; imshow(w1a(:,:,:,63),[]); truesize; shg;  % �t�B���^�W��������
%% �摜���Ǎ��ݥ�\��
Is = readimage(imds, 1);
figure;subplot(1,2,1); imshow(Is); shg;
%% �t�B���^������\��
F = w1(:,:,:,63);                     % �t�B���^�W���w��
Isf = convn(Is, F, 'valid');          % ��ݍ��݌v�Z
subplot(1,2,2); imshow(Isf, []); shg; % �\��

%% �ŏI�w�̊m�F
convnet.Layers(end)     % ImageNet�f�[�^�Z�b�g��1000�N���X�𕪗ނ���悤�Ɋw�K�ς�

%% �e�J�e�S���̉摜���A�w�K�f�[�^(90%)�ƃe�X�g�f�[�^(10%)�ɕ�����
[trainingSet, testSet] = splitEachLabel(imds, 0.9);    % randomize �I�v�V�������L

%% [�w�K�X�e�b�v#1] ����̃��C���[fc7(23�w����19�Ԗ�)�̏o�͂�
%                     �����ʂƂ��Ĉ����o���i4096�����j
% GPU�̃������ɉ����āAMiniBatchSize�𒲐�
% �����ʂ��c(��P��������)�ɂ��Afitcecoc�̃g���[�j���O���������ifitcecoc�ŁAObservationsIn��ݒ�j
fLayer = 'fc7';
trainingFeatures = activations(convnet, trainingSet, fLayer, ...   % CPU�ł͎��s���ԕK�v
                   'MiniBatchSize', 32, 'OutputAs', 'columns');    % 4096x126 �e�񂪊e�摜�ɑΉ�

%% [�w�K�X�e�b�v#2] ���N���X���ފ���w�K�iECOC�������o�͕��� ���N���X���f���A���`���ފ�j
% �����������ʂ̊w�K�ɓK�����Asolver�ifast Stochastic Gradient Descent�j���g�p
classifier = fitcecoc(trainingFeatures,trainingSet.Labels , ...
        'Learners', 'Linear', 'Coding', 'onevsall', 'ObservationsIn', 'columns');

      
%% ��j��蕪���Ă������A�e�X�g�摜��10���ڂ𕪗� **********************************
I1 = imread(testSet.Files{10});      % �摜���ꖇ�Ǎ��݁i��F10���ځj
figure; imshow(I1);                  % �摜�̕\��

%% [���ރX�e�b�v#1]
imageFeatures = activations(convnet, readimage(testSet, 10),...
    fLayer,'OutputAs','rows');   % �����ʂ��v�Z

%% [���ރX�e�b�v#2]��\��
label = predict(classifier, imageFeatures)      % �w�K�������ފ�ɂ�蕪��
% ���ʂ̕\��
imshow(insertText(I1, [10 70], char(label), 'FontSize',20)); shg;       % �F�����ʂ�}����\��

%% ���l�ɂ��ׂẴe�X�g�摜��p���A���ފ�̐��\�]��
% ���ׂẴe�X�g�p�摜��������ʂ��v�Z
testFeatures = activations(convnet, testSet, fLayer, 'MiniBatchSize',32,...
    'OutputAs','rows');   % �����ʂ��v�Z
% ����w�K�������N���X���ފ�ɂ�镪��
predictedLabels = predict(classifier, testFeatures);
% �����s��̌v�Z �i1�s��:��s�@�̉摜��F������������)
[confMat order] = confusionmat(testSet.Labels, predictedLabels)

%% ���\�]��
% �����s��̒P�ʂ��p�[�Z���g�֕ϊ��i�v�f�P�ʉ��Z�j
confMat = bsxfun(@rdivide,confMat,sum(confMat,2))  % 1�����̕������A����̃T�C�Y�Ɋg�����č��킹��
% �S�̂̐��x(����)���v�Z
mean(diag(confMat))

%% �����������ފ�(SVM)��ۑ�
save('I5_06_2_2_myCNNTransferLearning_SVM.mat', 'classifier');

%% Copyright 2018 The MathWorks, Inc
% Copyright 2018 The MathWorks, Inc.