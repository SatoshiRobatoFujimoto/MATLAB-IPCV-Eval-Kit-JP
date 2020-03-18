%% �P�x�x�[�X�̎������W�X�g���[�V�����i�ʒu�����j
clear all; close all; clc;

%% 2�̉摜�̓Ǎ��E�\��
orig  = dicomread('knee1.dcm');
moving = dicomread('knee2.dcm');
figure; imshowpair(moving, orig, 'montage');    %���ׂĕ\��
%%
imshowpair(moving, orig);shg;                   %�d�˂ĕ\��

%% �P�x�x�[�X�̃��W�X�g���[�V�������s�E�\��  �i�ϊ��s�񂪕K�v�ȏꍇ�́Aimregtform ���g�p�j
[optimizer,metric] = imregconfig('multimodal'); % �p�����^�ݒ� (�ʁX�̃f�o�C�X�F�قȂ�P�x�͈�)
optimizer.MaximumIterations = 150;           % ������
optimizer.InitialRadius = 0.002;             % ���������͈�

Registered = imregister(moving, orig, 'affine', optimizer, metric);      %�A�t�B���ϊ��F�g��k���E���s�ړ��E��]
figure, imshowpair(Registered, orig)            % �\��

%% [�I��]
% Copyright 2014 The MathWorks, Inc.




















%% �V���v���Ȑ}�`1
G1 = zeros([16,20], 'uint8')
G1(5, 3:12) = [10:10:100]
G2 = zeros([16,20], 'uint8')
G2(5, 6:15) = [10:10:100]

[optimizer,metric] = imregconfig('monomodal'); % �p�����^�ݒ�
tform = imregtform(G2, G1, 'translation', optimizer, metric)
tform.T
G3 = imwarp(G2, tform, 'OutputView',imref2d(size(G1)));
% ���ʂ̉���
G1(5,:)
G2(5,:)
G3(3:7,:)

%% �V���v���Ȑ}�`2 (�T�u�s�N�Z���P�ʂ̃��W�X�g���[�V����)
G1 = zeros([16,20], 'uint8')
G1(5, 3:7)  = [10:10:50]
G1(5, 8:11) = [40:-10:10]
G2 = zeros([16,20], 'uint8')
G2(5, 6:10) = [5:10:45]
G2(5, 11:15) = [45:-10:5]

[optimizer,metric] = imregconfig('monomodal'); % �p�����^�ݒ�
tform = imregtform(G2, G1, 'translation', optimizer, metric, 'PyramidLevels',1)
tform.T
G3 = imwarp(G2, tform, 'OutputView',imref2d(size(G1)));
% ���ʂ̉���
G1(5,:)
G2(5,:)
G3(3:7,:)
%% 
