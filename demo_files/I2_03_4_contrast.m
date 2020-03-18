%% �R���g���X�g���� �p�̊e��֐� %%%%%%%%
clear;clc;close all;imtool close all

%% �摜�Ǎ��� %%%%%%%%
I = imread('I2_03_peppers_low.png');
Gray = rgb2gray(I);  % �O���[�X�P�[���֕ϊ�
figure;imshow(Gray);

figure;imhist(Gray);     % �P�x�l�̃q�X�g�O������\��

%% ��E���P�x��1%�O�a����悤�������� %%%%%%%%%%%%%%%
Gray1 = imadjust(Gray);
figure;imhist(Gray1);
%% �����O��̉摜����ׂĕ\��
figure;imshow([Gray Gray1]);


%% �q�X�g�O�����ϓ�����p�����R���g���X�g�̋����F�r���Ԋu�̒��������āA�t���b�g�ɂȂ�悤��
Gray2 = histeq(Gray, 256);
figure;imhist(Gray2);
%% �\��
figure;imshow([Gray1 Gray2]);

%% �R���g���X�g�ɐ�����t�����K���q�X�g�O�����ϓ��� %%%%%
%     �f�t�H���g�F8x8�s�N�Z���̃^�C�����Ƀq�X�g�O�����ϓ���
% �t���b�g�ȃq�X�g�O����
Gray3 = adapthisteq(Gray,'Distribution','uniform');
figure;imhist(Gray3);
%% �\��
figure;imshow([Gray1 Gray3]);

%% �x���^�q�X�g�O����
Gray4 = adapthisteq(Gray,'Distribution','rayleigh');
figure;imhist(Gray4);
%% �\��
figure;imshow([Gray3 Gray4]);

%% �Ȑ��q�X�g�O����
Gray5 = adapthisteq(Gray,'Distribution','exponential');
figure;imhist(Gray5);
%% �\��
figure;imshow([Gray3 Gray4 Gray5]);

%% �Ȑ��q�X�g�O����: �R���g���X�g�����̐����𒲐�
Gray6 = adapthisteq(Gray,'Distribution','exponential', 'ClipLimit', 1);
figure;imhist(Gray6);
%% �\��
figure;imshow([Gray3 Gray4 Gray5 Gray6]);

%% �I��

% imshowpair�́A�f�t�H���g�ł͋P�x���X�P�[�����O�����̂Œ���
% Copyright 2014 The MathWorks, Inc.
