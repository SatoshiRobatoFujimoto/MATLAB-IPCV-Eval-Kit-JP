%% �摜�̓�l����K����l��
clc;clear;close all;imtool close all;

%% �摜�̓Ǎ��ݥ�\�� %%%%%%%%%%%%%%%%%%%%%%%
G = imread('coins.png');
figure; imshow(G);

%% Otsu�@�ɂ��A��ǓI�������l�ɂ��摜���l��
BW = imbinarize(G);
figure; imshow(BW);

%% ���𖄂߂�
BWf = imfill(BW, 'holes');
figure; imshow(BWf);

%% �摜�̓Ǎ��ݥ�\�� %%%%%%%%%%%%%%%%%%%%%%%%
G = imread('printedtext.png');
figure; imshow(G);

%% �P�x�̋Ǐ����ς�p���A��f�P�ʂœK���������l�v�Z
T = adaptthresh(G, 0.4, 'ForegroundPolarity','dark');  % �����������O�i
figure; imshow(T);  % �������l�̉���

%% �Z�o�����������l�ŁA�摜���l����\��
BW = imbinarize(G, T);
imshow([G; BW*256]); truesize; shg;     % ���摜�����ʂ��A�c�ɕ��ׂĕ\��

%% �I��











%% �ʂ̉摜�̓Ǎ��ݥ�\�� %%%%%%%%%%%%%%%%%%
G = imread('rice.png');
figure; imshow(G);

%% �摜��K����l����\��
BW = imbinarize(G, 'adaptive', 'sensitivity',0.4);
figure; imshowpair(G, BW, 'montage');

%% Copyright 2016 The MathWorks, Inc.
