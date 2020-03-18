clear;clc;close all;imtool close all

%% �摜�̓Ǎ��ݥ�\��
G = imread('I5_03_1_ocr\IMG_2517_cable.jpg');
figure;imshow(G);

%% �����̂���������i���������ȕ����̏����j
G1 = imopen(G, ones(6));     %���k=>�c��
figure;imshow(G1);

%% �{�g���n�b�g�����ŁA���̕����݂̂��c��
G2 = imbothat(G1, ones(18));   %Close - ����
figure;imshow(G2);

%% �����F��
results = ocr(G2)

%% �e���o�̈�̊m�x��\��
Ic = insertObjectAnnotation(G2, 'rectangle', results.WordBoundingBoxes, results.WordConfidences, 'FontSize', 30);
imtool(Ic);

%% �m�x�̍��������݂̂�\��
valid = (results.WordConfidences > 0.6) & ~strcmp(results.Words, '')   %�m�x��0.5�ȏ�̂��̂���o���B���s�̌��o���ʂ�����
Ir = insertObjectAnnotation(G, 'rectangle', results.WordBoundingBoxes(valid,:), results.Words(valid), 'FontSize',40);
imtool(Ir);

%%












%% �����ɂ��ǂݏグ
NET.addAssembly('System.Speech');   %.NET�A�Z���u���̓Ǎ���
speak = System.Speech.Synthesis.SpeechSynthesizer; speak.Volume = 100;
speak.SelectVoice('������');
words = results.Words(valid);
speak.Speak(['�ŏ��̔ԍ��́A' words{1}]);



%% �����ɂ��ǂݏグ (�p�ꉹ�������G���W����Windows�ɕt��)
NET.addAssembly('System.Speech');   %.NET�A�Z���u���̓Ǎ���
speak = System.Speech.Synthesis.SpeechSynthesizer;
speak.Volume = 100;
words = results.Words(valid);
speak.Speak(['The first number is' words{1}]);



%% �I��







%% ���{��̓ǂݏグ�ɂ́A�ʓr���{�ꉹ�������G���W�����K�v
%  �p��Ɋւ��Ă�Windows�ɓ���

%% �摜�̓Ǎ��ݥ�\��
G = imread('I5_3_ocr\IMG_2517_cable.jpg');
figure;imshow(G);
%% �����F���iROI���g�p�j
results2 = ocr(G, [2020 900 790 380])
results2 = ocr(G, [1900 900 890 380])
results2 = ocr(G, [1800 900 1000 380])
results2 = ocr(G, [1990 900 800 380])
%% �e���o�̈�̊m�x��\��
Ic2 = insertObjectAnnotation(G, 'rectangle', results2.WordBoundingBoxes, results2.WordConfidences, 'FontSize', 30);
imtool(Ic2);

%% ���ʂ̕\��
Ir2 = insertObjectAnnotation(G, 'rectangle', results2.WordBoundingBoxes, results2.Words, 'FontSize',40);
imtool(Ir2);

%% �I��




%% ���ׂĂ̕�����ǂݏグ��ꍇ
speak.Speak('�ԍ���');
words = regexprep(results.Words(valid), '$', ' ','emptymatch')   % ������̍Ō�ɃX�y�[�X��}��
speak.Speak([words{:}]);

%% �����ɂ��ǂݏグ (English)
NET.addAssembly('System.Speech');   %.NET�A�Z���u���̓Ǎ���
speak = System.Speech.Synthesis.SpeechSynthesizer; speak.Volume = 100;
words = results.Words(valid);
speak.Speak(words{1});

%% �ʂ̏����X�e�b�v
G1 = imerode(G, ones(4));     %�������������A���𑾂��������肳����
G2 = imbothat(G1, ones(19));  %�{�g���n�b�g�����Ŏ��̕����̂ݎ�o��
results = ocr(G2)             %OCR

% Copyright 2014 The MathWorks, Inc.
