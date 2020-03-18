%% �􉽊w�I�ϊ�
clear, clc, close all, imtool close all

%% �摜�̓Ǎ���\��
I = imread('I2_05_1_ExpTrf.jpg');    % �ϐ��錾�s�v�A�������z��
imtool(I)                            % GUI �c�[���i���ɂ����X�j

%% �ϊ���̕\���̈� (257 x 211)
figure;imshow(ones(257,211));

%% �ʑ��̊�ƂȂ�4�_��ݒ肵�ċ�ԕϊ�(�ˉe�ϊ�)�\���̂��쐬
Porig = [235 424; 483 424; 727 533; 130 533];   % [X,Y] ����̓_���玞�v���
Ppost = [1 1; 211 1; 211 257; 1 257];    % �c256�A��210                   % Ppost = bbox2points([1, 1, 210, 256])   �ł���
T = fitgeotrans(Porig, Ppost,'projective');                               % projective2d �N���X�i�ϊ��s��Ǝ����j
T.T             % �������ꂽ�s��̊m�F

%% �􉽊w�I�ϊ���A���ʂ�\��
%    imref2d:�o�͉摜�̈��World���W�n�Ŏw�� size�̏o�͂Ɠ����t�H�[�}�b�g�F[�c ��]
Iw = imwarp(I, T, 'OutputView', imref2d([257 211]));              % OutputView���w�肵�Ȃ��ƁA�摜�̑��݂���BoundingBox�̍��オ���_
imshow(Iw);shg;                                                   % �f�t�H���g�͐��`���

%%
% Copyright 2014 The MathWorks, Inc.


%%
G = rgb2gray(Iw);
imageSegmenter(G);

colorThresholder;    % I5_02_cars\DSC_3078a.JPG    �M��
I = imread('I5_03_1_ocr\IMG_2521_sign40.JPG');
G = rgb2gray(I);
imtool(G);
imageSegmenter;
imageRegionAnalyzer;
