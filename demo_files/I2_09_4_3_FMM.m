%% �����}�[�`���O�@��p�����A�摜�̗̈敪��
clc;close all;imtool close all;clear;

%% �摜�̓Ǎ���
G = imread('cameraman.tif');
figure; imshow(G);

%% �J�n�ʒu���w�肷��ׂ̓�l�摜�쐬
seed = false(size(G));      % �S�č��̉摜�̍쐬
imshow(seed); shg;          % �\��
%%
seed(170:180, 70:80) = true;  % x=70~80, y=170~180 �̗̈�𔒂�
figure; imshowpair(G, seed, 'montage');shg;   % ���ׂĕ\��

%% [�X�e�b�v�P] �d�ݔz����v�Z�F�e��f�̌��z�̋t�� %%%%%%%%%%%%%%%
%    �o��(�d��)�͌��z�̑傫���ɔ����F�G�b�W=>�d�ݏ�
sigma = 2;    % �K�E�V�A���̕W���΍�
W = gradientweight(G, sigma);
figure, imshowpair(G, log(W), 'montage');    % ���R�ΐ��X�P�[���ŕ\��

%% [�X�e�b�v�Q] ���߂��d�݂𗘗p���āA�Z�O�����e�[�V����
thresh = 0.1;
[BW, D] = imsegfmm(W, seed, thresh);
figure; imshow(D);   % �v�Z���ꂽ�A�ő�1�ɋK�i�����ꂽ���n�������s��iSeed���炻�̃s�N�Z���܂ŁB�d�݂��l���j

%% �Z�O�����e�[�V��������
figure; imshow(BW)


%% �d��(�R�X�g�̋t)�z����v�Z�F�J�n�_��f�l�Ƃ̍�����v�Z
%    seed�̈�̕��ς��g�p�A�o��(�d��)�͍��ɔ����F������=>�d�ݑ�
W = graydiffweight(G, seed, 'GrayDifferenceCutoff', 25);   %���̍ő��25�ŖO�a
figure, imshowpair(G, log(W), 'montage');    % ���R�ΐ��X�P�[���ŕ\��

%% ���߂��d�݂𗘗p���āA�Z�O�����e�[�V����
thresh = 0.01;
[BW, D] = imsegfmm(W, seed, thresh);
figure; imshow(D);   % �v�Z���ꂽ�A�K�i�����ꂽ���n�������s��iSeed���炻�̃s�N�Z���܂Łj
%% �Z�O�����e�[�V��������
imtool(BW)



%%
% Copyright 2015 The MathWorks, Inc.
