clc;close all;imtool close all;clear;

%% �摜�̓Ǎ��݁E�\��
I = imread('I2_09_0_washers7s.JPG');                 % �摜�̓Ǎ���
imtool(I);                                           % �\��

%% �~�̌��o�ic:���S�_�Ar:���a�j�A����
[c, r] = imfindcircles(I, [30 45], 'Sensitivity', 0.9);       %�f�t�H���g�ł́A�w�i�������邢���̂�T���B���a25~55�s�N�Z��

%% ���ʂ̕\��
ind_l = r > 37
I3 = insertShape(I, 'Circle', [c(ind_l,:), r(ind_l)], 'Color','blue', 'LineWidth',3);
I4 = insertShape(I3, 'Circle', [c(~ind_l,:), r(~ind_l)], 'Color','green', 'LineWidth',3);

I5 = insertText(I4, [20, 1], ['Count: Large=' num2str(nnz(ind_l)) ', Small=' num2str(nnz(~ind_l))], 'TextColor','white', 'FontSize',24);
figure;imshow(I5);

%% �I��









% Copyright 2014 The MathWorks, Inc.
%     �����ŁArgb2gray�ŃO���[�X�P�[���ɕϊ�
