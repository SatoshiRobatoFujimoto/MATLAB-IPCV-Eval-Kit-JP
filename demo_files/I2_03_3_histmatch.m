%% 2���̉摜�Ԃ́A�q�X�g�O�����̃}�b�`���O
clear;clc;close all;imtool close all

%% �摜�̓Ǎ��ݥ�\��
Ref = imread('I2_03_3_knee1a.tif');  % �G��MRI�C���[�W�̓Ǎ���
  A = imread('I2_03_3_knee1b.tif');
figure;imshow([Ref A]);
  
%% �q�X�g�O�����\��
figure;
subplot(2,2,1);imhist(Ref);title('���t�@�����X');
subplot(2,2,2);imhist(  A);

%% �q�X�g�O�����̃}�b�`���O
B = imhistmatch(A, Ref, 256);  % A�̃q�X�g�O������Ref�Ɉ�v������
subplot(2,2,4);imhist(B);title('��������'); shg;

%% ���ʂ̕\��
figure;imshow([Ref repmat(239,[512 20]) B]);

%% �I��

% imshowpair�́A�f�t�H���g�ł͋P�x���X�P�[�����O�����̂Œ���









%% (�Q�l) ���ׂĕ\������ۂɁA���Ԃ��󂯂�ꍇ
figure;imshow([Ref repmat(239,[512 20]) A]); 

%% (�Q�l) knee1a.jpg, knee1b.jpg�̍쐬�X�N���v�g
K1 = dicomread('knee1.dcm');   % read in original 16-bit image
max(K1(:))
Ref = uint8(K1/2);
% build concave bow-shaped curve for darkening Reference image
ramp = [0:255]/255;
ppconcave = spline([0 .1 .50  .72 .87 1],[0 .025 .25 .5 .75 1]);
Ybuf = ppval( ppconcave, ramp);
Lut8bit = uint8( round( 255*Ybuf ) );
% pass image Ref through LUT to darken image
A = intlut(Ref,Lut8bit);
figure;imshow([Ref A]);
% �q�X�g�O�����\��
figure;
subplot(1,2,1);imhist(Ref);
subplot(1,2,2);imhist(  A);
% ���o��
imwrite(Ref, 'knee1a.tif');
imwrite(A, 'knee1b.tif');
%% �I��
% Copyright 2014 The MathWorks, Inc.
