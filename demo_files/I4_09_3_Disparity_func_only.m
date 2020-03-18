clear;clc;close all;imtool close all

%% �摜�̓Ǎ��E�\���A�RD�l�K�l�Ŋm�F
I1 = rgb2gray(imread('scene_left.png'));
I2 = rgb2gray(imread('scene_right.png'));
figure; imshowpair(I1,I2,'ColorChannels','red-cyan');truesize;

%% �����摜(Disparity�}�b�v)�̌v�Z
d = disparity(I1, I2, 'DisparityRange', [-6 10]);

% -realmax('single') �ƁA�U��؂�Ă��܂���Pixel�̒l���A
% ����ȊO��pixel�̍ŏ��l�ɒu��������
marker_idx = (d == -realmax('single'));
d(marker_idx) = min(d(~marker_idx));

% �����摜�̕\���B�J�����ɋ߂���f���A���邭�\���B
figure; imshow(mat2gray(d));

%% �\�ʃv���b�g���g���\��
figure; surf(mat2gray(d));shading interp;xlabel('X');ylabel('Y');axis ij

%% �I��
%  Copyright 2014 The MathWorks, Inc.









%% R2014a���O�̃o�[�W�����Ŏ��s����Ƃ������摜(Disparity�}�b�v)�̌v�Z�FR2014a���O�̃o�[�W�����Ŏ��s����Ƃ�
%     R2014a�ŁA�f�t�H���g�̕����Ƃ���"SemiGlobal"���ǉ�
d = disparity(I1, I2, 'BlockSize', 35,'DisparityRange', [-6 10], 'UniquenessThreshold', 0);
