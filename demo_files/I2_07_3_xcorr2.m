%% ���K�����ꂽ 2�������ݑ���
clear all;clc;close all;imtool close all

%% �摜�̓Ǎ��݁E�\��
BW = imread('text.png');
BW(60:end,:) = [];
figure;imshow(BW);

%% �e���v���[�g�̍쐬�E�\��
tPlate = BW(32:46,88:98);
figure, imshow(tPlate);

%% ���K�����ꂽ 2�������ݑ���
corr = normxcorr2(tPlate, BW);        % �Б� (a�̃T�C�Y-1)/2 �Â傫���Ȃ�
corr1 = corr(8:66, 6:261);            % ���̃T�C�Y�Ɠ����ɔ����o��
figure;surf(corr1); shading interp;
set(gca, 'Ydir', 'reverse');          % ��������_��

%% ���ւ̍����Ƃ�������o
corrLoc = corr1 > 0.95;
[row, col] = find(corrLoc)
corrLoc1 = [col,row]
I = insertMarker(im2uint8(BW), corrLoc1, 'Circle','Color','red');
figure; imshow(I);

%%
% Copyright 2014 The MathWorks, Inc.


