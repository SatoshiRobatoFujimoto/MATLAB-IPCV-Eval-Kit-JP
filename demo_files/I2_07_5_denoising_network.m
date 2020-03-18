%% �f�m�C�W���OCNN�����[�h('DnCNN')
net = denoisingNetwork('DnCNN');

%% �O���C�X�P�[���摜��ǂݍ��݁A�K�E�V�A���m�C�Y�t��
I = imread('cameraman.tif');
noisyI = imnoise(I,'gaussian',0,0.01);
figure
imshowpair(I,noisyI,'montage');
title('Original Image (left) and Noisy Image (right)')

%% �f�m�C�W���O�l�b�g���[�N���g���ăm�C�Y����
denoisedI = denoiseImage(noisyI, net);
figure
imshow(denoisedI)
title('Denoised Image')

%% 
% Copyright 2018 The MathWorks, Inc.

