clc;close all;imtool close all;clear;

%% �Î~�摜�̓Ǎ��݁E�\��
A=imread('peppers.png');
figure;imshow(A);

%% �F��臒l�A�v���P�[�V�������N��(���L�R�}���h�������́A�A�v���P�[�V���� �^�u����N��)
colorThresholder(A)    % �F��臒l �A�v���P�[�V�����F���̃e�[�u���N���X�̂ݏ���

% Copyright 2014 The MathWorks, Inc.
