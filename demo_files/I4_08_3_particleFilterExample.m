%% ������
clc;clear;close all;imtool close all; rng('default');

%% ����̊m�F (�A�v���P�[�V����)
%implay('singleball.mp4');

%% �p�[�e�B�N���t�B���^�̍쐻
% We are measurement 6 states here (x, xd, xdd, y, yd, ydd)
pf = robotics.ParticleFilter;
pf.StateTransitionFcn = @I4_08_3_video_state_transition;
pf.MeasurementLikelihoodFcn = @I4_08_3_video_measurement;
pf.ResamplingMethod = 'stratified';
pf.StateEstimationMethod = 'mean';     % �S���q�ʒu�̕��ςŁA�ŏI����l������

%%  �V�X�e���I�u�W�F�N�g�쐬
videoReader = vision.VideoFileReader('singleball.mp4');
sz = get(0,'ScreenSize');
videoPlayer = vision.VideoPlayer('Position', [180,sz(4)-490,500,400]);
foregroundDetector = vision.ForegroundDetector('NumTrainingFrames', 10, 'InitialVariance', 0.05);
blobAnalyzer = vision.BlobAnalysis('AreaOutputPort', false, 'MinimumBlobArea', 70);

%% �R�}����{�^���\��
a=true;
sz = get(0,'ScreenSize');
figure('MenuBar','none','Toolbar','none','Position',[20 sz(4)-100 100 70])
uicontrol('Style', 'pushbutton', 'String', '���̃t���[��',...
        'Position', [20 20 80 40],'Callback', 'a=false;');

isFilterInitialized = false;
trackedPositions = [0 0 0];
position = [];

%% �������t���[��������
%      "���̃t���[��" �̃{�^���ŁA�R�}����
while ~isDone(videoReader)

    frame  = step(videoReader);  % �摜��1�t���[���Ǎ���

    % �{�[�� (�O�i)�̌��o�E���S�_���o
    foregroundMask = step(foregroundDetector, rgb2gray(frame));
    detectedLocation = step(blobAnalyzer, foregroundMask);
    isObjectDetected = ~isempty(detectedLocation);
    
    if ~isFilterInitialized   % �g���b�L���O�n�܂��Ă��Ȃ��ꍇ
      if isObjectDetected        % �{�[�������o�����Ƃ�
      % �{�[�����ŏ��Ɍ��o���ꂽ���A���̈ʒu�ŗ��q(�p�[�e�B�N���t�B���^)��������
        numParticles = 8000;
        initialState = [detectedLocation(1) 20 0 detectedLocation(2) 0 0];
        initialCovariance = diag([16^2 4^2 4^2 16^2 4^2 4^2]);     % �����U�s��
        initialize(pf, numParticles, initialState, initialCovariance);
        
        isFilterInitialized = true;
        trackedLocation = correct(pf, detectedLocation(1,:));
        label = 'Initial';
      else   % �{�[�����܂��������Ă��Ȃ��ꍇ
        trackedLocation = [];label = '';
      end
    else    % �g���b�L���O���̏ꍇ
      if isObjectDetected  % �{�[�������o���ꂽ�ꍇ
        % [�\��]  ���q�����m�C�Y�𐶐�
        %         �e���q�̎����Ԃ̈ʒu����ԑJ�ڃ��f���ŗ\��������A�e���q�Ƀm�C�Y��������
        %         stateTransitionFcn ���Ă΂��
        predict(pf);
        
        % [����] �ϑ����f���ɂ��A�e�\���ʒu�ł̖ޓx���v�Z
        %        MeasurementLikelihoodFcn ���Ă΂��:
        %        �\�������e���q�ʒu�ƁA���ۂ̊ϑ��l�̋����ɂ��ޓx������
        %        �ޓx�ɏ]���A���q���Ĕz�u�i���T���v���j
        %         �i�ޓx�̒Ⴂ�ʒu�̗��q�͏��ŁB�ޓx�̍����ʒu�ɂ͕����̗��q��z�u�j
        %        �S���q�̕��ψʒu�ōŏI�\���ʒu������
        trackedLocation = correct(pf, detectedLocation(1,:));
        label = 'Corrected';
      else  % �g���b�L���O���Ƀ{�[����������Ȃ������ꍇ
        % �\��
        trackedLocation = predict(pf);
        label = 'Predicted';
      end
    end
    
  % ����\��
  % ���o���ꂽ�Ƃ��A���o���ꂽ�ʒu�ɐ\���}�[�N
  if isObjectDetected
    combinedImage = insertMarker(frame, detectedLocation, 'Color','blue', 'Size',5);
  else
    combinedImage = frame;
  end
  
  % �g���b�N(���oor�\��)����Ă���Ƃ��A�ꏊ�ɐԊۂ��d�ˏ���
  if ~isempty(trackedLocation)
    % ���q�ʒu�ɁA�}�W�F���^�F�̓_
    particleLoc = pf.Particles(:,[1,4]);
    particleLoc(:,3) = 0.7;           % �~�̔��a
    combinedImage = insertShape(combinedImage, 'FilledCircle', particleLoc, 'Color', 'magenta');
 
    position = trackedLocation([1,4]);
    position(:, 3) = 5;           % �~�̔��a
    combinedImage = insertObjectAnnotation(combinedImage, 'circle', position,label);
    %combinedImage = insertMarker(combinedImage, trackedLocation, 'Color','red');    position, {label}
  
    % �ߋ��̓_�ɗΊ�
    combinedImage = insertShape(combinedImage, 'Circle', trackedPositions, 'Color', 'green');
    trackedPositions = [trackedPositions; position];
  end

  step(videoPlayer, combinedImage);   % �r�f�I1�t���[���\��

  while (a) 
    drawnow;   % �v�b�V���{�^���̃C�x���g�̊m�F
  end;
  a = true;

end % while

release(videoReader);

%% �I��















%% ���T���v�����O�̕��@
% multinomial (default)
% residual
% stratified
% systematic


%%
% Copyright 2016 The MathWorks, Inc.

