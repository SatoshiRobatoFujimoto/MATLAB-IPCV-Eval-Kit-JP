%% ������2�����摜����́AStructure From Motion
%      �L�����u���[�V�����ς݃J�����ŎB�e���ꂽ�����̎��n��2�����摜����A
%      3�����\���̍č\�z�A�e�摜�ɑΉ�����J�����ʒu��p������i�X�P�[���͕s��j
% �Z�N�V����#1�F�J�����ړ��̐���i�摜��̓_�̏W���͑a�Ȃ��̂��g�p�j
% �Z�N�V����#2�F����3�����_�Q�̍č\��

clc;clear;close all;imtool close all; rng('default');

%% ���n��̕����摜�̃t�@�C���w��iimageSet�N���X���g�p�j
imageDir = [matlabroot '\toolbox\vision\visiondata\structureFromMotion'];
imds = imageDatastore(imageDir)

%% �摜�̕\�� (�J�������������։�])
figure; montage(imds.Files, 'Size', [1,5]); truesize;

%% �S�摜�̓Ǎ���
images = readall(imds);    % 5x1

%% [�Z�N�V����#1�F�J�����ړ�(�ʒu��p��)�̐���] %%%%%%%%%%%%%%%%%%%%
%  ��viewSet�I�u�W�F�N�g���g�p�F
%        �e�摜�ł̓����_���W�ƃJ�����̈ʒu��p�����i�[ => vSet.Views         View��x[ViewId, Points, Orientation, Location]
%        �e�摜�Ԃ̓����_�̑Ή����i�[                  => vSet.Connections   View��-1 x[ViewId1, ViewId2, Matches, RelativeOrientation, RelativeLocation]
% ���L1�`9���A�SView�ɑ΂��AView�̏��Ɏ��s
% 1: �����Y�c����XS
% 2: �����_�̌��o�A�����ʒ��o�A
% 3: ��O�̉摜�ƁA2�̉摜�Ԃœ����ʂ̃}�b�`���O�i�|�C���g�g���b�J�[�ł��\�j
% 4: ��{�s��(2�̐��K���摜���W��̓_�̑Ή��֌W)�̐���
% 5: 2�̉摜�Ԃ̓_�̑Ή��֌W����A��O�̃J�����ʒu��p���ɑ΂���ʒu��p���𐄒�
% 6: �ŏ��̃J�����ʒu��p���ɑ΂���A���J�����ʒu��p�����v�Z
% 7: �g���b�N(����View�ɂ܂�����A�_�̑Ή��֌W)�̒��o
% 8: ��View�܂ł̑S�J�����ʒu��p�����ƑS�_�Ή��֌W��p���A�e�_��3�����ʒu(�}�b�v)�𐄒�
% 9: �o���h�������ɂ��A����܂ł̑S�_�Q���W�ƁA�J�����ʒu��p�����C��

%% 1���ڂ̉摜������
% 1���ڂ̉摜�̃����Y�c������\��
load([imageDir, '\cameraParams.mat']);   % �J�����p�����[�^�̓Ǎ���
I = undistortImage(images{1}, cameraParams); 
figure; imshowpair(images{1}, I, 'montage');truesize;

%%
% ����50�s�N�Z���͏����āA�����_���o�i�摜�G�b�W�ł̓����_��r���j
border = 50;
roi = [border, border, size(I, 2)- 2*border, size(I, 1)- 2*border];
% �����_���o�F��ǓI�������擾����ׂɁANumOctaves��傫���ݒ�
G = rgb2gray(I);      % �O���[�X�P�[���֕ϊ�
prevPoints   = detectSURFFeatures(G, 'NumOctaves', 8, 'ROI', roi);
% �����ʒ��o�F��]�����Ȃ�����Upright���w��(Orientation��������ɌŒ�)
prevFeatures = extractFeatures(G, prevPoints, 'Upright', true);

% 1���ڂ̉摜�̃f�[�^(�����_���W�A�J�����ʒu��p��)���AviewID=1�Ƃ��ēo�^
% ���̂Ƃ��̃J�����ʒu(���w���S)��World���W�̌��_
% �J�����̌�����World���W�n��Z���̐�����
vSet = viewSet       % ���viewSet�I�u�W�F�N�g�𐶐�
viewID = 1;
vSet = addView(vSet, viewID, 'Points', prevPoints, 'Orientation', eye(3,'single'),...
                                      'Location', single([0 0 0]));           % Point�̌^�ɑ�����
vSet.Views     % ViewId=1 ���o�^����Ă���

%% �c��̉摜�̃f�[�^���A���[�v������vSet�I�u�W�F�N�g�֓o�^
for viewID = 2:numel(images)
    % �����Y�c����
    I = undistortImage(images{viewID}, cameraParams);
    
    % �����_���o������ʒ��o���O�̉摜�̓����ʂƃ}�b�`���O
    G = rgb2gray(I);       % �O���[�X�P�[���֕ϊ�
    currPoints   = detectSURFFeatures(G, 'NumOctaves', 8, 'ROI', roi);
    currFeatures = extractFeatures(G, currPoints, 'Upright', true);    
    indexPairs = matchFeatures(prevFeatures, currFeatures, ...
                           'MaxRatio', .7, 'Unique',  true);
    
    % �Ή��֌W���������������_�𒊏o
    matchedPoints1 = prevPoints(indexPairs(:, 1));
    matchedPoints2 = currPoints(indexPairs(:, 2));
    
    % �Ή��_�̏�񂩂�
    % ��O�̃J�����ʒu��p��(�J�������W)�ɑ΂���ʒu��p���𐄒�i������1�Ɖ���j
    % ���Bundle Adjustment�ŁA�����̌덷���͕␳�����
    for i = 1:100
        % ��{�s��(2�̉摜�̑Ή��֌W)�̐���   
        [E, inlierIdx] = estimateEssentialMatrix( ...
            matchedPoints1, matchedPoints2, cameraParams);

        % inlier�����Ȃ��ꍇ�́A�ēx����
        if sum(inlierIdx) / numel(inlierIdx) < .3
            continue;
        end
    
        % �G�s�|�[���S���𖞂����Ȃ�����(��Ή��_)�̏���
        inlierPoints1 = matchedPoints1(inlierIdx, :);
        inlierPoints2 = matchedPoints2(inlierIdx, :);    
    
        % ��{�s�񂩂�A��O�̃J�����ʒu��p���ɑ΂���A���J�����ʒu(�P�ʃx�N�g��)�E�p���𐄒�
        [relativeOrient, relativeLoc, validPointFraction] = ...
            relativeCameraPose(E, cameraParams, inlierPoints1, inlierPoints2);         % �|�C���g�𔼕��ɊԈ������Ƃŏ����̍��������\ (1:2:end, :)

        % �L���ȓ_�̊����������Ȃ�܂ŌJ��Ԃ��A��{�s��̐�����s��
        if validPointFraction > .8
            break;
        elseif i == 100;
            % 100�񔽕����Ă�validPointFraction���Ⴂ�ꍇ�́A�G���[�ɂ���
            error('Unable to compute the Essental matrix');
        end  
    end

    % 1�O�̃J�����ʒu��p��(���[���h���W�n)���擾 (addView �ŃZ�b�g��������)
    prevPose = poses(vSet, viewID-1);
    prevOrientation = prevPose.Orientation{1};
    prevLocation    = prevPose.Location{1};           
    % ��Ԗڂ�View�ɑ΂���(���[���h���W�n)�A���J�����ʒu��p�������߂�.
    orientation = relativeOrient * prevOrientation;
    location    = relativeLoc    * prevOrientation + prevLocation;

    % �����_�̍��W�A�J�����ʒu��p�����AvSet�֓o�^
    vSet = addView(vSet, viewID, 'Points', currPoints, 'Orientation', orientation, ...
        'Location', location);
    % ��O�̉摜�Ƃ̓����_�̑Ή��֌W���AvSet�֓o�^
    vSet = addConnection(vSet, viewID-1, viewID, 'Matches', indexPairs(inlierIdx,:));

    % �g���b�N�F����View�ɂ܂�����A�_�̑S�Ή��֌W���i�ꕔ�̃g���b�N�́A�SView�ɂ܂������Ă���j
    tracks1 = findTracks(vSet);  % ���݂܂ł̑SView�Ԃ̃g���b�N��񒊏o

    % ���݂܂ł̑SView�́A�J�����ʒu��p�����擾
    camPoses1 = poses(vSet);

    % �����摜��̓_�Ή��֌W����A�e�_��3�����ʒu�𐄒�
    xyzPoints1 = triangulateMultiview(tracks1, camPoses1, cameraParams);
    
    % Bundle Adjustment�ŁA�_�Q�̈ʒu�ƃJ�����ʒu��p�����œK������
    [xyzPoints1, camPoses1, reprojectionErrors] = bundleAdjustment(xyzPoints1, ...
             tracks1, camPoses1, cameraParams, 'FixedViewId', 1, ...
             'PointsUndistorted', true);

    % �o���h�������Ŕ��C�������J�����ʒu��p����o�^
    vSet = updateView(vSet, camPoses1);       % �e�[�u���FcamPoses1 �̏��iViewID, Orientation, Location�j�ŃA�b�v�f�[�g

    prevFeatures = currFeatures;
    prevPoints   = currPoints;  
end

%% ���ʂ̊m�F
vSet.Views        % �e�摜(View)�ł́A�����_���W�A�J�����p���E�ʒu
vSet.Connections  % �e�摜�Ԃ̓_�̑Ή��֌W

figure;   % �Ō��2���̉摜�Ԃ̑Ή��֌W�i�����̂��̂́A�ړ��ʑ�j
showMatchedFeatures(undistortImage(images{viewID-1}, cameraParams), I, inlierPoints1, inlierPoints2); truesize;

%% �v���b�g�F3�����_�Q�A�J�����ʒu��p��
camPoses1 = poses(vSet);
figure; plotCamera(camPoses1, 'Size', 0.2);  % �J������Figure��Ƀv���b�g
hold on;

goodIdx = (reprojectionErrors < 5);  % �G���[�l�̑傫���_������
pcshow(xyzPoints1(goodIdx, :), 'VerticalAxis', 'y', 'VerticalAxisDir', 'down', 'MarkerSize', 45);

xlim([-6 4]); ylim([-4 5]); zlim([-1 21]);
xlabel('X');ylabel('Y');zlabel('Z'); camorbit(0, -30); grid on; box on; hold off
title('Refined Camera Poses');

%% [�Z�N�V����#2�F�ēx�S�Ẳ摜���������A����3�����_�Q���č\��] %%%%%%%
%  �ꖇ�ڂ̉摜�Ŗ��ȃR�[�i�[�_���o�A���̌�|�C���g�g���b�J�[�őSView��őΉ��ʒu�����o
% �����摜��̑Ή��_����p��3�����č\�z
% �ēx�o���h�������ŁA3�����_�Q���W�ƁA�J�����ʒu��p���������

% �ꖇ�ڂ̉摜�̃����Y�c����
I = undistortImage(images{1}, cameraParams); 
% �R�[�i�[�_���o�iMinQuality�������āA���𑝂₷�j
G = rgb2gray(I);
initPoints = detectMinEigenFeatures(G, 'MinQuality', 0.001);

% �g���b�L���O�p�I�u�W�F�N�g�𐶐��i�g���b�L���O�ŁA���̉摜��̑Ή��_�����o)
tracker = vision.PointTracker('MaxBidirectionalError', 1, 'NumPyramidLevels', 6);
% ���o���ꂽ�R�[�i�[�_�ŁA�|�C���g�g���b�J�[��������
initPoints = initPoints.Location;
initialize(tracker, initPoints, I);

% �_�Ή��֌W����������A���ȃR�[�i�[�_�œ����_���W���X�V�A
viewID = 1;
vSet = updateConnection(vSet, viewID, viewID+1, 'Matches', zeros(0, 2));
vSet = updateView(vSet, viewID, 'Points', initPoints);

%% 2���ڈȍ~�̉摜��̑Ή��_���W���A�|�C���g�g���b�J�[�Ő���
%    vSet�́AView��Connection�����A�b�v�f�[�g
for viewID = 2:numel(images)
    % ���摜����A�����Y�c�̏���
    I = undistortImage(images{viewID}, cameraParams); 
    
    % ���摜��̑Ή��_�����o
    [currPoints, validIdx] = step(tracker, I);
    
    % �_�Ή��֌W����������A���ȃR�[�i�[�_�œ����_���W�����X�V�A
    if viewID < numel(images)
        vSet = updateConnection(vSet, viewID, viewID+1, 'Matches', zeros(0, 2));
    end
    vSet = updateView(vSet, viewID, 'Points', currPoints);
    
    % �_�Ή��֌W�����X�V
    matches = repmat((1:size(initPoints, 1))', [1, 2]);
    matches = matches(validIdx, :);        
    vSet = updateConnection(vSet, viewID-1, viewID, 'Matches', matches);
end

% ���ʂ̊m�F
vSet.Connections                                             % �L���_�����X�Ɍ����F�|�C���g�g���b�J�[���ŏ��̉摜�ŏ��������Ă��邽��

% �g���b�N�FView�Ԃ̓_�̑Ή��֌W���A�ꕔ�̃g���b�N�́A�SView�ɂ܂������Ă���
tracks2 = findTracks(vSet);      % �SView�Ԃ̃g���b�N���̒��o: �e�g���b�N:���݂���View(�摜)�ԍ��ƁA�e�摜��̍��W

% �SView�́A�J�����ʒu��p�����擾
camPoses2 = poses(vSet);         % viewSet�̃��\�b�h

% �����摜��̑Ή��_�g�i�g���b�N�j�ɑΉ�����A�e�_��3�������[���h���W���v�Z
xyzPoints2 = triangulateMultiview(tracks2, camPoses2, cameraParams);

% �SView�́A3�����_�Q���W�ƃJ�����ʒu��p�����o���h�������Ŕ��C��
[xyzPoints2, camPoses2, reprojectionErrors] = bundleAdjustment(...
    xyzPoints2, tracks2, camPoses2, cameraParams, 'FixedViewId', 1, 'PointsUndistorted', true);

%% ����3�����č\�����ʂ̕\��
figure; plotCamera(camPoses2, 'Size',0.2);   % �J�����ʒu��p�����v���b�g
hold on;

% �e�g���b�N�̐F�𒊏o
color = zeros(numel(tracks2),3,'uint8');
for k = 1:numel(tracks2)                        % �S�g���b�N�����[�v����
    Itracked = images{tracks2(k).ViewIds(1)};   % �e�g���b�N�̍ŏ���ViewId�̉摜��I�� => RGB�l�𒊏o
    x = round(tracks2(k).Points(1,1));
    y = round(tracks2(k).Points(1,2));
    x = min(size(Itracked,2),x);
    y = min(size(Itracked,1),y);
    color(k,:) = Itracked(y,x,:);
end

goodIdx = (reprojectionErrors < 5);  % �G���[�l���傫���_������
pcshow(xyzPoints2(goodIdx, :), color(goodIdx, :), 'VerticalAxis', 'y', 'VerticalAxisDir', 'down', 'MarkerSize', 20);

xlim([-6 4]); ylim([-4 5]); zlim([-1 21]);
xlabel('X');ylabel('Y');zlabel('Z');camorbit(0, -30); grid on; box on;
title('Dense Reconstruction');

%% �I��













%% �J�����ړ��ʂ����m�̏ꍇ�A��΋����̓_�Q�ɕϊ�
     camPoses2.Location{1}    % �J�����ʒu1�̍��W�́A[0 0 0]
p5 = camPoses2.Location{5}    % �J�����ʒu5�̍��W�i�J����1����̑��΍��W�j
scaleFactor = 2.1 / norm(p5)  % [��] �J�����ʒu1�ƃJ�����ʒu5�̋������A2.1m�̂Ƃ�

xyzPointsS = xyzPoints2 * scaleFactor;     % �_�Q�̃X�P�[����ύX

camPosesS  = camPoses2;
locS =cell2mat(camPosesS.Location) * scaleFactor
camPosesS.Location = num2cell(locS, 2)

% �\��
figure; plotCamera(camPosesS, 'Size',0.2);   % �J�����ʒu��p�����v���b�g
hold on;
pcshow(xyzPointsS(goodIdx, :), color(goodIdx, :), 'VerticalAxis', 'y', 'VerticalAxisDir', 'down', 'MarkerSize', 20);
xlim([-6 4]); ylim([-4 5]); zlim([-1 21]);
xlabel('X');ylabel('Y');zlabel('Z');camorbit(0, -30); grid on; box on;
title('Dense Reconstruction (Actual Scale)');


%% �J�����p�����[�^���A���l�Ŏw�肷��ꍇ %%%%%%%%%%%%
%load([imageDir, '\cameraParams.mat'])   �̑����

% �����J�����p�����[�^�̐ݒ�
intrinsicMatrix = [1037.575214664696                  0  0;
                      0               1043.315752317925  0;
                   642.231583031218   387.835775096238    1];
% �����Y�c�p�����[�^�̐ݒ�
radialDistortion = [0.146911684283474  -0.214389634520344];
% cameraParameters �I�u�W�F�N�g�̐���
cameraParams = cameraParameters('IntrinsicMatrix',intrinsicMatrix, 'RadialDistortion',radialDistortion);


%% Copyright 2016 The MathWorks, Inc. 
