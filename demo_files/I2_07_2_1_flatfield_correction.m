%% �t���b�g�t�B�[���h�ɂ��V�F�[�f�B���O(�e)�̕␳

%% �摜�̓ǂݍ���
I = imread('fabric.png');
figure
subplot(2,1,1), imshow(I), title('���摜');
% �Ɩ����s�ψ�ŊO�����Â�

%% �t���b�g�t�B�[���h�␳
Iflatfield = imflatfield(I, 20);
subplot(2,1,2), imshow(Iflatfield)
title('�������摜, \sigma = 20')

%%
% Copyright 2018 The MathWorks, Inc.
