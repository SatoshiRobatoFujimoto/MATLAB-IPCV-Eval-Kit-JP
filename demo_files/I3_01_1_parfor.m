clear all;clc;close all;imtool close all

%% �摜�̓Ǎ��ݥ�P�x�ƐF�������̕���
I = imread('saturn.png');
figure; imshow(I);

%% �P�x�ɑ΂���DCT���v�Z
YCbCr = rgb2ycbcr(I);      % YCbCr�F��Ԃ֕ϊ�
fun = @(block_struct) dct2(block_struct.data);  % �����֐��̃n���h����`
tic;
DCTy = blockproc(YCbCr(:,:,1), [8 8],fun);
t0=toc
imtool(log(abs(DCTy)+1),[]);                     % �ΐ��\��

%% 2�������U�R�T�C���ϊ� (Y������Cb����)
tic;
for i = 1:2
  DCTycb(:,:,i) = blockproc(YCbCr(:,:,i), [8 8],fun);
end
t1=toc

%% ����v�Z�p�� MATLAB �Z�b�V�����̃v�[�����J��
parpool

%% ���񏈗��ō�����
tic;
parfor i = 1:2
  DCT(:,:,i) = blockproc(YCbCr(:,:,i), [8 8],fun);
end
t2=toc

%% ���񉻂ɂ�鍂���������̌v�Z�i2��ڈȍ~�Ŋm�F�j
t2/t1

%% ����v�Z�p�� MATLAB �Z�b�V�����̃v�[�������
delete(gcp('nocreate'))

%% 


% Copyright 2018 The MathWorks, Inc.