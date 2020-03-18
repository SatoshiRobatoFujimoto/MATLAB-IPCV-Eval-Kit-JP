clc;clear;close all;imtool close all;

%% �R���s���[�^�r�W�����f���F�l�̌��o�E�g���b�L���O
I = imread('I5_07_7_people2.png');
I1 = imresize(I, 1.5, 'Antialiasing',false);
figure; imshow(I);       % 1�t���[���\��

%% �l�̌��o �i�����ł́A���i�����̐l�̌��o����g�p�j
roi = [40 95 320 140];     % �����̈�𐧌��i��Ȃǂł͌��o�s�v�j
bboxes = detectPeopleACF(I1, roi, 'Model','caltech', ...
            'WindowStride',2, 'NumScaleLevels', 4)

%% ���o���ꂽ�l�̈ʒu�ɁA�l�p���g�ƃe�L�X�g��ǉ�
I2 = insertObjectAnnotation(I1, 'rectangle', bboxes, 'People', 'FontSize',24, 'LineWidth', 2);
imshow(I2);shg;

%% ����ł̌��o
% ����t�@�C������摜��Ǎ��ރI�u�W�F�N�g�̐���
videoReader = vision.VideoFileReader('vippedtracking.mp4', 'VideoOutputDataType','uint8');
% �r�f�I�\���p�̃I�u�W�F�N�g�̍쐬
sz = get(0,'ScreenSize');
%videoPlayer  = vision.DeployableVideoPlayer('Location',[10 sz(4)-300]);
videoPlayer  = vision.DeployableVideoPlayer();

% START/STOP�{�^���\��
a1=true; a2=true;
sz = get(0,'ScreenSize');
figure('MenuBar','none','Toolbar','none','Position',[20 sz(4)-150 100 120])
uicontrol('Style', 'pushbutton', 'String', 'START',...
        'Position', [20 70 80 40], 'Callback', 'a1=false;');
uicontrol('Style', 'pushbutton', 'String', 'STOP',...
        'Position', [20 20 80 40], 'Callback', 'a2=false;');
step(videoPlayer, I1);   
while a1; drawnow; end      % START�{�^�����������܂ő҂�
      
cnt = 1;
while ~isDone(videoReader) && a2 && cnt<230
  I = step(videoReader);   % 1�t���[���Ǎ���
  I = imresize(I, 1.5, 'Antialiasing',false);

  [bboxes, scores] = detectPeopleACF(I, roi, ...
          'Model','caltech', 'WindowStride', 2, 'NumScaleLevels', 4);

  % ���o���ꂽ�l�̈ʒu�ɁA�l�p���g�ƃe�L�X�g��ǉ�
  I2 = insertShape(I, 'rectangle', bboxes, 'LineWidth', 2);
  
  step(videoPlayer, I2);
  
  drawnow limitrate;
  cnt = cnt +1;
end

%% �ēx���s�i�E�F�C�g��}�����Ă��������s�j
release(videoReader);
a1=true; a2=true;
step(videoPlayer, I1);   
while a1; drawnow; end
      
cnt = 1;
while ~isDone(videoReader) && a2 && cnt<230
  I = step(videoReader);   % 1�t���[���Ǎ���
  I = imresize(I, 1.5, 'Antialiasing',false);

  [bboxes, scores] = detectPeopleACF(I, roi, ...
          'Model','caltech', 'WindowStride', 2, 'NumScaleLevels', 4);

  % ���o���ꂽ�l�̈ʒu�ɁA�l�p���g�ƃe�L�X�g��ǉ�
  I2 = insertShape(I, 'rectangle', bboxes, 'LineWidth', 2);
  
  step(videoPlayer, I2);
  
  drawnow limitrate;
  pause(0.2);
  cnt = cnt +1;
end


%% �g���b�L���O��p���ĕ⏞�i���o���ʁF���F�A�⏞���ʁF�ԐF�j%%%%%%%%%%%%%%%%%%%
% �^����������p���\��������A�덷���܂ފϑ��l��␳
% �J���}���t�B���^�[�ƁA�{�[���̃Z�O�����e�[�V�����́A�p�����[�^�ݒ�iM�����̒������W�n�ɑΉ��j
% �J���}���t�B���^�[�̃R���X�g���N�^��p���邱�Ƃōׂ������f���̒�`���\
param.motionModel           = 'ConstantVelocity';  % �ʒu����ɗp����^���������F��葬�x�ňړ�����Ƃ��āA���̈ʒu�𐄒�B�������x���f������
param.initialEstimateError  = [2 1];               % ���ꂼ��g���b�L���O�����̈ʒu����x�̐���l�ɑ΂��镪�U (���K���z)
param.motionNoise           = [5, 5];              % �^���������ɑ΂���덷�̕��U (�ʒu�A���x)
param.measurementNoise      = 100;                 % ���o���ꂽ�ʒu�ɑ΂���덷�̕��U (���K���z)
  
% �V�X�e���I�u�W�F�N�g�쐬
release(videoReader);
isTrackInitialized    = false;

release(videoReader);
a1=true; a2=true;
step(videoPlayer, I1);   
while a1; drawnow; end
% �������t���[��������

cnt = 1;
while ~isDone(videoReader) && a2 && cnt<230

  I = step(videoReader);     % 1�t���[���ǂݎ��

  % �l(�O�i)�̌��o�E���S�_���o
  I = imresize(I, 1.5, 'Antialiasing',false);  
  [bboxes, scores] = detectPeopleACF(I, roi, ...
            'Model','caltech', 'WindowStride', 2, 'NumScaleLevels', 4);

  % �l�����o���ꂽ�ꍇ�A���̈ʒu�ɉ��F�Ŏl�p�g��`��
  if ~isempty(bboxes)     
    isObjectDetected = true;
    detectedLoc = [bboxes(1,1)+bboxes(1,3)/2  bboxes(1,2)+bboxes(1,4)/2];   %���S�̌v�Z
    % ���o���ꂽ�l�̈ʒu�ɁA�l�p���g(��)�ƒ��S�Ɋ�(��)��`��
    I = insertShape(I, 'rectangle', bboxes, 'LineWidth', 2);
    I = insertShape(I, 'FilledCircle', [detectedLoc 5], 'Color','Yellow', 'Opacity',1);
  else
    isObjectDetected = false;
    detectedLoc = [];
  end

  if ~isTrackInitialized   % �g���b�L���O�n�܂��Ă��Ȃ��Ƃ�
    if isObjectDetected      % �ŏ��ɐl�����o�����Ƃ�
      % �l���ŏ��Ɍ��o���ꂽ���A�J���}���t�B���^�[���쐬
      kalmanFilter = configureKalmanFilter(param.motionModel, ...
        detectedLoc, param.initialEstimateError, ...             %���o���ꂽ�ꏊ�������ʒu�ɐݒ�
        param.motionNoise, param.measurementNoise);

      isTrackInitialized = true;
      trackedLoc = correct(kalmanFilter, detectedLoc);
    else   % �l���܂��������Ă��Ȃ��ꍇ
      trackedLoc = [];label = '';
    end

  else    % �g���b�L���O���̏ꍇ (�J���}���t�B���^�Ńg���b�L���O)
    if isObjectDetected    % �l�����o���ꂽ�ꍇ
      predict(kalmanFilter);  % �摜�m�C�Y���ɂ��ʒu���o�덷���A�\���l�Œጸ(correction)
      trackedLoc = correct(kalmanFilter, detectedLoc);
    else  % �g���b�L���O���ɐl��������Ȃ������ꍇ
      trackedLoc = predict(kalmanFilter); % �l�̈ʒu��\��
    end
  end

  % �g���b�L���O�ʒu�ɐԊۂ��㏑��
  if ~isempty(trackedLoc)
    I = insertShape(I, 'FilledCircle', [trackedLoc 5], 'Color','Red', 'Opacity',1); 
  end

  step(videoPlayer, I);   % �r�f�I1�t���[���\��
  
  pause(0.2);
  cnt = cnt +1;
  drawnow limitrate;
end % while

release(videoReader);
release(videoPlayer);

%% �I��










% Copyright 2015 The MathWorks, Inc.

