clear all;clc;close all;imtool close all

%% �G�b�W���o %%%%%%%%
I = imread('coins.png');        % �摜�̓Ǎ�
figure; imshow(I);              % �\��
%%
BWsobel   = edge(I,'sobel');               % �\�[�x���@
figure;imshow(BWsobel  ); title('sobel');
%%
BWcanny = edge(I,'canny');                 % �L���j�[�@
figure;imshow(BWcanny); title('canny');

%% �R�[�i�[���o %%%%%%%%
I = checkerboard(50,2,2);     % �e�X�g�摜�̐���
figure;imshow(I);
%%
C = detectHarrisFeatures(I);   % Harris�R�[�i�[���o��
%C = detectMinEigenFeatures(I); % �ŏ��ŗL�l�@
I1 = insertMarker(I,C,'circle','Size',5,'Color','magenta');
imshow(I1);shg;

%% �Z���e�[�v�F�n�t�ϊ��ɂ��~�̌��o %%%%%%%%
RGB = imread('tape.png');
figure;imshow(RGB);
%% �~�̌��o
[center, radius] = imfindcircles(RGB,[60 100],'Sensitivity',0.9)      %���a60~100
%% �~�ƒ��S�_�̕\��
viscircles(center,radius);                  % �~��`��
hold on; plot(center(:,1),center(:,2),'yx','LineWidth',4); hold off; % ���S�_�\��

%% �I��











%% �~���o �̒ǉ��̃f��
G = imread('I2_09_1_circlesBrightDarkSquare.png');  % �摜�̓Ǎ���
figure;imshow(G);                     % �\��
% �w�i���Â��~�̌��o��Ԑ��ŕ\��
[cDark, rDark] = imfindcircles(G,[30 65],'ObjectPolarity','dark')
viscircles(cDark, rDark,'LineStyle','--');shg;
% �w�i��薾�邢�~�̌��o����ŕ\��
[cBright, rBright] = imfindcircles(G,[30 65],'ObjectPolarity','bright','EdgeThreshold',0.2)
viscircles(cBright, rBright,'EdgeColor','b');shg;




%% [�Q�l]
% �~�̌��o�E�~�ƒ��S�_�̕\����A���a�l���摜��ɏ�����
message = sprintf('The estimated radius is %2.1f pixels', radius);
text(15,300,sprintf('radius : %2.1f', radius), 'Color','y','FontSize',20);

% �~�ƒ��S�_���摜�f�[�^�ɏ����ޏꍇ
Ir = insertShape(RGB, 'Circle', [center radius], 'Color','red', 'LineWidth',4);
Ir = insertShape(Ir, 'FilledCircle', [center 5], 'Color','yellow', 'Opacity',1);
imtool(Ir);

%% [�Q�l] �~���o�̃f���摜�̍쐬�X�N���v�g
G = imread('circlesBrightDark.png');  % �摜�̓Ǎ���
G1 = insertShape(G,'FilledRectangle',[179,188,90,90],'Color','white','Opacity',1);
G1 = insertShape(G1,'FilledRectangle',[50,335,80,80],'Color','black','Opacity',1);
imwrite(G1, 'I2_09_1_circlesBrightDarkSquare.png')

%%
% Copyright 2014 The MathWorks, Inc.

