%% 2�����̍����t�[���G�ϊ��̃f��
clear;clc;close all;imtool close all

%% 256x256�̃e�X�g�摜�̐���
I = zeros(256,256);   % �v�f0��[256�s,256��]�̍s��̐���
I(5:24,13:17) = 1;    % ����ɔ����̈���쐬
figure;imshow(I);

%% 2������FFT�v�Z�F��������[�����g���W��(DC����)
F = fft2(I);
figure;imshow(log(abs(F)), [-1 5]);colormap(jet); colorbar;    % DC�����������

%% fftshift�֐���p���A�[�����g���W��(DC����)�����������A���S�ֈړ�
%     ���ی��Ƒ�O�ی��A���ی��Ƒ�l�ی������ւ�
Fs = fftshift(F);
figure;imshow(log(abs(Fs)), [-1 5]);colormap(jet); colorbar;

%% �c����ΐ��\��
figure;surf(log(abs(Fs))); shading interp; axis ij;xlabel('X');ylabel('Y');

%% �I��









%% �c�[�u���p�^�[��
I = [ones(256,2), zeros(256,2)];  % ������4�s�N�Z�������p�^�[��
I1 = repmat(I,[1,64]);            % 256x256 �s�N�Z���̉摜
imtool(I1);
F1 = fft2(I1);
Fs1 = fftshift(F1);
figure;surf(abs(Fs1)); shading interp; axis ij;xlabel('X');ylabel('Y');

%% �c�[�u���p�^�[�� (��2�̊K��T�C�Y)
I2 = repmat(I,[1,20]);            % 256x80 �s�N�Z���̉摜
imtool(I2);
F2 = fft2(I2);
Fs2 = fftshift(F2);
figure;surf(abs(Fs2)); shading interp; axis ij;xlabel('X');ylabel('Y');

%% �c�[�u���p�^�[�� (��2�̊K��T�C�Y�FFFT����2�̊K���)
F3 = fft2(I2, 256, 256);      % �摜�f�[�^��0���߂Ŕz��T�C�Y��傫�����A256x256�̌��ʂ𐶐�
Fs3 = fftshift(F3);
figure;surf(abs(Fs3)); shading interp; axis ij;xlabel('X');ylabel('Y');

%% �c�[�u���p�^�[�� (��2�̊K��T�C�Y�F�蓮��2�̊K��T�C�Y�֕ύX)
I3 = [I2, zeros(256,176)];
imtool(I3);
F3 = fft2(I3);
Fs3 = fftshift(F3);
figure;surf(abs(Fs3)); shading interp; axis ij;xlabel('X');ylabel('Y');

%%
% Copyright 2014 The MathWorks, Inc.


