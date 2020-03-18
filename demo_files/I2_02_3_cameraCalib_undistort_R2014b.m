%% �����Y�c�̕␳
clear;clc;close all;close all force

%% �J�����L�����u���[�V�����p�̉摜�̊m�F
imageFolder = fullfile(toolboxdir('vision'), 'visiondata', ...
    'calibration', 'mono');
winopen(imageFolder);

%% �A�v���P�[�V�����̋N��
squareSize = 29;  % ���ڈ�̃T�C�Y�i�P�ʁFmm�j
cameraCalibrator(imageFolder,squareSize);

%% ���肵���J�����p�����[�^�̓Ǎ�
%   (�������� �A�v���P�[�V�����̃L�����u���[�V�������ʂ��g�p)
load('I2_02_calibration_cameraParams');

%% �C�ӂ̑Ώۉ摜�̓Ǎ�
imds = imageDatastore(imageFolder);
origI = imds.readimage(1);
figure;imshow(origI)

%% �摜�̘c�␳��\�� :�f�t�H���g�ł́A"���o�͉摜�͓��T�C�Y,���_Origin�͕s��, i.e., newOrigin=(0,0)"
[undistI, ~] = undistortImage(origI, cameraParams);
figure;imshowpair(origI,undistI);truesize;

%% �I��















%% �J�����̊O���p�����[�^�̉����i�J�������Œ�j
figure; showExtrinsics(cameraParams, 'CameraCentric');

%% �摜��̓_���W�ɑ΂��ă����Y�c�␳
points = detectCheckerboardPoints(origI)
figure; imshow(origI);
hold on;
plot(points(:, 1), points(:, 2), 'g*');
hold off;

% �摜�ɑ΂��āA�����Y�c����
[undistI, newOrigin] = undistortImage(origI, cameraParams, 'OutputView','full');
% �_���W�ɑ΂��āA�����Y�c����
undistPoints = undistortPoints(points, cameraParams);
% �_���W�̃A���C�����g
undistPoints = [undistPoints(:,1) - newOrigin(1), undistPoints(:,2) - newOrigin(2)];

% ���ʂ̕\��
figure; imshow(undistI);
hold on;
plot(undistPoints(:, 1), undistPoints(:, 2), 'r*');
hold off;

%% �摜�̘c�␳(�S�̂��c��)��\��
[undistI, newOrigin] = undistortImage(origI, cameraParams, 'OutputView', 'full');
figure;imshowpair(origI, undistI, 'montage');

%% �摜��̓_���W���^����ꂽ�Ƃ��̘c�␳�E�\��
[points, boardSize] = detectCheckerboardPoints(origI)   % points�ɓ����Ă���_���W�����̂��Ƃɘc�␳
undistPoints = undistortPoints(points, cameraParams);   % �c�␳
figure;imshow(origI);hold on;
plot(undistPoints(:,1), undistPoints(:,2), 'g*');hold off;
%% (�c�␳�����摜�ɏd�ˍ��킹)
undistPoints = [undistPoints(:,1) - newOrigin(1), undistPoints(:,2) - newOrigin(2)];   % undistortImage�ŁA�摜�S�̂�����悤�ɉ摜�T�C�Y���ς��ݒ�ɂ������߁A�d�˂�ɂ͓_�̍��W�̈ړ����K�v
figure;imshow(undistI);hold on;
plot(undistPoints(:,1), undistPoints(:,2), 'g*');hold off;

%% �`�F�b�J�[�{�[�h���Œ肵�ĊO���p�����[�^�̕\�� %%%%%%%%%%%%%%%%%%
figure; showExtrinsics(cameraParams, 'PatternCentric');

%% �摜���`�F�b�J�[�p�^�[�����܂ނƂ��͈ȉ����\
%    �����Y�c�␳��A���̃`�F�b�J�[�p�^�[����World���W�n�̌��_�ɂ��āA
%    ����ɑ΂���J�����̈ʒu�i�O���p�����[�^�j����
squareSize = 150;   % �P�ʁFmm
worldPoints = generateCheckerboardPoints(boardSize, squareSize);  %World���W�n�ł̗��z�R�[�i�[�_���W���v�Z�B����̃R�[�i�[�_��(0,0)
% �c�␳�����摜����̌�_���W�EWorld���W�n�ł̌�_���W�ƁAcameraParams����intrinsics����A
%    ��](R)�ƕ��i(T)�̍s����v�Z�i�J�����̈ʒu�F�O���p�����[�^�𐄒�j
%    worldPoint��X,Y�݂̂̏ꍇ�́AZ=0���g�p
%       [x y z] = [X Y Z]R + T         % [x y z]:�J�������W�A[X Y Z]:World���W
[rotationMatrix, translationVector] = extrinsics(flipud(undistPoints), worldPoints, cameraParams)

%% �����Y�c�␳��̉摜��̍���`�F�b�J�[�R�[�i�[�_���AWorld���W�n��XY�֕ϊ� (World���W�n�Ō�_��z=0)
%     cameraParams.WorldUnits�Fmm
worldPoint1 = pointsToWorld(cameraParams, rotationMatrix, translationVector, undistPoints(1,:))

%% �����Y�c�␳�摜���(2,2)�`�F�b�J�[�R�[�i�[�_���AWorld���W�n��XY�֕ϊ�
worldPoint2 = pointsToWorld(cameraParams, rotationMatrix, translationVector, undistPoints(8,:))

%% World���W�i��L worldPoint2�Az=0)���A�t�ɉ摜��̍��W�֕ϊ�
%     w [x y 1] = [X Y Z 1] * [R;t] * K        : w�͔C�ӂ̌W���A[X Y Z]��World���W�n�AK�̓J���������p�����[�^
%    camMatrix = [rotationMatrix; translationVector] �~ K
camMatrix = cameraMatrix(cameraParams, rotationMatrix, translationVector)   % Projection Matrix (4x3)
imagePointsP = [worldPoint2, 0, 1] * camMatrix
imagePoints = imagePointsP / imagePointsP(3)

%% �`�F�b�J�[�{�[�h�̌��_�ɑ΂���iWorld���W�n�ł́j�A�J�����̈ʒu
%    �J�������W�̌��_�ɑΉ�����AWorld���W
orientation = rotationMatrix'
location = -translationVector * orientation

%% �L�����u���[�V�����ɗp����4�Ԗڂ́A�`�F�b�J�[�{�[�h�̌��_�ɑ΂���J�����̈ʒu
rotationMatrix = cameraParams.RotationMatrices(:,:,6)
translationVector = cameraParams.TranslationVectors(6,:)
orientation = rotationMatrix'
location = -translationVector * orientation



%% [pointsToWorld�֐����g��Ȃ��ꍇ�FR2014a�ȑO] World���W�n����摜���W�n�ւ̕ϊ��s����v�Z
R = rotationMatrix;
t = translationVector;
T = [R(1, :); R(2, :); t] * cameraParams.IntrinsicMatrix
tform2 = projective2d(T)      % ���߂��ϊ��s�񂩂�A2�����ˉe�􉽊w�ϊ��p�̃I�u�W�F�N�g���쐬

%% �摜���"�_" undistPoints1���AWorld���W�n�֕ϊ�����ꍇ�ɂ́A�쐬����tform�̋t�ϊ���K�p
% �摜��̓_ undistPoints���Aworld coordinate���W�i���ʒu�j�֕ϊ�����Ƃ��͎��s
worldPoints1a = transformPointsInverse(tform2, undistPoints(8,:))

%% 2�����f�[�^(�摜)��World���W�n(�J�����Ɍ��������p���A�J�����̒��S�����_)�֕ϊ��i1pixel = 1mm�j
birdsEyeView1 = imwarp(undistI, invert(tform2));   %Create the Bird's-Eye View
imtool(birdsEyeView1);
%% World���W�n�̌��_���A�摜�̍�����ɂ��čĕ\���i1pixel = 1mm�j
birdsEyeView2 = imwarp(undistI, invert(tform2), 'OutputView', imref2d([750 900]));   %Create the Bird's-Eye View
imtool(birdsEyeView2);

% Copyright 2014 The MathWorks, Inc.
