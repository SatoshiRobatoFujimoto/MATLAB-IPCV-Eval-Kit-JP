%% �����_��p�������̂̌��o
clc;clear;close all;imtool close all;

%% �������镨�̂̉摜�̓Ǎ��ݥ�\��
Iref = imread('I4_02_1_p1a.jpg');
figure; imshow(Iref);

%% �񌟍��摜�̓Ǎ��ݥ�\��
I = imread('I4_02_1_p2a.jpg');
figure;imshow(I);

%% ���ꂼ��̉摜�ŁA�����_���o�E�\��
Gref = rgb2gray(Iref);        % �O���[�X�P�[���֕ϊ�
G    = rgb2gray(I   );

PointsRef = detectBRISKFeatures(Gref);  % �����_�̌��o
PointsI   = detectBRISKFeatures(G);

subplot(1,2,1); imshow(Iref); hold on;
plot(PointsRef.selectStrongest(100));     % ���100�|�C���g���v���b�g
subplot(1,2,2); imshow(I   ); hold on;
plot(PointsI.selectStrongest(100)); hold off; shg;

%% ������(Feature, ValidPoints)���o�A�\��
[FeaturesRef, vPointsRef] = extractFeatures(Gref, PointsRef, 'Method', 'BRISK');
[FeaturesI,   vPointsI  ] = extractFeatures(G,    PointsI,   'Method', 'BRISK');

subplot(1,2,1); imshow(Iref); hold on;
plot(vPointsRef.selectStrongest(100),'showOrientation',true);
subplot(1,2,2); imshow(I); hold on;
plot(vPointsI.selectStrongest(100),'showOrientation',true);hold off;shg;

%% ������(FeaturesRef,FeaturesI)�̃}�b�`���O�E���ʕ\��   (�ꕔ outlier ������)
indexPairs = matchFeatures(FeaturesRef, FeaturesI, 'MatchThreshold',30, 'MaxRatio',0.8);

matchedPointsRef = vPointsRef(indexPairs(:, 1));  % Iref��̈ʒu��o
matchedPointsI   = vPointsI(  indexPairs(:, 2));  % I��̈ʒu��o
figure;
showMatchedFeatures(Iref, I, matchedPointsRef, matchedPointsI, 'montage'); truesize;

%% �ϊ��s��̐���(RANSAC)�ƁA��Ή��_�̏����A���Ή��_�̕\��
[tform, inlierPointsRef, inlierPointsI] = ...
    estimateGeometricTransform(matchedPointsRef, matchedPointsI, 'projective', 'MaxDistance', 3);
figure; showMatchedFeatures(Iref, I, inlierPointsRef, inlierPointsI, 'montage');

%% ����ꂽ�ϊ��s��̕\��
tform.T

%% ����ꂽ�s��ŗ̈��ϊ����A���o������������ň͂�
PolygonRef = bbox2points([1 1 size(Iref, 2) size(Iref, 1)]);   %���摜�̎l��
newPolygonRef = transformPointsForward(tform, PolygonRef);    %�ϊ���̎l��

foundObj = insertShape(I, 'Polygon', reshape(newPolygonRef',[1 8]), 'Color','red', 'LineWidth',10);
figure; imshow(foundObj);

%% �I��






% 
% 
% 
% 
% %% �����������̂̈ʒu�𔒂��\��
% Orig = true(size(Iref(:,:,1)));
% foundObj = imwarp(Orig, tform, 'OutputView', imref2d(size(I)));
% figure; imshow(foundObj);
% 
% %% ���摜�ɏd�˂ĕ\��
% figure;imshowpair(I, foundObj, 'blend');
% 
% %% �����������̂̈ʒu�̊e����̎擾
% stats = regionprops(foundObj, 'Centroid')      % �̈�̏d�S
% 
% %% ��ӂ̊p�x (�|���S���̒�ӂ�2�_�̍��W����v�Z)
% angleBottom = atan2d( -1 * (newPolygonRef(2,3) - newPolygonRef(2,4)), ...
%                             newPolygonRef(1,3) - newPolygonRef(1,4)  )   % �P�ʂ͓x
% 
% %% �񌟍��摜��̕��̕����𒊏o
% croppedI = I;
% croppedI(repmat(~foundObj, [1 1 3])) = 0;
% figure; imshow(croppedI);
%                 
% %% �������̂̉摜���􉽊w�I�ϊ�
% convertedRef = imwarp(Iref, tform, 'OutputView', imref2d(size(I)));
% figure; imshow(convertedRef);
% 
% %% �L���ȑΉ��_�̐�
% inlierPointsRef.Count
% 
% %% ���̉摜��̓_��ϊ����A�c�����}�b�`���O�G���[���v�Z
% inlierPointsRef1 = transformPointsForward(tform, inlierPointsRef.Location);
% 
% dis = (inlierPointsI.Location - inlierPointsRef1) .^2
% dis1 = sum(sqrt(dis(:,1) + dis(:,2)))
% 
% 
% %% 
% 
% % Copyright 2015 The MathWorks, Inc.
