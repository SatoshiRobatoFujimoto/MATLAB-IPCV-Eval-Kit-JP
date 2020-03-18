% ������
clear; clc, close all, imtool close all;

%% Step 1: �摜�̓Ǎ��ݥ�\��
fixed  = imread('I2_06_2_stitch1.png');
moving = imread('I2_06_2_stitch2.png');
figure; imshowpair(moving,fixed,'montage')

%% Step 2: �ʑ����ւ�p�����ʒu����̌��o
%          �i�P�x�x�[�X�̍œK����@���傫�Ȃ���ɋ��������j
%          �i�P�x�x�[�X�̍œK����@�̏����l�Ɏg�p�j
tform = imregcorr(moving, fixed, 'translation')      % �����ł͕��s�ړ��݂̂�����
tform.T                                              % ����ꂽ�ϊ��s��

%% Step 3: 2�̉摜�̍���
Rfixed = imref2d(size(fixed));
[movingReg, Rreg] = imwarp(moving,tform);               % 2���ڂ̉摜���􉽊w�I�ϊ�
panorama = imfuse(movingReg,Rreg,fixed,Rfixed,'blend'); % ����
figure; imshow(panorama);

%% Step 4: �P�x���g�����œK���x�[�X�̈ʒu�����A���S���Y����p��
%           �������i�傫�����ꂽ�摜�ɑ΂��Ă͋��)
%           �ʑ����ւŋ��߂��ϊ��s��������l�Ƃ��Ďg�p
[optimizer,metric] = imregconfig('monomodal');
movingGray = rgb2gray(moving);
fixedGray  = rgb2gray(fixed);
tformOptim = imregtform(movingGray,fixedGray,'translation',optimizer,metric,'InitialTransformation',tform);
tformOptim.T

[movingRegOptim,RregOptim] = imwarp(moving,tformOptim);
panoramaOptim = imfuse(movingRegOptim,RregOptim,fixed,Rfixed,'blend');
figure; imshow(panoramaOptim);

%% 


%% Copyright 2015 The MathWorks, Inc.

