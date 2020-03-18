%% ���n�������x�[�X�̃J���[�Z�O�����e�[�V����
%     �J�n�̈�Ƃ��āA���S��f�ȏ�𐄏�
clc;clear;close all;imtool close all;

%% �摜�̓Ǎ��݁E�\��
RGB = imread('yellowlily.jpg');
figure;imshow(RGB);

%% �O�i�w��F�J�n�̈�   �i�����̈���j
%    roipoly, imfreehand, imrect, impoly, imellipse ���g�p��
%bbox1 = [700 350 820 775];   % [����s ����� �E���s �E����]
BW1 = false(size(RGB(:,:,1)));
BW1(700:820, 350:775) = true;
hold on; visboundaries(BW1, 'Color','r');

%% �w�i�w��F�J�n�̈�
bbox2 = [1230 90 1420 1000];
BW2 = false(size(RGB(:,:,1)));
BW2(bbox2(1):bbox2(3),bbox2(2):bbox2(4)) = true;
visboundaries(BW2, 'Color','b');shg;

%% �Z�O�����e�[�V�����̎��s
%     YCbCr��Ԃ֕ϊ��㏈�������
[L,P] = imseggeodesic(RGB,BW1,BW2);
figure; imshow(P(:,:,1))          % �O�i�̊m��

%% ���ʂ̕\��
figure; imshow(label2rgb(L))

%% ���܂����̈拫�E��\��
figure; imshow(RGB); hold on;
visboundaries(L==min(L(:)), 'Color','r');

%%
% Copyright 2015 The MathWorks, Inc.

