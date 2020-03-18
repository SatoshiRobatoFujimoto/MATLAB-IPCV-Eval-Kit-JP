%% ������
clc;close all;clear;

%% Raw�f�[�^�̓Ǎ���
fid = fopen('I2_01_1_onion.raw', 'r', 'b');            % �t�@�C�����J���@���[�h:�ǎ��A�r�b�N�G���f�B�A��
G = (fread(fid, [198, 135], '*uint16', 'b'))'; % �t�@�C���̓Ǎ��݁E�]�u�B*������Əo�͂������^�Bb�F�r�b�N�G���f�B�A��
figure;imshow(G);                              % �\��
fclose(fid);                                   % �t�@�C�������

%% �������}�b�s���O���g�����Ǎ���
%  ������ �}�b�s���O�́A�f�B�X�N��̃t�@�C���̈ꕔ�܂��͑S�̂��A
%  �A�v���P�[�V�����̃A�h���X��ԓ��̈��̃A�h���X�͈͂�
%  �}�b�s���O������@�ł��B����ɂ���ăA�v���P�[�V�����ł́A
%  ���I�������ւ̃A�N�Z�X�Ɠ��l�Ƀf�B�X�N��̃t�@�C���ɃA�N�Z�X�ł���悤�ɂȂ�܂��B
%  fread �� fwrite �Ȃǂ�IO�֐����g�p����ꍇ�ɔ�ׁA
%  �t�@�C���̓ǂݎ��Ə������݂����������܂��B
% 
% ��K�̓t�@�C���Ƀ����_���A�N�Z�X����ꍇ�⏬���ȃt�@�C���ɕp�ɂɃA�N�Z�X����ꍇ���ɂ� 
m = memmapfile('I2_01_1_onion.raw')
m.Format =  'uint16'               % Endian�́AOS�ŗL�̂��̂��g���� (Windows�FLittle)

% Endian�̕ύX
I1 = mod(m.Data, 256) * 256 + (m.Data/256);   % m.Repeat = Inf�Ȃ̂ŁA�S�f�[�^���捞��
figure;imshow(reshape(I1, 198, 135)');

% memmapfile�̃N���A
clear m;

%% �I��





%% [�Q�l] �T���v���f�[�^�̐����X�N���v�g�iRaw�f�[�^�̏��o���j
g = im2uint16(rgb2gray(imread('onion.png')));   % �摜�̓Ǎ��F135x198 pixels
imtool(g);

fid = fopen('I2_01_1_onion.raw', 'w', 'b');  % �t�@�C�����J���@���[�h:�����݁A�r�b�O�G���f�B�A��
fwrite(fid, g', 'uint16', 'b');      % �r�b�O�G���f�B�A���ŏ��o��
fclose(fid);                         % �t�@�C�������

%% Copyright 2014 The MathWorks, Inc.

