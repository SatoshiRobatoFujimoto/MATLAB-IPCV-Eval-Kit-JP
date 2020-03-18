clear;clc;close all;imtool close all

%% �J���t���ȑ@�ۂ̃C���[�W�̓ǂݍ���
i = imread('fabric.png');
imtool(i);

%% HSV��Ԃ֕ϊ�
iHSV = rgb2hsv(i);
imtool(cat(3, iHSV(:,:,1), iHSV(:,:,3), iHSV(:,:,2)));

%% �΂̗t�̕����̒��o
i2 = (0.18 < iHSV(:,:,1)) & (iHSV(:,:,1) < (0.18+0.35)) & ...
     (0.16 < iHSV(:,:,3));
imtool(i2);

%% �����Ȃ��݂�����
i3 = bwareaopen(i2, 10);
imtool(i3);
mask=cat(3, i3, i3, i3);

%% �t�����̂ݕ\��
i_leaf = i;
i_leaf(~mask) = 0;
figure,imshow(i_leaf);

%%
% Copyright 2014 The MathWorks, Inc.
