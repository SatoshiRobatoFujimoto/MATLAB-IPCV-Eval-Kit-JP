clear all;clc;close all;imtool close all

%% �摜�̎捞�ݥ�\��
I = imread('coins.png');
figure; imshow(I);

%% ���샆�[�U�[�C���^�[�t�F�[�X�̋N��
h = thresholding(I);    % �N�����ɁA�摜�f�[�^I��n��
uiwait(h)

%% �o�͉摜�̕\��
figure; imshow(OUT);

%% GUIDE�̋N���i�c�[���T�v�����j
guide

%% ����GUI���J��
guide thresholding

%%
% Copyright 2014 The MathWorks, Inc.
