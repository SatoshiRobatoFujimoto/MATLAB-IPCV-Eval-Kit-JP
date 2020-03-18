%% �G�b�W�ۑ��������t�B���^(��@���g�U�t�B���^�A�o�C���e�����t�B���^)
%  �摜�ǂݏo��
I = imread('cameraman.tif');
imshow(I)
title('Original Image')
%% �ٕ����g�U�t�B���^�̓K�p
Idiffusion = imdiffusefilt(I);
%% �o�C���e�����t�B���^�̓K�p
% �ꕔ����؂�o���A�m�C�Y���x����]��
patch = imcrop(I,[170, 35, 50 50]);
patchVar = std2(patch)^2; 
% �m�C�Y�̕��U���x�����傫���l���X���[�W���O�̃��x���Ƃ��ăZ�b�g���A�o�C���e�����t�B���^��K�p
DoS = 2*patchVar;
J = imbilatfilt(I,DoS);

%% �K�E�X�t�B���^�̓K�p
sigma = 1.2;
Igaussian = imgaussfilt(I,sigma);

%% �e�t�B���^�������ʂ̔�r
montage({I,Idiffusion,J,Igaussian},'ThumbnailSize',[])
title('��@���g�U�t�B���^(�E��) vs. �o�C���e�����t�B���^(����) vs.�K�E�V�A���t�B���^(�E��)')
% ���オ���摜
% ��@���g�U�t�B���^��o�C���e�����t�B���^��
% �K�E�V�A���t�B���^���G�b�W���V���[�v�ɕێ������

%% 
% Copyright 2018 The MathWorks, Inc.