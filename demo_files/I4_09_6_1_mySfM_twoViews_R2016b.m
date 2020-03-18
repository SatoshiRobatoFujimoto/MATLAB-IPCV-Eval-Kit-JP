%% 2�̉摜����́AStructure From Motion
%     �L�����u���[�V�����ς݂̃J�����ŎB�e����2����2�����摜����A
%     3D�\���\�z�ƁA���ꂼ��̉摜�ɑΉ�����J�����ʒu��p������
% [�t���[]
%  [���ꂼ��̉摜�ɑ΂���A�J�������Ȉʒu��p������]
%   1: 2�̉摜�őa�ȑΉ��_��T��
%      �i�摜1��������_���o���A�摜2�փ|�C���g�g���b�N�j
%      �i�����_���o�Ɠ����ʃ}�b�`�B���O�̕��@������j
%   2: ��{�s��̐���i2�̉摜�̑Ή��֌W�j�ƁA��Ή��_�̏���
%   3: ��{�s��ƑΉ��_���W��p���A�J����1�ɑ΂���A�J����2�̈ʒu��p���𐄒�
%  [3�����č\�z]
%   4: �J����1�2�̈ʒu��p���֌W����A���ꂼ��̃J�����s��(World���W�Ɖ摜�̍��W�̊֌W)���v�Z
%   5: 2�̉摜�Ŗ��ȑΉ��_���ĒT��
%   6: ���ꂼ��̃J�����s���p���A�Ή��_��3�����ʒu���v�Z
%  [���X�P�[���֕␳]
%   7: �傫�������m�̕��̂�_�Q�Ƀt�B�e�B���O���A�_�Q�̃X�P�[�����v�Z
%   8: ���߂��X�P�[����p���āA��΃X�P�[����3�����_�Q�֕ϊ�

clc;clear;close all;imtool close all; rng('default');

%% 2���̉摜�̓Ǎ��݁E�\��
imgDir = [matlabroot '\toolbox\vision\visiondata\upToScaleReconstructionImages\'];
I1 = imread([imgDir 'globe1.jpg']);
I2 = imread([imgDir 'globe2.jpg']);
figure; imshowpair(I1, I2, 'montage'); title('Original Images');truesize;

%% ���ꂼ��̉摜���烌���Y�c�̏���
load upToScaleReconstructionCameraParameters.mat  % �J�����p�����[�^�̓Ǎ��݁i�����p�����[�^�E�c�W���j
I1u = undistortImage(I1, cameraParams);
I2u = undistortImage(I2, cameraParams);
imshowpair(I1u, I2u, 'montage'); title('Undistorted Images');truesize;shg;

%% [���ꂼ��̉摜�ɑ΂���A�J�������Ȉʒu��p������] %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2�̉摜�ԂőΉ�����_��������
% �摜1���̑a�ȃR�[�i�[�_�����o�E�\�� (��400�_)
%      ��ʑS�̂ɖ��ՂȂ����o���邽�߁AMinQuality�ݒ�ŁA���o�����R�[�i�[�_����ጸ
imagePoints1 = detectMinEigenFeatures(rgb2gray(I1u), 'MinQuality', 0.1);
figure; imshow(I1u); truesize;
hold on; plot(imagePoints1);

%%
% �ړ����������̂ŁA�|�C���g�g���b�J�[��p���摜�Ԃ̑Ή��_��T��
% �悸�|�C���g�g���b�J�[�̃I�u�W�F�N�g�𐶐�
tracker = vision.PointTracker('MaxBidirectionalError', 1, 'NumPyramidLevels', 5);
% �摜1��̃R�[�i�[�_�̍��W�Ń|�C���g�g���b�J�[��������
initialize(tracker, imagePoints1.Location, I1u);
% �|�C���g�g���b�J�[�ŁA�摜2��̑Ή��_������
[imagePointsLoc2, validIdx] = step(tracker, I2u);
% ���ʂ̕\��
matchedPoints1 = imagePoints1.Location(validIdx, :);
matchedPoints2 = imagePointsLoc2(validIdx, :);
figure; showMatchedFeatures(I1u, I2u, matchedPoints1, matchedPoints2);  % Figure���Ŋg�債�Ċm�F

%% ��{�s��̐���E��Ή��_(outlier)�̏�������ʂ̕\��
%  �i2�̉摜��̓_�̑Ή��֌W�����߁A�G�s�|�[���S���𖞂����Ȃ��_�������j
[E, epipolarInliers] = estimateEssentialMatrix(...
      matchedPoints1, matchedPoints2, cameraParams, 'Confidence', 99.99);

inlierPoints1 = matchedPoints1(epipolarInliers, :);
inlierPoints2 = matchedPoints2(epipolarInliers, :);
figure;
showMatchedFeatures(I1u, I2u, inlierPoints1, inlierPoints2); title('Epipolar Inliers');

%% �摜1�ɑ΂���A�摜2�̃J�����ʒu��p��(Orientation)���v�Z
%    �X�P�[���s��̂��߁AL(�ʒu)�͒P�ʃx�N�g���Ɖ���
%    O : Orientation�AL�FLocation
[O, L] = relativeCameraPose(E, cameraParams, inlierPoints1, inlierPoints2)

%% 2��̃J�����ʒu�֌W������
figure; grid on; hold on
plotCamera('Size',0.1,'Color','b','Label','start');  % 1�Ԗڂ̃J���������_�ɕ`��
plotCamera('Location',L, 'Orientation',O, 'Size',0.1, ...
                      'Color','r','Label','finish');
xlabel('X'); ylabel('Y'); zlabel('Z'); view(3);
xlim([-0.4 1.4]);ylim([-0.3 0.3]);zlim([-0.2 1.6]);box on;
axis equal

%% [3�����č\�z] %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �J����1�2�̈ʒu��p���̊֌W����A���ꂼ��̃J�����s��(World���W�Ɖ摜�̍��W�̊֌W)���v�Z
%      World���W�̌��_���摜1�̃J�����ʒu�A�J�����̕�����Z���̐��ɂ���
t1 = [0 0 0];      % �J����1��World���W���_�Ɛݒ�i���i�ړ��Ȃ��j
R1 = eye(3);       % �J����1��World���WZ���̐������Ɛݒ�i��]�Ȃ��j
%t2 = -L*O';       % �J����2�ւ̕��i�x�N�g���i�O���p�����[�^�j
%R2 = O';          % �J����2�ւ̉�]�s��i�O���p�����[�^�j
[R2, t2] = cameraPoseToExtrinsics(O, L);     % R2016b
camMatrix1 = cameraMatrix(cameraParams, R1, t1);
camMatrix2 = cameraMatrix(cameraParams, R2, t2);

