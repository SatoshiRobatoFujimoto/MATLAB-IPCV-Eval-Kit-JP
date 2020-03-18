clear all;clc;close all;imtool close all

%% �摜�̓Ǎ���
I = imread('saturn.png');
figure; imshow(I);

%% YCbCr�F��Ԃ֕ϊ�
YCbCr = rgb2ycbcr(I);
Y = YCbCr(:,:,1);      % �����ł�Y�̂�DCT�ϊ�
imshow(Y);shg

%% 2�������U�R�T�C���ϊ�
fun = @(block_struct) dct2(block_struct.data);  % �����֐��̃n���h��:�J�b�R���ɖ����֐��̈����B�X�e�[�g�����g��1�̂݉B
DCT = blockproc(Y, [8 8],fun);   % fun�Ƀu���b�N�\���̂�n��:�K�v�ɉ�����'BorderSize'���w��
imtool(log(abs(DCT)+1),[]);      % ���ʂ̕\��

%% �I��










%% ������CPU�R�A��p��������v�Z�I�v�V�����iParallel Computing Toolbox�K�v�j
%  ����v�Z�p�� MATLAB �Z�b�V�����̃v�[�����J��
parpool

%% ����I�v�V��������
tic;   % �������Ԃ̑���
DCT = blockproc(Y, [8 8],fun);   % fun�Ƀu���b�N�\���̂�n��
t1=toc

%% ����v�Z�I�v�V�������I��
tic;
DCT = blockproc(Y, [8 8],fun, 'UseParallel', true);
t2=toc

%% ���s���x���P�̊������v�Z
t2/t1

%% ����v�Z�p�� MATLAB �Z�b�V�����̃v�[�������
delete(gcp('nocreate'))

%% 
% Copyright 2014 The MathWorks, Inc.

