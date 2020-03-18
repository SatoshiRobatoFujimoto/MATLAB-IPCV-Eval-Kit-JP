%% �X�e���I���s�� (Stereo Image Rectification)
%    SURF�����_�ɂ��}�b�`���O
%    estimateFundamentalMatrix()         : ��b�s������߂�
%    estimateUncalibratedRectification() : �X�e���I���s���̂��߂̎ˉe�ϊ��s������߂�

clear all;clc;close all;imtool close all
%% Step 1: ���E�̉摜�̓Ǎ��E�O���[�X�P�[�����A�\��
I1 = rgb2gray(imread('yellowstone_left.png'));
I2 = rgb2gray(imread('yellowstone_right.png'));
figure; imshowpair(I1, I2,'montage');truesize; % ���E�ɕ��ׂĕ\��
      % �E�̊G�͉������Ă���E���ɂ���Ă��܂�
%% �d�˂ĕ\��
figure;imshow(stereoAnaglyph(I1, I2));truesize;
      
%% Step 2: �����_�̌��o
blobs1 = detectSURFFeatures(I1, 'MetricThreshold', 2000);
blobs2 = detectSURFFeatures(I2, 'MetricThreshold', 2000);

%% Step 3: �����ʂ̒��o��\��
[features1, validBlobs1] = extractFeatures(I1, blobs1);
[features2, validBlobs2] = extractFeatures(I2, blobs2);
figure; imshow(I1); hold on; plot(validBlobs1.selectStrongest(30),'showOrientation',true);
figure; imshow(I2); hold on; plot(validBlobs2.selectStrongest(30),'showOrientation',true);

%% Step 4: ���E�̓����_�̃}�b�`���O�����Ή��_�����߂�E�\��
indexPairs = matchFeatures(features1, features2, 'Metric', 'SAD', ...
  'MatchThreshold', 5);

matchedPoints1 = validBlobs1(indexPairs(:,1),:);
matchedPoints2 = validBlobs2(indexPairs(:,2),:);
figure; showMatchedFeatures(I1, I2, matchedPoints1, matchedPoints2);
legend('Points in I1', 'Points in I2');

%% Step 5: ��b�s��i���E�̉摜�̈ʒu�֌W�j�����߂� (outlier������)
[fMatrix, epipolarInliers, status] = estimateFundamentalMatrix(...
  matchedPoints1, matchedPoints2, 'Method', 'RANSAC', ...
  'NumTrials', 10000, 'DistanceThreshold', 0.1, 'Confidence', 99.99);
fMatrix            % 3x3�̍s��̕\��

% �G���[�`�F�b�N
if status ~= 0 || isEpipoleInImage(fMatrix, size(I1)) ...
  || isEpipoleInImage(fMatrix', size(I2))
  error(['Either not enough matching points were found or '...
         'the epipoles are inside the images. You may need to '...
         'inspect and improve the quality of detected features ',...
         'and/or improve the quality of your images.']);
end

% matchedPoints ����AInlier�̂��̂̂ݔ����o��
inlierPoints1 = matchedPoints1(epipolarInliers);
inlierPoints2 = matchedPoints2(epipolarInliers);

%% Step 5: �X�e���I���s���E�����_�̏d�Ȃ��̕\��
%     (���E�̉摜���ꂼ��̎ˉe�ϊ��s������߂�)
[t1, t2] = estimateUncalibratedRectification(fMatrix, ...
  inlierPoints1.Location, inlierPoints2.Location, size(I2));
tform1 = projective2d(t1);    %�ˉe�ϊ��s����􉽊w�ϊ��N���X��
tform2 = projective2d(t2);

% ���E�̉摜���􉽊w�ϊ���A�o�͂���̈��World���W�n�Ŏw��
I1Rect = imwarp(I1, tform1, 'OutputView', imref2d(size(I1)));
I2Rect = imwarp(I2, tform2, 'OutputView', imref2d(size(I2)));

% �}�b�`���O�m�F�̂��߁A�����_���􉽊w�ϊ����A�}�b�`���O�\��
%    ����́A�������̂� �i�G�s�|�[������X���ƕ��s�j
pts1Rect = transformPointsForward(tform1, inlierPoints1.Location);
pts2Rect = transformPointsForward(tform2, inlierPoints2.Location);

figure; showMatchedFeatures(I1Rect, I2Rect, pts1Rect, pts2Rect);
legend('Inlier points in rectified I1', 'Inlier points in rectified I2');

%% �d�Ȃ��Ă��镔���̂ݐ؏o��
%    ��-�V�A���̃X�e���I���K�l�ŁA3D�摜���ώ@
Irectified = cvexTransformImagePair(I1, tform1, I2, tform2);
figure, imshow(Irectified);truesize;
title('Rectified Stereo Images (Red - Left Image, Cyan - Right Image)');

%% �I��






%% Disparity�}�b�v�̌v�Z
d = disparity(Irectified(:,:,1), Irectified(:,:,2), 'BlockSize', 21,'DisparityRange', [-6 10], 'UniquenessThreshold', 0);

% -realmax('single') �ƁA�U��؂�Ă��܂���Pixel�̒l���A
% ����ȊO��pixel�̍ŏ��l�ɒu��������
marker_idx = (d == -realmax('single'));
d(marker_idx) = min(d(~marker_idx));

% Disparity�}�b�v�̕\���B�J�����ɋ߂���f���A���邭�\���B
figure; imshow(mat2gray(d));

%% �\�ʃv���b�g���g���\��
figure; surf(mat2gray(d));shading interp;xlabel('X');ylabel('Y');axis ij

%% 

%figure;imshowpair(I1Rect, I2Rect, 'montage');truesize;
%figure;imshow(cat(3,I1Rect, I2Rect, I2Rect));truesize; %�d�Ȃ��Ă��Ȃ��Ƃ�����\�������ꍇ



%  Copyright 2004-2014 The MathWorks, Inc.

