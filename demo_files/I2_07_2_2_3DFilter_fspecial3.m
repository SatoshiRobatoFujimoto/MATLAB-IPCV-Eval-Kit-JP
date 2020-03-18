%% MRI�摜��3�����K�E�V�A���t�B���^�����O
clear; clc; close all;    % ������

%% MRI�摜�̃��[�h
load mristack

% ����
intensity = [0 20 40 120 220 1024];
alpha = [0 0 0 0 0.38 0.5];
color = ([0 0 0; 43 0 0; 103 37 20; 199 155 97; 216 213 201; 255 255 255]) ./ 255;
queryPoints = linspace(min(intensity),max(intensity),256);
alphamap = interp1(intensity,alpha,queryPoints)';
colormap = interp1(intensity,color,queryPoints);
figure;
volshow(mristack,'Colormap',colormap,...
    'Alphamap',alphamap,'ScaleFactors',[1 1 10]);

%% 3D�ȉ~�t�B���^�[�ɂ��X���[�W���O
H = fspecial3('ellipsoid',[7 7 3]);
volSmooth = imfilter(mristack,H,'replicate');
figure;
volshow(volSmooth,'Colormap',colormap,...
    'Alphamap',alphamap,'ScaleFactors',[1 1 10]);

%% 3D�\�[�x���G�b�W�t�B���^�[�ɂ��G�b�W���o
H = fspecial3('sobel','Y');
edgesHor = imfilter(mristack,H,'replicate');

alpha = [0 0 0 0 0 0.5];
queryPoints = linspace(min(intensity),max(intensity),256);
alphamap = interp1(intensity,alpha,queryPoints)';

figure;
volshow(edgesHor,'Colormap',colormap,...
    'Alphamap',alphamap,'ScaleFactors',[1 1 10]);

%% Copyright 2018 The MathWorks, Inc.
