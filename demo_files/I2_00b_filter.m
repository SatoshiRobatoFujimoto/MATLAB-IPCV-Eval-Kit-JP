clear all; close all; clc;

%% �摜�̎�荞��
I=imread('cameraman.tif');
figure; imshow(I);

%% ���ω��t�B���^�[����
Fave=fspecial('average');           % �t�B���^�[�W������
Iave=imfilter(I, Fave);             % �t�B���^�[����
I=[I Iave];                         % �E���ɕʂ̉摜���g��
figure; imshow(I);                  % �\��

%% �N��������
Ish=imsharpen(Iave, 'Amount', 3);      % �t�B���^�[�����A���x
figure; imshowpair(Iave, Ish, 'montage');% �����щ���

fspecial('average')
fspecial('average', 5)
edit fspecial      % fspecial�֐��̎����\�� or �֐��I���F4




%% �I��






%% ������
clear all; close all; clc;

%% ���Ԓl�t�B���^�[�ɂ��A�m�C�Y����
I = imread('peppers_noise.png');   % �摜�Ǎ��A���O��I
figure; imshow(I);                 % �\��
%%
Imedian = medfilt2(I, [3 3]);     % �m�C�Y����
figure; imshow(Imedian);          % �\��
%% �I��






% [fspecial�֐��̎����̕⑫]
%
% �Ⴆ��  fspecial('average',5) �̏ꍇ ==> type='average, p2=[5 5] �ƂȂ�
%
% <����>
% switch type
%  case 'average'               % Smoothing filter
%     siz = p2;                     % [5 5]
%     h   = ones(siz)/prod(siz);    % "�S�Ă̗v�f��1��5�s5��̍s��" / �v�f�̐� (5*5=25)


%% (�Q�l)  'peppers_noise.png' �̐����@
%N = rgb2gray(imread('peppers.png'));
%N = imnoise(N, 'salt', 0.1);           %���܉��m�C�Y��������
%imwrite(N, 'peppers_noise.png');


% Copyright 2014 The MathWorks, Inc.
