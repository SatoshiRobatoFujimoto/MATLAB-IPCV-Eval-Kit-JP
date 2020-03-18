clear;clc;close all;imtool close all

%% �e���v���[�g�}�b�`���O�p�̃I�u�W�F�N�g�쐬
htm=vision.TemplateMatcher;

%% �摜�̎捞�݁E�O���[�X�P�[����
I = im2double(imread('board.tif'));
I = I(1:200,1:200,:);      % �摜���傫���̂ňꕔ�؂�o��
Igray = rgb2gray(I);
figure;imshow(Igray);

%% �e���v���[�g�摜�̐����E�\��
T = Igray(20:75,90:135);
figure; imshow(T);

%% �e���v���[�g�}�b�`���O�̎��s
Loc = step(htm, Igray, T)            % �e���v���[�g���S�ɑΉ�������W [x y]

%% ���������ꏊ�Ƀ}�[�L���O�E���ʉ摜�̕\��
J = insertShape(I, 'FilledCircle', [Loc, 10], 'Opacity', 1, 'Color', 'red');
figure; imshow(J); title('Marked target');

%% �I��
% Copyright 2014 The MathWorks, Inc.











%% Metric matrix �̎擾
release(htm);
htm=vision.TemplateMatcher('OutputValue','Metric matrix', 'OverflowAction','Saturate');    % �摜��uint8�ׁ̈A�����͌Œ菬���_���[�h
mat = step(htm,Igray,T);
imtool(mat);

%% �e���v���[�g��]�u���A�������̂��Ȃ��ꍇ
T1 = T';
figure; imshow(T1);
%% �e���v���[�g�}�b�`���O�̎��s
release(htm);
htm=vision.TemplateMatcher('BestMatchNeighborhoodOutputPort',true, 'NeighborhoodSize',1);
[Loc val] =step(htm, Igray, T)

