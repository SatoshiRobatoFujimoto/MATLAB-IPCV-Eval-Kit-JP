clear;clc;close all;imtool close all

%% �摜�̓Ǎ��݁E�\��
I = imread('I5_03_1_ocr\IMG_2521_sign40.JPG');
figure;imshow(I);

%% �Ԃ��̈�𒊏o
HSV = rgb2hsv(I);
areaRed = ((HSV(:,:,1) >= 0.9 ) | (HSV(:,:,1) <= 0.05 )) & ...
          (HSV(:,:,2) >= 0.8 );
figure;imshow(areaRed);

%% �����ȃS�~������
areaRed1 = bwareaopen(areaRed,500);
figure;imshow(areaRed1);

%% �ԂɈ͂܂�Ă��镔���𒊏o
areaRedFilled = imfill(areaRed1,'holes');   %�Ԃň͂܂�Ă��镔���𖄂߂�
G = rgb2gray(I);
G(~areaRedFilled)=255;     %�Ԃň͂܂�Ă��镔���𒊏o
figure;imshow(G); 

%% �Ԃ�����������
areaRed2 = imdilate(areaRed1,ones(11));   % �Ԃ����������������c��
G(areaRed2)=255;                          % �ԐF����������
figure;imshow(G); 

%% �����F��
results = ocr(G)

%% �����̕\��
Ir = insertObjectAnnotation(I, 'rectangle', results.WordBoundingBoxes, results.Words, 'FontSize',50);
imtool(Ir);

%% ���͍쐬
sentense = ['�������x�́A' results.Words{1} '�L���ł��B']    % ���{��Ǐグ�̕���
%sentense = ['Speed limit is ' results.Words{1}]             % �p��Ǐグ�̕���

%% �ǂݏグ (���{�ꉹ�������G���W���͕ʓr����v)
NET.addAssembly('System.Speech');   %.NET�A�Z���u���̓Ǎ���
speak = System.Speech.Synthesis.SpeechSynthesizer; speak.Volume = 100;
speak.SelectVoice('������');
speak.Speak(sentense);

%% �ǂݏグ (�p�ꉹ�������G���W����Windows�ɕt��)
NET.addAssembly('System.Speech');   %.NET�A�Z���u���̓Ǎ���
speak = System.Speech.Synthesis.SpeechSynthesizer; speak.Volume = 100;
speak.SelectVoice('Microsoft Anna')
speak.Speak(sentense);


%% �I��









%% ���{��̓ǂݏグ�ɂ́A�ʓr���{�ꉹ�������G���W�����K�v
%  �p��Ɋւ��Ă�Windows�ɓ���

%% �e���o�̈�̊m�x��\������ꍇ
%Ic = insertObjectAnnotation(G, 'rectangle', results.WordBoundingBoxes, results.WordConfidences, 'FontSize', 30);
%imtool(Ic);

%% ocr���s�O�ɁA�֐�������Otu�@�ɂ��2�l������Ă��܂�
%G = rgb2gray(I);imtool(im2bw(G,graythresh(G)))

% Copyright 2014 The MathWorks, Inc.