%% 2�̉摜�ŁA���ȑΉ��_���Č���
% MinQuality�������āA������(����)�����_���Ō��o
roi = [30, 30, size(I1u, 2) - 30, size(I1u, 1) - 30];   % �摜�[������
imagePoints1 = detectMinEigenFeatures(rgb2gray(I1u), 'ROI',roi, 'MinQuality', 0.001);

% �|�C���g�g���b�J�[�̃I�u�W�F�N�g���ēx����
tracker = vision.PointTracker('MaxBidirectionalError', 1, 'NumPyramidLevels', 5);
% �|�C���g�g���b�J�[���A�摜1��̖��ȓ����_���W�ŏ�����
initialize(tracker, imagePoints1.Location, I1u);

% �|�C���g�g���b�J�[�ŁA�摜2��̑Ή��_������
[imagePointsLoc2, validIdx] = step(tracker, I2u);
matchedPoints1 = imagePoints1.Location(validIdx, :);
matchedPoints2 = imagePointsLoc2(validIdx, :);

%% �Ή��_���ꂼ��́A3�����ʒu���v�Z
points3D = triangulate(matchedPoints1, matchedPoints2, camMatrix1, camMatrix2);         % Direct Linear Transformation (DLT) algorithm

% �摜1���炻�ꂼ��̓_�̐F���𒊏o
numPixels = size(I1u, 1) * size(I1u, 2);
allColors = reshape(I1u, [numPixels, 3]);
colorIdx = sub2ind([size(I1u, 1), size(I1u, 2)], round(matchedPoints1(:,2)), ...
    round(matchedPoints1(:, 1)));
color = allColors(colorIdx, :);

% 3�����_�Q�̐��� (pointCloud�N���X)
ptCloud = pointCloud(points3D, 'Color', color)

%% �č\�z���ꂽ3�����_�Q�̕\��
figure; grid on; hold on
plotCamera('Size', 0.3, 'Color', 'r', 'Label', '1', 'Opacity', 0);
plotCamera('Location', L, 'Orientation', O, 'Size', 0.3, ...
                  'Color', 'b', 'Label', '2', 'Opacity', 0);
pcshow(ptCloud, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down', ...
              'MarkerSize', 45);
camorbit(0, -30);     % ����p�x����]
xlabel('X'); ylabel('Y'); zlabel('Z');
xlim([-6 6]);ylim([-5 5]);zlim([-1 15]);box on;title('�C�ӃX�P�[��')

%% [���X�P�[���֕␳] %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �_�Q�ɁA�����t�B�b�e�B���O���Ēn���V�̈ʒu�����o��\��
globe = pcfitsphere(ptCloud, 0.1)    % ���̃t�B�b�e�B���O�i�ő勗���덷0.1�j
plot(globe);      % �����d�ˏ���
hold off; shg;

%% �n���V�̊��m�̑傫����p���A��΋����̓_�Q�ɕϊ�
scaleFactor = 10 / globe.Radius;    % �n���V�̔��a:10cm
ptCloud = pointCloud(points3D * scaleFactor, 'Color', color);
Ls = L * scaleFactor;        % �J�����ʒu2�̍��W����΋����֕ϊ�

% ��΋����ŁA�ĉ���
figure; grid on; hold on;
plotCamera('Size', 2, 'Color', 'r', 'Label', '1', 'Opacity', 0);
plotCamera('Location', Ls, 'Orientation', O, 'Size', 2, ...
                'Color', 'b', 'Label', '2', 'Opacity', 0);
pcshow(ptCloud, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down', ...
                'MarkerSize', 45);
camorbit(0, -30);
xlabel('X (cm)'); ylabel('Y (cm)'); zlabel('Z (cm)');
xlim([-40 40]);ylim([-30 30]);zlim([-5 85]);box on;

%% Copyright 2016 The MathWorks, Inc.
