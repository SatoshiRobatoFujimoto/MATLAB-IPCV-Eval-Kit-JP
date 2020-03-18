close all; clear all; clc;

%% �O����C�R�[�h�iread_raw_main.c�j��MEX�֐������A
%    MATLAB����Ăяo����悤�ɂ���
% ���炩���߁A  mex -setup   ��C�R���p�C���̐ݒ���s���Ă���
% edit read_raw.c         % ���ꂪ���b�p�[�t�@�C���B
                          % ���L�w�b�_�t�@�C�����C���N���[�h����Ă���
                          %      #include "mex.h"
                          % void mexFunction( ���`��
                          %    ���̒��ŊO��C�R�[�h���Ăяo�����Ă���
mex read_raw.c read_raw_main.c

%% �o�C�i���� RAW�摜�f�[�^�ǂݍ��ݥ�\��
%      �������ꂽ�Aread_raw.mexw64 ��Call����B
raw = read_raw('I3_04_1_onion_wHeader.raw', 1);
imtool(raw,[])

%% �I��













%% [�Q�l] Column major �� Little Endian Raw�f�[�^ �̐����X�N���v�g
I = imread('onion.png');
G = rgb2gray(I);
figure;imshow(G);
G16 = im2uint16(G);
figure;imshow(G16);

fid = fopen('I3_04_1_onion_wHeader.raw','w');
fwrite(fid, size(G16,1), 'uint16');    % Hight
fwrite(fid, size(G16,2), 'uint16');    % Width
fwrite(fid, G16, 'uint16');            % image data
fclose(fid);

%% Copyright 2014 The MathWorks, Inc.

