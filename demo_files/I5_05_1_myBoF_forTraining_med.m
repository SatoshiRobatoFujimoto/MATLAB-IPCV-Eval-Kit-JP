%% Bag of Visual Words � Bag of Features �ɂ��摜�̃K�e�S������
% �Ԍ����Ɋ񐶂����a�����̕���
% �o�x�V�A�� / �}�����A���� / �g���p�m�\�[�}��
clc;close all;imtool close all;clear; rng('default');

%% �摜�f�[�^�̏���
%  �J�e�S�����ɉ摜�t�@�C�������AImage Set �N���X�֊i�[�E�摜��\��
%              �摜�̃\�[�X�F http://www.cdc.gov/dpdx/index.html    (Centers for Disease Control and Prevention)
if ~exist('classifyBloodSmearImages','dir')
    websave('classifyBloodSmearImages.zip','https://jp.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/66881/versions/3/download/zip')
    unzip('classifyBloodSmearImages.zip');
end
rootFolder = 'classifyBloodSmearImages\BloodSmearImages';              % �摜�ւ̃p�X�̎w��

%% �摜�f�[�^�̓ǂݍ���
imgSets = imageSet(rootFolder, 'recursive')
% �e�J�e�S���̍ŏ��̉摜��\��
figure; subplot(1,3,1);imshow(read(imgSets(1),1));title(imgSets(1).Description, 'FontSize',16);
        subplot(1,3,2);imshow(read(imgSets(2),1));title(imgSets(2).Description, 'FontSize',16);
        subplot(1,3,3);imshow(read(imgSets(3),1));title(imgSets(3).Description, 'FontSize',16); truesize;

%% �S�摜�̕\�� (���ꂼ��16������)
figure;subplot(1,3,1);montage([imgSets(1).ImageLocation]);title(imgSets(1).Description, 'FontSize',16);
       subplot(1,3,2);montage([imgSets(2).ImageLocation]);title(imgSets(2).Description, 'FontSize',16);
       subplot(1,3,3);montage([imgSets(3).ImageLocation]);title(imgSets(3).Description, 'FontSize',16); truesize;

%% �e�J�e�S���̉摜���A�w�K�p�摜(15��)�ƌ��ؗp�摜(1��)�ɕ�����Fpartition ���\�b�h
[trainingSets, validationSets] = partition(imgSets, 15);                 % randomized �I�v�V����������

%% Visual Words (�Ǐ��I�Ȗ͗l)�̏W�����A�����i�f�t�H���g�ݒ�F500�j
%   �S�J�e�S���[�ɑ΂��A�c�����ꂼ��8�s�N�Z���Ԋu�̃O���b�h��̓_�ŁA�e[32 64 96 128]��4�̗̈�T�C�Y�œ����ʂ𒊏o
%   ���[�h�� 500�ɁAK-means�ŃO���[�v��
% Parallel Computing Toolbox �I�v�V��������΁A����v�Z���\  (�ݒ胁�j���[����Computer Vision System Toolbox�ݒ���Őݒ�)
% �J�X�^���̓����ʒ��o�֐��̎w����\
%   ���炩���ߐ������ۑ����Ă���ꍇ�ɂ͂����Ǎ��݁F
%   load('I5_05_Parasitology_img\I5_05_1_bag_med.mat')
bag = bagOfFeatures(trainingSets);

%% ��j��Ԗڂ̃g���[�j���O�摜�� featureVector (Visual Words�̃q�X�g�O����) ��\��
img1 = read(trainingSets(1), 1);       % �摜�̓Ǎ���
img2 = read(trainingSets(2), 1);
img3 = read(trainingSets(3), 1);
figure;subplot(2,3,1);imshow(img1);title(trainingSets(1).Description, 'FontSize',14); % �摜�̕\��
       subplot(2,3,2);imshow(img2);title(trainingSets(2).Description, 'FontSize',14);
       subplot(2,3,3);imshow(img3);title(trainingSets(3).Description, 'FontSize',14);

% Visual Words�q�X�g�O�����𐶐� (1x500 single)��\��
featureVector1 = encode(bag, img1);
featureVector2 = encode(bag, img2);
featureVector3 = encode(bag, img3);
subplot(2,3,4); bar(featureVector1);xlabel('Visual word index');ylabel('Frequency of occurrence');xlim([1 500]);
subplot(2,3,5); bar(featureVector2);xlabel('Visual word index');ylabel('Frequency of occurrence');xlim([1 500]);
subplot(2,3,6); bar(featureVector3);xlabel('Visual word index');ylabel('Frequency of occurrence');xlim([1 500]);shg;

%% �e�w�K�p�摜�� Visual Words�̃q�X�g�O�����ŕ\���A�@�B�w�K�imulticlass linear SVM classifier�j
categoryClassifier = trainImageCategoryClassifier(trainingSets, bag);

%% ��蕪���Ă������A�e�X�g�摜��p���Č��� %%%%%%%%%
%  encode�ŁA�e�摜�ɑ΂���q�X�g�O������\��
img1 = read(validationSets(1), 1);    % �摜�̓Ǎ���
img2 = read(validationSets(2), 1);
img3 = read(validationSets(3), 1);
figure;subplot(2,3,1);imshow(img1);title(['(' validationSets(1).Description ')'], 'FontSize',14); % �摜�̕\��
       subplot(2,3,2);imshow(img2);title(['(' validationSets(2).Description ')'], 'FontSize',14);
       subplot(2,3,3);imshow(img3);title(['(' validationSets(3).Description ')'], 'FontSize',14);

featureVector1 = encode(bag, img1,  'Normalization', 'none');     % Visual Words�q�X�g�O�����𐶐� (1x500 single)
featureVector2 = encode(bag, img2,  'Normalization', 'none');     % Visual Words�q�X�g�O�����𐶐� (1x500 single)
featureVector3 = encode(bag, img3,  'Normalization', 'none');     % Visual Words�q�X�g�O�����𐶐� (1x500 single)
subplot(2,3,4);bar(featureVector1); xlabel('Visual word index'); ylabel('Frequency of occurrence'); xlim([1, 500]);
subplot(2,3,5);bar(featureVector2); xlabel('Visual word index'); ylabel('Frequency of occurrence'); xlim([1, 500]);
subplot(2,3,6);bar(featureVector3); xlabel('Visual word index'); ylabel('Frequency of occurrence'); xlim([1, 500]);

%% predict�ŕ��ށE���ʂ��摜�ɑ}��
[labelIdx1, scores] = predict(categoryClassifier, img1);
[labelIdx2, scores] = predict(categoryClassifier, img2);
[labelIdx3, scores] = predict(categoryClassifier, img3);
img1 = insertText(img1, [1 1], categoryClassifier.Labels(labelIdx1), 'FontSize', 30, 'BoxOpacity',1, 'Font','Meiryo');
img2 = insertText(img2, [1 1], categoryClassifier.Labels(labelIdx2), 'FontSize', 30, 'BoxOpacity',1, 'Font','Meiryo');
img3 = insertText(img3, [1 1], categoryClassifier.Labels(labelIdx3), 'FontSize', 30, 'BoxOpacity',1, 'Font','Meiryo');
subplot(2,3,1);imshow(img1);title(['(' validationSets(1).Description ')'], 'FontSize',14);
subplot(2,3,2);imshow(img2);title(['(' validationSets(2).Description ')'], 'FontSize',14);
subplot(2,3,3);imshow(img3);title(['(' validationSets(3).Description ')'], 'FontSize',14);shg;

%% �w�K�f�[�^��p���A�đ����藦�̌v�Z
confMatrix = evaluate(categoryClassifier, trainingSets);         % �i1�ɋ߂����l���E������Ίp���ɕ��ԁj

%% �I��















%% �f�[�^�x�[�X��ۑ�
% save('I5_05_1b_bag_med.mat', 'bag');

%% ��蕪���Ă������A�e�X�g�摜�ɑ΂��āA���ފ�̐��\��]��
confMatrix = evaluate(categoryClassifier, validationSets);

%% Copyright 2016 The MathWorks, Inc. 

