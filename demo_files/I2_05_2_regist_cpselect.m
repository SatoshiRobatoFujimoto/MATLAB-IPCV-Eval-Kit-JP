%% 2�̉摜�̈ʒu����(���W�X�g���[�V����)
clear;clc;close all;imtool close all

%% �摜�ǂݍ���
aerial = imread('westconcordaerial.png');
figure, imshow(aerial)
ortho = imread('westconcordorthophoto.png');
figure, imshow(ortho)

%% ���O�ɑI�����������̓_��ǂݍ���
load westconcordpoints

%% �R���g���[�� �|�C���g�I���c�[�����J���܂��B
% �ǉ��̓_��I�����邽�߁A'Wait' �p�����[�^�[���g�p���āAcpselect ��ҋ@��Ԃɂ��܂��B
[aerial_points,ortho_points] = ...
       cpselect(aerial,'westconcordorthophoto.png',...
                movingPoints,fixedPoints,...
                'Wait',true);
%% ���W�X�g���[�V���������s
% fitgeotrans ���g�p���āA�ړ��C���[�W���Œ�C���[�W�Ɉʒu���킹����􉽊w�I�ϊ��𐄒肵�܂��B
% �I�������R���g���[�� �|�C���g�ƕK�v�ȕϊ��^�C�v���w�肵�܂��B
t_concord = fitgeotrans(aerial_points,ortho_points,'projective');

%% imwarp ���g�p���ĕϊ������s
ortho_ref = imref2d(size(ortho)); %relate intrinsic and world coordinates
aerial_registered = imwarp(aerial,t_concord,'OutputView',ortho_ref);
figure, imshowpair(aerial_registered,ortho,'blend')

%%  ���̐��ˎʐ^��ɕϊ���̃C���[�W��\��
% ���W�X�g���[�V�����̌��ʂ��m�F
figure, imshowpair(aerial_registered,ortho,'blend')

%% �I��

% Copyright 2014 The MathWorks, Inc.
