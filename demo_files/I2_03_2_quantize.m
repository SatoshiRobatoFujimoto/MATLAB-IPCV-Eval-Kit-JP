clear all;clc;close all;imtool close all

%% �O���[�X�P�[���ϊ� %%%%%%%%
A = imread('I2_03_peppers_low.png');
figure;imshow(A);
%%
Gray = rgb2gray(A);
h=figure;imshow(Gray);

%% �R���g���X�g���� %%%%%%%%
figure;imhist(Gray);     % �P�x�l�̃q�X�g�O������\��
%% �R���g���X�g�����c�[���Ŏ蓮����
imcontrast(h)
%% ��E���P�x��1%�O�a����悤��������
Gray1 = imadjust(Gray);
figure;imhist(Gray1);
%% �\��
figure;imshow([Gray Gray1]);shg

%% �ʎq�� (2�l��) %%%%%%%%
I = imread('coins.png');
figure;imshow(I);
%%
figure;imhist(I);        % �P�x�l�̃q�X�g�O������\��
%%
BW = I > 100;            % �P�x�l 100��臒l�ɗʎq��
figure;imshow(BW);
%%
BWf = imfill(BW, 'hole');  % ���𖄂߂�(�����t�H���W�[����)
figure;imshow(BWf);

%% ���l�����ʎq�� %%%%%%%
I = imread('I2_03_2_circlesBrightDark_clean1.png');
imtool(I);                   % �e�̈�̒l���m�F
%%
figure;imhist(I);            % �q�X�g�O�����\��
%%
thresh = multithresh(I,2)     % Otsu�@�ɂ��臒l���v�Z (�֐��̖ߒl��臒l)
                              % �N���X�Ԃ̕����x���ő�ɂ���
seg_I = imquantize(I,thresh); % ����ꂽ臒l�ɂ��A��f�l��ʎq��(1,2,3)
imtool(seg_I,[]);             % �\�� => ��f�l�̊m�F
%%
RGB = label2rgb(seg_I);       % �قȂ郉�x���ԍ�(��f�l)���قȂ�F��
figure;imshowpair(I,RGB,'montage');  % �摜�\��

%% �I��
















%% (�Q�l) 'I2_3_peppers_low.png' �t�@�C���̐���
A=imread('peppers.png');
aa=A*0.5 + 70;
imwrite(aa,'I2_3_peppers_low.png')

%% (�Q�l) 'circlesBrightDark_clean1.png' �̐���
I = imread('circlesBrightDark.png');
B1= (I > 10) & (I < 220);
I(B1) = 50;

B1= (I < 40)
I(B1) = 10;

B1= (I > 220)
I(B1) = 230;

imshow(I)
imhist(I)

r = randn(512)*2;    % �����̐���
max(r(:))
min(r(:))

I1 = int16(I)+int16(r);
min(I1(:))
max(I1(:))
I2 = uint8(I1)

imhist(I2)
figure;imshow(I2)

imwrite(I2, 'I2_3_2_circlesBrightDark_clean1.png');


% Copyright 2014 The MathWorks, Inc.
