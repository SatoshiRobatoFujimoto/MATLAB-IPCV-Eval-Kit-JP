%% Bag-of-Visual-Words��p�����ގ��摜����
clc;clear;close all;imtool close all;

%% �摜�f�[�^�̏���
%  �J�e�S�����ɉ摜�t�@�C�������AImage Set �N���X�֊i�[�E�摜��\��
%              �摜�̃\�[�X�F http://www.cdc.gov/dpdx/index.html    (Centers for Disease Control and Prevention)
if ~exist('classifyBloodSmearImages','dir')
    websave('classifyBloodSmearImages.zip','https://jp.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/66881/versions/3/download/zip')
    unzip('classifyBloodSmearImages.zip');
end
imgFolder = 'classifyBloodSmearImages\BloodSmearImages';              % �摜�ւ̃p�X�̎w��

%% �摜�f�[�^�̓ǂݍ���
% �t�H���_���w�肷�邱�ƂŁA�摜�t�@�C������Image Set �N���X�֊i�[ (48��)
%         �摜�̃\�[�X�F http://www.cdc.gov/dpdx/index.html    (Centers for Disease Control and Prevention)
bImageDS = imageDatastore(imgFolder,...
    'IncludeSubfolders',true,...
    'FileExtensions',{'.jpg','.tif','.png'})   % 48���̃f�[�^
% �\��
figure;montage([bImageDS.Files], 'Size',[6 8]); truesize;

%% Visual Words (�Ǐ��I�Ȗ͗l)�̏W�����A�����i�f�t�H���g�ݒ�F500�j
%   �S�J�e�S���[�ɑ΂��A�c�����ꂼ��8�s�N�Z���Ԋu�̃O���b�h��̓_�ŁA�e[32 64 96 128]��4�̗̈�T�C�Y�œ����ʂ𒊏o
%   ���[�h�� 2000�ɁAK-means�ŃO���[�v��
% Parallel Computing Toolbox �I�v�V��������΁A����v�Z���\  (�ݒ胁�j���[����Computer Vision System Toolbox�ݒ���Őݒ�)
% �J�X�^���̓����ʒ��o�֐��̎w����\ (R2015a)
%    load('I5_05_Parasitology_img\I5_05_2_bag_med.mat');      % ���炩���ߐ����������̂��g���ꍇ
bBag = bagOfFeatures(bImageDS, 'VocabularySize', 2000, 'Upright',false)

%% �S�Ẳ摜�ɁA�����p�̃C���f�b�N�X��t����
% �e�摜��������ʂ𒊏o���AVisualWords�ɑΉ��Â���:  invertedImageIndex �N���X
bImageIndex = indexImages(bImageDS, bBag);
%% Visual Words�����ꂽ�摜�̊���
figure; plot(bImageIndex.WordFrequency); 
%% �o���p�x�̏����Ȃ��̂��珇�ɕ��ׂ�
plot(sort(bImageIndex.WordFrequency)); shg;
%% �ǂ̉摜�ɂ��܂܂��ʂɖ��ɗ����Ȃ����̂͏���
bImageIndex.WordFrequencyRange = [0.01 0.85]    %default:[0.01 0.9]

%% �ގ��摜�̌��� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
queryImage = readimage(bImageDS, 19);   % �����Ώۉ摜�̓Ǎ���
figure; imshow(queryImage);         % �摜�̕\��

%% Visual Words�̃q�X�g�O������\��
figure; histogram(bImageIndex.ImageWords(19).WordIndex, [1:bBag.VocabularySize])

%% �X�R�A��t���A���Ă�����̏��16�̕\��
[imageIDs, scores] = retrieveImages(queryImage, bImageIndex);

% ���ʂ̕\��
for i = 1:9      % ���9�̕\��
  I  = readimage(bImageDS, imageIDs(i));            % �摜�̓Ǎ���
  Ir1(:,:,:,i) = insertText(I, [1 1], num2str(scores(i)), 'FontSize',32); % 4���������ɂȂ���
end
figure; montage(Ir1); truesize;


%% �ʂ̉摜�̌��� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
queryImage = readimage(bImageDS, 48);   % �����Ώۉ摜
figure; imshow(queryImage);

%% ���Ă�����̏��9�̒��o�E�\��
[imageIDs, scores] = retrieveImages(queryImage, bImageIndex);
% ���ʂ̕\��
for i = 1:9
  I  = readimage(bImageDS, imageIDs(i));            % �摜�̓Ǎ���
  Ir2(:,:,:,i) = insertText(I, [1 1], num2str(scores(i)), 'FontSize',32); % 4���������ɂȂ���
end
figure; montage(Ir2); truesize;


%% Copyright 2015 The MathWorks, Inc.
