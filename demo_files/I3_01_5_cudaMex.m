%% �摜������GPU��Ŏ��s
% �ꕔ�̏����ɂ��āACUDA MEX�𐶐����ē���

clear all, close all, clc

%% �摜�f�[�^�ǂݍ���
imCPU = imread('concordaerial.png');

%% �f�[�^��GPU�ɓ]��
imGPU = gpuArray(imCPU);

%% �O���[�X�P�[���ϊ�
imGPUgray = rgb2gray(imGPU);

%% 2�l��
imWaterGPU = imGPUgray<70;

%% �ׂ����m�C�Y����
imWaterMask = imopen(imWaterGPU,strel('disk',4));
imWaterMask = bwmorph(imWaterMask,'erode',3);
imshow(imWaterMask)

%% �K�E�V�A���t�B���^�ŉ摜���ڂ���(PCT)
%blurH = fspecial('gaussian',20,5);
%imWaterMask = imfilter(single(imWaterMask)*10, blurH);
imWaterMask2 = myfilter(imWaterMask);

%% �F�̗v�f������
blueChannel  = imGPU(:,:,3);
blueChannel2  = imlincomb(1, blueChannel,6, uint8(imWaterMask2));
imGPU(:,:,3) = blueChannel2;

%% CPU�Ƀf�[�^��]�����A���ʂ�\��
outCPU = gather(imGPU);
imshow(outCPU)

%% CUDA MEX����
cfg = coder.gpuConfig('mex');
cfg.TargetLang = 'C++';
t = coder.typeof(gpuArray(false), [2036 3060]);
codegen -args {t} -config cfg myfilter

%% CUDA MEX�𗘗p���ăK�E�V�A���t�B���^�ȍ~�̏������Ď��s
% �K�E�V�A���t�B���^�ŉ摜���ڂ���(CUDA MEX)
imWaterMask2 = myfilter_mex(imWaterMask);

%% �F�̗v�f������
blueChannel2  = imlincomb(1, blueChannel,6, uint8(imWaterMask2));
imGPU(:,:,3) = blueChannel2;

%% CPU�Ƀf�[�^��]�����A���ʂ�\��
outCPU2 = gather(imGPU);
imshowpair(outCPU, outCPU2, 'montage')

%% 
% Copyright 2019 The MathWorks, Inc.