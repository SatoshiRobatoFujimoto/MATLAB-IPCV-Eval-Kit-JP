%% �@�B�w�K�f���F�O���ԗ��̌��o
clc;clear;close all;imtool close all;

%% Image Labeler ���N���F���L�R�}���h�������̓A�v���^�u����
imageLabeler

% �u�ǂݍ��݁v���u�t�H���_�[����C���[�W��ǉ��v 
% I5_02_cars ���̉摜��ǉ��i���ۂ͐��S���ȏ�̉摜���g�p�j
% �������͉��L�̃R�}���h�ŋN��
% imageLabeler('I5_02_cars');

% �A���S���Y���Z�N�V�����́u�V����ROI���x���̒�`�v�Łucar�v��Rectangle�Ƃ��č��
%  �e�摜�Ŏԗ����h���b�O�ň͂�
% �u���x�����G�N�X�|�[�g�v�́u���[�N�X�y�[�X�ցv��I��
% �u�G�N�X�|�[�g�Ώۂ̕ϐ����v��positiveInstances�A
% �u�G�N�X�|�[�g�`���v��table�A�Ƃ�MATLAB�̃��[�N�X�y�[�X��

%% Neg�摜�̃t�H���_�̎w��
negFolder = 'I5_02_neg'
winopen(negFolder);     % �t�H���_�[���J���ĉ摜���m�F�i���ۂ͐��S���ȏ�̉摜���g�p�j

%% �w�K�̎��s (�w�K���ʂ��AXML�`���̃t�@�C���Ő��������)
%     ���ފ탂�f���t�@�C���F  carDetector.xml  �����������
%     ���ۂ͂����Ƒ����̉摜�Ŋw�K
trainCascadeObjectDetector('carDetector.xml', positiveInstances, negFolder);
        
%% ���m�̉摜�̓Ǎ���
I = imread('I5_02_IMG_5959_2a.jpg');
figure; imshow(I);

%% ���̔F���I�u�W�F�N�g�̒�`�A���s [�Q�s��MATLAB�R�[�h]
%    �����ł́A���炩���ߊw�K�E�����������ފ탂�f���t�@�C�� I5_02_carDetector_20151015Bb.xml ���g�p
detector = vision.CascadeObjectDetector('I5_02_carDetector_20151015Bb.xml');
cars1 = step(detector, I)

%% ���o���ꂽ�Ԃ̈ʒu�ɁA�l�p���g�ƃe�L�X�g��ǉ�
I2 = insertObjectAnnotation(I, 'rectangle', cars1, [1:size(cars1,1)], 'FontSize',24, 'LineWidth', 4);
imshow(I2);shg;

%% �ʂ̉摜�̓Ǎ��� %%%%%%%%%%%%%%%%%%%%%%%%
I = imread('I5_02_DSC_3317a5.JPG');
figure; imshow(I);

%% ���̌��o���s����ʂ̕\��
cars2 = step(detector, I)
I2 = insertObjectAnnotation(I, 'rectangle', cars2, [1:size(cars2,1)], 'FontSize',24, 'LineWidth', 12, 'Color','green');
imshow(I2);shg;

%% �c�[���Ō��o���ʂ̏C��

% �C���[�W���x���[�ɓǂݍ��ނ��߂�groundTruth�I�u�W�F�N�g�𐶐�����
imageFilenames = {[pwd, '\I5_02_IMG_5959_2a.jpg']; [pwd, '\I5_02_DSC_3317a5.jpg']};
dataSource = groundTruthDataSource(imageFilenames);
Cars = {cars1; cars2};
labelDefs = table({'car'},labelType('Rectangle'),'VariableNames',{'Name','Type'});
labelData = table(Cars,'VariableNames',labelDefs.Name);
gTruth = groundTruth(dataSource,labelDefs,labelData);

% �u���x�����C���|�[�g�v���u���[�N�X�y�[�X����v��gTruth���C���|�[�g
imageLabeler(imageDatastore(imageFilenames));

%% �C�ӂ̔������A���S���Y���̒ǉ�
imageLabeler('I5_02_cars');

% �A���S���Y���Z�N�V�����́u�V����ROI���x���̒�`�v�Łucar�v��Rectangle�Ƃ��č��
% �u�A���S���Y���̒ǉ��v����u�A���S���Y���̃C���|�[�g�v��I��
% �uI5_02_CarDetection.m�v��I������
% �A���S���Y���̑I���ꗗ�Ɂu�Ԍ��o��v���ǉ������̂őI�����A�u�������v���N���b�N
% �u���s�v�������Ĕ��������x�����O�����{����

%%
release(detector);

%% �I��

%%
% Copyright 2018 The MathWorks, Inc.