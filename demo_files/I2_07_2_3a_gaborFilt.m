%% �K�{�[���t�B���^
clc;clear;close all;imtool close all;

%% �g��:5pix/cycle�A�p�x:0�x (��)�̃K�{�[���t�B���^�̃I�u�W�F�N�g�𐶐���\��
g1 = gabor(5, 0)
figure; surf(real(g1.SpatialKernel));shading interp; xlabel('X'); ylabel('Y');
             axis ij; box on; colorbar; title('�g��:5pix/cycle�A�p�x:0�x');
             
%% �摜�̓Ǎ��ݥ�\��
G = imread('testpat1.png');
figure; imshow(G);

%% �摜�ɃK�{�[���t�B���^��K��
mag1 = imgaborfilt(G, g1);
figure; imshow(mag1, []);

%% �g��:5,10pix/cycle�A�p�x:0,45�x �̃K�{�[���t�B���^�o���N�̍쐬��\��
%      �g���ɂ��A�J�[�l���̃T�C�Y���ω�
g2 = gabor([5,10], [0,45])

sizeMax = size(g2(end).SpatialKernel, 1);
figure;
for p = 1:4
    subplot(2,2,p);
    size1 = size(g2(p).SpatialKernel,1);
    a = ones(sizeMax)*0.9;
    a(1:size1, 1:size1) = real(g2(p).SpatialKernel);
    imshow(a, []);
    title(sprintf('�g��= %d, �p�x = %d, Kernel size = %d', ...
            g2(p).Wavelength, g2(p).Orientation, size(g2(p).SpatialKernel,1)) );
end

%% �摜�ɃK�{�[���t�B���^�o���N��K����\��
mag2 = imgaborfilt(G, g2);

figure;
for p = 1:4
    subplot(2,2,p)
    imshow(mag2(:,:,p),[]);
    title(sprintf('�g��= %d, �p�x = %d, Kernel size = %d', ...
            g2(p).Wavelength, g2(p).Orientation, size(g2(p).SpatialKernel,1)) );
end

%%
% Copyright 2014 The MathWorks, Inc.
