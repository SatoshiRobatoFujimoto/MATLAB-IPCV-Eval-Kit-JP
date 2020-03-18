%% GPU���� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �����ݒ�
clc;close all;imtool close all;clear all;
g=gpuDevice,reset(g);                   % GPU�f�o�C�X�ւ̃I�u�W�F�N�g���擾
a=imrotate(gpuArray(uint8(0)),1);       % GPU�p�֐��̃������[�ւ̓Ǎ���

%% �摜�̓Ǎ��݁E�\��
I = imread('saturn.png');
I1 = rgb2gray(repmat(I, 6,6));   % �c�� �e�U�{�̃T�C�Y��
figure;imshow(I1);

%% CPU ��ł̏������Ԃ̌v���E�\��
tic;
  I2 = imrotate(I1, 37, 'loose', 'bilinear');    % �傫�ȉ摜��37����]
t1 = toc

%% ���ʂ̕\��
figure;imshow(I2);

%% GPU�փf�[�^���R�s�[
Ig1=gpuArray(I1);

%% GPU ��ł̏������Ԃ̌v��
tic;
  Ig2 = imrotate(Ig1, 37, 'loose', 'bilinear');   % �傫�ȉ摜��37����]
  wait(g)                                         % �K���Atoc()���Ăяo���O�ɁA���ׂĂ̏�������������̂�҂�
t2 = toc

%% �䗦���v�Z
t1/t2

%% GPU �f�o�C�X�����Z�b�g���A���̃���������������
reset(g)


%% Copyright 2014 The MathWorks, Inc.

