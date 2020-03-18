%% �R���s���[�^�r�W�����f���F��F��
% �摜�f�[�^�����[�h
I = imread('visionteam.jpg');
figure; imshow(I);

%% ���̔F���I�u�W�F�N�g�̒�`�A���s [�Q�s��MATLAB�R�[�h]
%     ��F���p�̃g���[�j���O���ꂽ�f�[�^�͓���
detector = vision.CascadeObjectDetector();
faces = step(detector, I)

%% ���o���ꂽ��̈ʒu�ɁA�l�p���g�ƃe�L�X�g��ǉ�
I2 = insertObjectAnnotation(I, 'rectangle', faces, [1:size(faces,1)], 'FontSize',18);
figure; imshow(I2);

release(detector);

%% 
% Copyright 2014 The MathWorks, Inc.

