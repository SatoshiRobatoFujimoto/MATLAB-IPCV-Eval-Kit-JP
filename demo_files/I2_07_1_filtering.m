%% ���O��`�^�t�B���^�ifspecial�֐��j
clear;clc;close all;imtool close all

%% �摜�̓Ǎ���
I = imread('cameraman.tif');
figure;subplot(2,2,1);imshow(I);title('Original Image'); 

%% average filter
F = fspecial('average',5)
ImagAve = imfilter(I,F);
subplot(2,2,2);imshow(ImagAve);title('���ω��t�B���^');shg;
%% laplacian filter (�񎟔���)
F = fspecial('laplacian')
ImagSob = imfilter(I,F);
subplot(2,2,3);imshow(ImagSob);title('���v���V�A���t�B���^');shg;
%% motion filter
F = fspecial('motion',20,45)
ImagMotion = imfilter(I,F);
subplot(2,2,4);imshow(ImagMotion);title('���[�V�����t�B���^');shg;

%% �I��









%% ��s��
ImagSharpen = imsharpen(I);
figure;imshowpair(I, ImagSharpen, 'montage');
%% gaussian filter
F = fspecial('gaussian', [5 5], 3)
ImagSharp = imfilter(I,F);
figure;imshow(ImagSharp);title('�K�E�V�A���t�B���^');
%% disk filter
F = fspecial('disk',10)
ImagSharp = imfilter(I,F,'replicate');
figure;imshow(ImagSharp);title('�~�󕽋ω��t�B���^');
%% log filter
F = fspecial('log')
ImagLog = imfilter(I,F);
figure;imshow(ImagLog);title('�K�E�X�̃��v���V�A�� �t�B���^');

%% 
% Copyright 2014 The MathWorks, Inc.




