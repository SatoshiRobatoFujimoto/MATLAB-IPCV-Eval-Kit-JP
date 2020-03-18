%% �X�e���I�V�X�e���̃x�[�X���C���̐���

%% �J�����̓����p�����[�^�̃��[�h
ld = load('wideBaselineStereo');
intrinsics1 = ld.intrinsics1;
intrinsics2 = ld.intrinsics2;

%% �`�F�b�J�{�[�h�̃T�C�Y���w��
squareSize = 29; % 1�}�X�̃T�C�Y��mm�Ŏw��

%% �X�e���I�J�����L�����u���[�^�[�A�v�����g�����x�[�X���C���̐���
% �u�Œ�����p�����[�^�[�̓ǂݍ��݁v��I��
% �u�J����1�̓����p�����[�^�[�̎w��v��intrinsics1���w��
% �u�J����2�̓����p�����[�^�[�̎w��v��intrinsics2���w��
stereoCameraCalibrator(...
    fullfile(toolboxdir('vision'),'visiondata','calibration','wideBaseline','left'),...
    fullfile(toolboxdir('vision'),'visiondata','calibration','wideBaseline','right'),...
    squareSize);

%% �v���O�����ɂ��x�[�X���C���̐���

%% �L�����u���[�V�����p�̉摜���w��
leftImages = imageDatastore(fullfile(toolboxdir('vision'),'visiondata', ...
    'calibration','wideBaseline','left'));
rightImages = imageDatastore(fullfile(toolboxdir('vision'),'visiondata', ...
    'calibration','wideBaseline','right'));

%% �`�F�b�J�[�{�[�h�̌��o
[imagePoints, boardSize] = ...
    detectCheckerboardPoints(leftImages.Files,rightImages.Files);
worldPoints = generateCheckerboardPoints(boardSize,squareSize);

%% �X�e���I�x�[�X���C���ƊO���p�����[�^�̐���
params = estimateStereoBaseline(imagePoints,worldPoints, ...
    intrinsics1,intrinsics2)

%% �L�����u���[�V�������x�̉���
figure
showReprojectionErrors(params)

%% �J�����̊O���p�����[�^�̉���
figure
showExtrinsics(params)

%%
% Copyright 2018 The MathWorks, Inc.