clear;clc;close all;imtool close all

%% �摜�̓Ǎ���
Inuts = imread('I2_07_2_1_nuts.png');
figure;imshow(Inuts);

%% ���ω��t�B���^�[
Iave    = imfilter(Inuts,fspecial('average',5)); %���ω��t�B���^
imshow([Inuts Iave]);truesize;shg;

%% Guided filter (R2014a)
Iguided = imguidedfilter(Inuts);       %�G�b�W�ۑ��^�̕�����
imshow([Inuts Iave Iguided]);truesize;shg;

%%
% Copyright 2014 The MathWorks, Inc.

