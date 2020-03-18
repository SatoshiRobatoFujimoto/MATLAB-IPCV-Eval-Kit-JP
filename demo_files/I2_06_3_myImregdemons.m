%% �񍄑̂̃��W�X�g���[�V���� (2�����E3�����̃O���[�X�P�[���摜)
clear;clc;close all;imtool close all;

%% �Q�̉摜�̓Ǎ���
fixed  = imread('hands1.jpg');      % �ʒu�����̃^�[�Q�b�g
moving = imread('I2_06_3_hands2a.jpg');
figure;imshow([fixed, moving]);

%% �O���[�X�P�[���֕ϊ���d�˂ĕ\��
fixed  = rgb2gray(fixed);
moving = rgb2gray(moving);
figure;imshowpair(fixed,moving);

%% �O���[�X�P�[������ׂĕ\��
figure;subplot(2,1,1); imshow([fixed, moving]);

%% [�O����] �q�X�g�O�����}�b�`���O��p���āA�P�x�̍���␳
moving = imhistmatch(moving,fixed);
subplot(2,1,2); imshow([fixed, moving]);

%% �ψʏ�s������߂�  �ifixed��̊e�s�N�Z�����́AX,Y�����̕ψʁj
D = imregdemons(moving, fixed, [500 400 200]);    %�����񐔁F500��(��𑜓x), 400��, 300��(���𑜓x)

%% �ψʂ̉���
flow = opticalFlow(D(:,:,1), D(:,:,2));
figure;imshow(fixed);
hold on
plot(flow,'DecimationFactor',[10 10],'ScaleFactor',1); shg;
hold off

%% �􉽊w�I�ϊ��E�\��
movingReg = imwarp(moving, D);
figure;imshow([moving, movingReg]);
title('�􉽊w�I�ϊ��̑O��', 'FontSize', 16);

%% �ʒu�����̃^�[�Q�b�g�摜�Əd�˂ĕ\��
figure;imshowpair(fixed, movingReg);

%% �I��
















%% �V���v���Ȑ}�`�ł̏���
fixed = zeros(100);
moving = fixed;
fixed(50:59, 30:39)=1;
fixed(50:59, 55:64)=1;
moving(50:59, 30:39)=1;
moving(50:59, 45:54)=1;        % �E��10�s�N�Z���ړ�

figure; subplot(1,2,1); imshow(fixed);
        subplot(1,2,2); imshow(moving); shg;
figure;imshowpair(fixed, moving);        
%
D = imregdemons(moving, fixed, [500 400 200], 'AccumulatedFieldSmoothing',0.5);    %�����񐔁F500��(��𑜓x), 400��, 300��(���𑜓x)
% �􉽊w�I�ϊ��E�\��
movingReg = imwarp(moving, D);
imtool(movingReg);
figure;imshowpair(fixed, movingReg);    % �قڈ�v���Ă���

%% �ψʏ�̉���
flow = opticalFlow(D(:,:,1), D(:,:,2));
figure;imshow(moving);
hold on
plot(flow,'DecimationFactor',[5 5],'ScaleFactor',1); shg;
hold off
%% �ψʏ�̒l�̊m�F
D(55, 30:69, 1)          % D�̒l�Ffixed�̑Ή�����_�̈ړ�

%% �Q�l�Fhands2a.jpg �̐����X�N���v�g
I = imread('hands2.jpg');
ycbcr = rgb2ycbcr(I);
ycbcr(:,:,1) = ycbcr(:,:,1)*0.8;
I1 = ycbcr2rgb(ycbcr);
imwrite(I1, 'I2_06_2_hands2a.jpg');

%% Copyright 2014 The MathWorks, Inc.
