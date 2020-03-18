clear; close all; clc;

%% �摜�̓Ǎ��݁E�\��
I = imread('visionteam1.jpg');
figure;imshow(I);

%% �l�̌��o : ACF�A���S���Y��
detector = peopleDetectorACF;
[bboxes, scores] = detect(detector, I)

%% ���ʂ̕\��
I1 = insertObjectAnnotation(I, 'rectangle', bboxes, scores, 'FontSize',16, 'LineWidth',3);
figure, imshow(I1);
title('Detected people and detection scores');

%% �I��












%% �l�̌��o�FHOG������ ���g���ꍇ
peopleDetector = vision.PeopleDetector;
[bboxes, scores] = step(peopleDetector, I)


%% Copyright 2014 The MathWorks, Inc.
