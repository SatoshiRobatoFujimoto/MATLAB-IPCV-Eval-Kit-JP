clear all;clc;close all;imtool close all

%% ����̕\�� (�X�N���v�g)
videoReader = vision.VideoFileReader('singleball.mp4');
sz = get(0,'ScreenSize');
videoPlayer = vision.VideoPlayer('Position', [10,sz(4)-500,500,400]);
while ~isDone(videoReader)
  frame = step(videoReader);  % 1�t���[���ǂݎ��
  step(videoPlayer, frame);   % �r�f�I1�t���[���\��
end

%% ����̕\�� (�A�v���P�[�V����)
implay('singleball.mp4');

%% �{�[�����g���b�L���O �F�J���}���t�B���^�[ %%%%%%%%%%%%%%%%%%%
% �^����������p���\��������A�덷���܂ފϑ��l��␳
% �J���}���t�B���^�[�ƁA�{�[���̃Z�O�����e�[�V�����́A�p�����[�^�ݒ�iM�����̒������W�n�ɑΉ��j
% �J���}���t�B���^�[�̃R���X�g���N�^��p���邱�Ƃōׂ������f���̒�`���\
param.motionModel           = 'ConstantVelocity';  % �ʒu����ɗp����^���������F��葬�x�ňړ�����Ƃ��āA���̈ʒu�𐄒�B�������x���f������
param.initialEstimateError  = 1E5 * ones(1, 2);    % ���ꂼ��g���b�L���O�����̈ʒu����x�̐���l�ɑ΂��镪�U (���K���z)
param.motionNoise           = [25, 10];            % �^���������ɑ΂���덷�̕��U (�ʒu�A���x)
param.measurementNoise      = 25;                  % ���o���ꂽ�ʒu�ɑ΂���덷�̕��U (���K���z)
param.segmentationThreshold = 0.05;
  
%% �V�X�e���I�u�W�F�N�g�쐬
videoReader = vision.VideoFileReader('singleball.mp4');
sz = get(0,'ScreenSize');
videoPlayer = vision.VideoPlayer('Position', [180,sz(4)-490,500,400]);
foregroundDetector = vision.ForegroundDetector('NumTrainingFrames', 10, 'InitialVariance', param.segmentationThreshold);
blobAnalyzer = vision.BlobAnalysis('AreaOutputPort', false, 'MinimumBlobArea', 70, 'CentroidOutputPort', true);   % ���S�_�̎Z�o

isTrackInitialized    = false;
trackedPositions = [0 0 0];
position = [];

%% �R�}����{�^���\��
a=true;
sz = get(0,'ScreenSize');
figure('MenuBar','none','Toolbar','none','Position',[20 sz(4)-100 100 70])
uicontrol('Style', 'pushbutton', 'String', '���̃t���[��',...
        'Position', [20 20 80 40],'Callback', 'a=false;');

%% �������t���[��������
%      "���̃t���[��" �̃{�^���ŁA�R�}����
while (a) && ~isDone(videoReader)

  frame = step(videoReader);     % 1�t���[���ǂݎ��

  % �{�[�� (�O�i)�̌��o�E���S�_���o
  foregroundMask   = step(foregroundDetector, frame);
  detectedLocation = step(blobAnalyzer, foregroundMask);
  isObjectDetected = ~isempty(detectedLocation);

    if ~isTrackInitialized   % �g���b�L���O�n�܂��Ă��Ȃ��Ƃ�
      if isObjectDetected      % �ŏ��Ƀ{�[�������o�����Ƃ�
        % �{�[�����ŏ��Ɍ��o���ꂽ���A�J���}���t�B���^�[���쐬
        kalmanFilter = configureKalmanFilter(param.motionModel, ...
          detectedLocation, param.initialEstimateError, ...             %���o���ꂽ�ꏊ�������ʒu�ɐݒ�
          param.motionNoise, param.measurementNoise);

        isTrackInitialized = true;
        trackedLocation = correct(kalmanFilter, detectedLocation);
        label = 'Initial';
      else   % �{�[�����܂��������Ă��Ȃ��ꍇ
        trackedLocation = [];label = '';
      end

    else    % �g���b�L���O���̏ꍇ (�J���}���t�B���^�Ńg���b�L���O)
      if isObjectDetected    % �{�[�������o���ꂽ�ꍇ
        predict(kalmanFilter);  % �摜�m�C�Y���ɂ��ʒu���o�덷���A�\���l�Œጸ(correction)
        trackedLocation = correct(kalmanFilter, detectedLocation);
        label = 'Corrected';
      else  % �g���b�L���O���Ƀ{�[����������Ȃ������ꍇ
        trackedLocation = predict(kalmanFilter); % �{�[���ʒu��\��
        label = 'Predicted';
      end
    end

  % ����\��
  % ���o���ꂽ�Ƃ��A���o���ꂽ�ʒu�ɐ\���}�[�N
  if isObjectDetected
    combinedImage = insertMarker(frame, detectedLocation, 'Color','blue');
  else
    combinedImage = frame;
  end
  
  % �g���b�N(���oor�\��)����Ă���Ƃ��A�ꏊ�ɐԊۂ��d�ˏ���
  if ~isempty(trackedLocation)
    position = trackedLocation;
    position(:, 3) = 5;           % �~�̔��a
    combinedImage = insertObjectAnnotation(combinedImage, 'circle', position, {label}, 'Color', 'red');
    %combinedImage = insertMarker(combinedImage, trackedLocation, 'Color','red');
  end
  
  % �ߋ��̓_�ɗΊ�
  combinedImage = insertShape(combinedImage, 'Circle', trackedPositions, 'Color', 'green');
  trackedPositions = [trackedPositions; position];

  step(videoPlayer, combinedImage);   % �r�f�I1�t���[���\��
  
  while (a) 
    drawnow;   % �v�b�V���{�^���̃C�x���g�̊m�F
  end;
  a = true;
end % while
  
%%
release(videoReader);
release(videoPlayer);
release(foregroundDetector);
release(blobAnalyzer);

%% �I��










%% �O�Ղ�\������ꍇ
% [while ���[�v�̑O�ɁA]
%   accumulatedImage      = 0;
%   accumulatedDetections = zeros(0, 2);
%   accumulatedTrackings  = zeros(0, 2);
% [while ���[�v�̍Ō��]
%   accumulatedImage      = max(accumulatedImage, frame);
%   accumulatedDetections ...
%          = [accumulatedDetections; detectedLocation];
%   accumulatedTrackings  ...
%          = [accumulatedTrackings; trackedLocation];
% [while ���[�v�̍Ō��]
%   figure; imshow(accumulatedImage/2+0.5); hold on;
%   plot(accumulatedDetections(:,1), ...     %���o���ꂽ�ʒu�ɍ��{��
%        accumulatedDetections(:,2), 'k+');
%   plot(accumulatedTrackings(:,1), ...      %�g���b�L���O���ʂ�Ԋۂƒ����ŕ\��
%        accumulatedTrackings(:,2), 'r-o');
%   legend('Detection', 'Tracking');

%% vision.DeployableVideoPlayer���g���ꍇ
% videoPlayer = vision.DeployableVideoPlayer('Location', [10,sz(4)-500]);

% Copyright 2014 The MathWorks, Inc.
