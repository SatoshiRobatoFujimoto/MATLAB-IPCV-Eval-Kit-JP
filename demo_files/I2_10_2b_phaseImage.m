%% �ʑ��摜�̐���
clear;clc;close all;imtool close all

%% �摜�̓Ǎ���
G = imread('coins.png');
figure;imshow(G);

%% 2������FFT�v�Z�F��������[�����g���W��(DC����)
F = fft2(G);
figure;imshow(log(abs(F)), []);colormap(jet); colorbar;    % DC�����������

%% fftshift�֐���p���A�[�����g���W��(DC����)�����������A���S�ֈړ�
%     ���ی��Ƒ�O�ی��A���ی��Ƒ�l�ی������ւ�
Fs = fftshift(F);
figure;imshow(log(abs(Fs)), []);colormap(jet); colorbar;

%% �e�����l��U���Ő��K�� (�S�Ă̎��g�������������U��)
Fn = F ./ abs(F);

%% �t�t�[���G�ϊ�
Gr = ifft2(Fn);
figure; imshow(Gr, []);

%% �I��









%%
% Copyright 2015 The MathWorks, Inc.


