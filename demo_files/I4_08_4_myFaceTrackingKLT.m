%% �猟�o�Ȃ�т�KLT�A���S���Y����p�����g���b�L���O
%   �炪�X�����苗�����ς���Ă��A�������g���b�L���O
clc;close all;imtool close all;clear;

%% Step1�F��̌��o
% ����t�@�C������摜��Ǎ��ރI�u�W�F�N�g�̐���
videoFileReader = vision.VideoFileReader('tilted_face.avi');

% �猟�o�p�I�u�W�F�N�g�̐���
faceDetector = vision.CascadeObjectDetector();

% 1�t���[���Ǎ��݁A������o
frame = step(videoFileReader); 
bbox       = step(faceDetector, frame);

% ���o������̗̈��\��
frame = insertShape(frame, 'Rectangle', bbox, 'LineWidth',5);
figure; imshow(frame); title('Detected face');

% ���o������̉�]�̉����̂��߂Ɏl���̓_���W�֕ϊ�
bboxPoints = bbox2points(bbox(1, :));

%% Step2�F���o������̈�ŁA�����_(�g���b�L���O����Ώ�)�����o
%   (���t���[���猟�o����Ƒ��x���ቺ�E�܂������Ȋ�݂̂̌��o����g�p)

% ��̗̈�ŁA�R�[�i�[�_�����o
points = detectMinEigenFeatures(rgb2gray(frame), 'ROI', bbox);

% Display the detected points.
figure, imshow(frame), hold on, title('Detected features');
plot(points);

%% Step3�F�|�C���g�g���b�J�[��������
% �|�C���g�g���b�L���O�̃I�u�W�F�N�g�̍쐬 (�G���[�̑傫�ȓ_�͍폜���Ă����悤�ɐݒ�)
pointTracker = vision.PointTracker('MaxBidirectionalError', 2);
% �ŏ��̃t���[���ƁA����̃t���[���Ō��o�����R�[�i�[�_�Ńg���b�J�[��������
points = points.Location;
initialize(pointTracker, points, frame);  

%% ��̃g���b�L���O
% �r�f�I�\���p�̃I�u�W�F�N�g�̍쐬
videoPlayer  = vision.VideoPlayer('Position',...
    [100 100 [size(frame, 2), size(frame, 1)]+30]);

%% Stop �{�^���\��
a=true;
sz = get(0,'ScreenSize');
figure('MenuBar','none','Toolbar','none','Position',[20 sz(4)-100 100 70])
uicontrol('Style', 'pushbutton', 'String', 'Stop',...
        'Position', [20 20 80 40], 'Callback', 'a=false;');

oldPoints = points;
while ~isDone(videoFileReader) && a
  frame = step(videoFileReader);   % 1�t���[���Ǎ���

  % �_�̃g���b�L���O
  [points, isFound] = step(pointTracker, frame);
  visiblePoints = points(isFound, :);  % ���t���[���Ō��������_
  oldInliers = oldPoints(isFound, :);  % �O�t���[���̓_�̒��ŁA���t���[���ł�������������
    
  if size(visiblePoints, 1) >= 2   %�|�C���g��2�ȏ㌩�������Ƃ�
      % ���ʂ̕\���̂��߁A�O�t���[�����猻�t���[���ւ̕ϊ��s������߂�
      [xform, oldInliers, visiblePoints] = estimateGeometricTransform(...
          oldInliers, visiblePoints, 'similarity', 'MaxDistance', 4);
      % ���E�{�b�N�X���􉽊w�ϊ�
      bboxPoints = transformPointsForward(xform, bboxPoints);
      % �摜�t���[���ɁA���E�{�b�N�X�Ɠ_��}��
      bboxPolygon = reshape(bboxPoints', 1, []);     % ��s�֕ϊ�
      frame = insertShape(frame, 'Polygon', bboxPolygon, 'LineWidth',5);
      frame = insertMarker(frame, visiblePoints, '+', 'Color', 'white');       
      % ���t���[���Ō��������|�C���g�ŁA�g���b�J�[���ď�����
      oldPoints = visiblePoints;
      setPoints(pointTracker, oldPoints);        
  end
    
  step(videoPlayer, frame);   % 1�t���[���\��
end

% Clean up
release(videoFileReader);
release(videoPlayer);
release(pointTracker);

%%   Copyright 2012 The MathWorks, Inc.
