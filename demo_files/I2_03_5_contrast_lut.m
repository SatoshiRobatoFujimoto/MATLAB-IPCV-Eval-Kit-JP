%% �R���g���X�g���� �p�̊e��֐� %%%%%%%%
clear;clc;close all;imtool close all

%% �摜�Ǎ���
G = rgb2gray(imread('I2_03_peppers_low.png'));  % �O���[�X�P�[���֕ϊ�
figure;imshow(G);

%% ���b�N�A�b�v�e�[�u���̍쐬 (�摜��uint8�̏ꍇ�Auint8��256�v�f�̃e�[�u�����쐬)
in  = [0 1 70 120 180 255];
out = [0 1 15 150 230 255];
figure; plot(in,out); ylim([0 255]);
%% �敪�I 3 ���G���~�[�g���}�������œ��}
LUT = uint8(interp1(in, out, 0:255, 'pchip'));
hold on;
plot(LUT);
hold off;

%% ���b�N�A�b�v�e�[�u���K�p ()
G1 = intlut(G, LUT);
figure;imshow([G, G1]);
%% �I��

% imshowpair�́A�f�t�H���g�ł͋P�x���X�P�[�����O�����̂Œ���
% Copyright 2014 The MathWorks, Inc.
