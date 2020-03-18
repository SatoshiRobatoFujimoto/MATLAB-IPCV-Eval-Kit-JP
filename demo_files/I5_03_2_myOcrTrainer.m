clear;clc;close all;imtool close all

%% �摜�̓Ǎ��ݥ�\��
I = imread('I5_03_2_imgPi.JPG');
figure;imshow(I);

%% �摜�̓�l��
BW = imbinarize(rgb2gray(I));
figure;imshow(BW);

%% �����̂���������i���������Ȕ����𖄂߂�j
BW1 = imopen(BW, ones(5));     %���k=>�c��
imshow(BW1); shg;

%% �����F���E�\��
results = ocr(BW1)
Ir1 = insertObjectAnnotation(I, 'rectangle', results.WordBoundingBoxes, results.Words, 'FontSize',40);
figure; imshow(Ir1);truesize;

%% OCR Trainer�ŁA�J�X�^���t�H���g���w�K�i�F������������������Ȃ��w�K������j
ocrTrainer

% New Session���N���b�N
%      �w�K�����錾��f�[�^�x�[�X���i�C�ӂ̖��O�j���w��
%      �o�̓f�B���N�g���̎w��i���̃f�B���N�g�������炩���ߑ��݂���K�v����j
%            �w�K���s��Ɏ����I�ɉ��L�̗l�Ƀt�@�C�������������
%                  �o�̓f�B���N�g��\<����f�[�^�x�[�X��>\tesdata\<����f�[�^�x�[�X��>.traineddata
%      Pre-label using OCR��ON�ɂ��āA������w�肵�������x�����O������i���̌���́APre-Label�ɂ̂ݗp������j
%      �w�K�p�摜(I5_03_2_7segTraining1.png)���w�肵�āAOK �i��Œǉ����\�j�F
%                        - �o���邾�����������̂ݐ؂�o�����摜���g�p�A
%                        - �e����10�T���v���ȏ�͊w�K������
%                        - '0000'��'1111'�̂悤�Ȍ`�������ł͂Ȃ����ۂɒP��Ƃ��Č���鑼�̕����Ƃ̈ʒu�֌W����
%                          ���f�����w�K�f�[�^��p����
%      �����œ�l������A[CROP Images] ���j���[�Ɉړ�
%      �������������i�O�i�j�ɂȂ�
%  *[��]*�����_�p�ɁAMin Area��10�܂ŉ�����
%      �����̗̈��ROI�Ƃ��Ďw�肷�邱�ƂŁA�Z�O�����e�[�V�������ʂ̉��P���\
%      �s�K�؂ȉ摜���A�Z�b�V��������폜�ł���
%         Accept�Ŏ���

% [OCR Trainer] �^�u
%      �w�肵������OCR�f�[�^�x�[�X�ŁA���x�����O�����B
%      �Z�O�����e�[�V�������ꂽ���ʂ��_�u���N���b�N�ŁA���摜���\������A�Z�O�����e�[�V�����̏C�����\
%      �Ԉ�������̂̃��x�����C����Enter�i�����I����:Shift�ECtrl�j
%      �w�K�Ɏg�������Ȃ����̂́AUnknown �J�e�S���[�֕���
%      Settings�ŁA���x���Ɏg�p����t�H���g��I����
%   Train �{�^���ŁA�w�K    => �w�K��A�����I�Ƀf�[�^�x�[�X���ۑ�����A���̕ۑ��悪�\�������B

% �Z�b�V������ۑ����Ă��A�w�K�p�摜�f�[�^�͊܂܂�Ȃ��̂ŁA�ʓr�ۑ����K�v

%% �쐻�����f�[�^�x�[�X�ŁA�����F���E���ʂ̕\��
%     �f�[�^�x�[�X�t�@�C���́A�P���tessdata�Ƃ������O�̃t�H���_���ɒu��
results = ocr(BW1, 'Language', 'I5_03_2_myLang\tessdata\myLang.traineddata')
Ir2 = insertObjectAnnotation(I, 'rectangle', results.WordBoundingBoxes, results.Words, 'FontSize',40);
figure; subplot(2,1,1); imshow(Ir1); title('with original English database', 'FontSize',18);
        subplot(2,1,2); imshow(Ir2); title('with trained database', 'FontSize',18);

%% �I��











%% �����Ń��x�����O��w�K��������f�[�^���g�p�����ꍇ
results_J = ocr(BW1, 'Language', 'I5_03_2_myLang\tessdata\myLang_J.traineddata', 'TextLayout','Word')
% ���ʂ̕\��
Ir2_J = insertObjectAnnotation(I, 'rectangle', results_J.WordBoundingBoxes, results_J.Words, 'FontSize',30, 'Font','MS Gothic');
figure; subplot(2,1,1); imshow(Ir1  ); title('with original English database', 'FontSize',18);
        subplot(2,1,2); imshow(Ir2_J); title('with trained database', 'FontSize',18);
        
%% Copyright 2016 The MathWorks, Inc.
