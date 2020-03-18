%% Multiple Object Tracking �`���[�g���A��
clear; close all; clc;
videoObjects = setupVideoObjects('singleball.mp4');

%% ����Đ� - �ǂ̂悤�ȓ���t�@�C���������̂����m�F���܂�
implay('singleball.mp4')

%% Next&Stop �{�^���\��
a=true;
b=true;
sz = get(0,'ScreenSize');
figure('MenuBar','none','Toolbar','none','Position',[20 sz(4)-200 100 130])
uicontrol('Style', 'pushbutton', 'String', 'Next',...
    'Position', [20 20 80 40],'Callback', 'a=false;');
uicontrol('Style', 'pushbutton', 'String', 'Stop',...
    'Position', [20 80 80 40],'Callback', 'b=false;');
      
%% ���C�����[�v
frameCount = 0;
while b
    % �r�f�I�t���[���̓ǂݍ���
    frameCount = frameCount + 1;                                % �t���[�����J�E���g
    frame = readFrame(videoObjects.reader);                     % 1�t���[���ǂݍ���
    %���̌��o&�g���b�L���O
    [confirmedTracks, mask, numDetections] = myTracker(frame, frameCount);
    %���ʂ̉���
    displayTrackingResults(videoObjects, confirmedTracks, frame, mask, numDetections);
    % "Next"�{�^�����������܂Œ�~
    while (a&&b)
        drawnow limitrate;
    end
    if ~videoObjects.reader.hasFrame
        break;
    end
    a = true;
end

%% �r�f�I�I�u�W�F�N�g�̐���
function videoObjects = setupVideoObjects(filename)
        
    % ����t�@�C���ǂݍ��ݗp�I�u�W�F�N�g�̒�`
    videoObjects.reader = VideoReader(filename);
    frame = 0;
    videoObjects.reader.CurrentTime = (1/videoObjects.reader.FrameRate) * frame;
        
    % ���ʉ����p��Player�I�u�W�F�N�g�̒�`  
    videoObjects.maskPlayer  = vision.VideoPlayer('Position', [20, 400, 700, 400]);
    videoObjects.videoPlayer = vision.VideoPlayer('Position', [740, 400, 700, 400]);
end

%% �g���b�L���O���ʂ̉���
function displayTrackingResults(videoObjects, confirmedTracks, frame, mask, numDetections)
    % �f�[�^�^�ϊ�
    frame = im2uint8(frame);
    mask = uint8(repmat(mask, [1, 1, 3])) .* 255;
        
    if ~isempty(confirmedTracks)        
        % ���o���ꂽ�I�u�W�F�N�g�̉���
        % �I�u�W�F�N�g�����o����Ȃ������ꍇ�́A�\���l�ɂ�錋�ʂ���������܂�
        numRelTr = numel(confirmedTracks);
        boxes = zeros(numRelTr, 4);
        ids = zeros(numRelTr, 1, 'int32');
        color_tbl = cell(numRelTr, 1);
        predictedTrackInds = zeros(numRelTr, 1); 
        for tr = 1:numRelTr
            color_tbl{tr} = 'yellow';
            % �I�u�W�F�N�g��Bounding Box�擾
            boxes(tr, :) = confirmedTracks(tr).ObjectAttributes{1}{1};
             
            % �g���b�N��ID�擾
            ids(tr) = confirmedTracks(tr).TrackID;
            
            % �I�u�W�F�N�g�����o����Ȃ������ꍇ
            if confirmedTracks(tr).IsCoasted
                predictedTrackInds(tr) = tr;
                boxes(tr, 1:2) = [confirmedTracks(tr).State(1), confirmedTracks(tr).State(3)];
                boxes(tr, 3:4) = 15;
                color_tbl{tr} = 'red';
            end
        end
            
        predictedTrackInds = predictedTrackInds(predictedTrackInds > 0);
            
        % �g���b�NID�����x���Ƃ��Ē��o
        labels = cellstr(int2str(ids));
            
        isPredicted = cell(size(labels));
        isPredicted(predictedTrackInds) = {' predicted'};
        labels = strcat(labels, isPredicted);
            
        % ���߂�}��(���摜)
        frame = insertObjectAnnotation(frame, 'rectangle', boxes, labels, 'Color',color_tbl);
            
        % ���߂�}��(�O�i���o���ʂ�2�l�摜)
        mask = insertObjectAnnotation(mask, 'rectangle', boxes, labels);
    end
        
    % Player�X�V
    videoObjects.maskPlayer.step(mask);        
    videoObjects.videoPlayer.step(frame);
end

function [confirmedTracks mask numDetections] = myTracker(frame, frameCount)

    persistent tracker
    persistent detector
    
    % multiObjectTracker�̒�`
    if isempty(tracker)
        tracker = multiObjectTracker(...
        'FilterInitializationFcn', @initDemoFilter, ...
        'AssignmentThreshold', 30, ...       % ���o���ʂ��g���b�N�Ƃ��Ċ��蓖�Ă�臒l
        'NumCoastingUpdates', 10, ...�@      % Coasting��ԂŃg���b�N���ێ����钷��
        'ConfirmationParameters', [6 10] ... % �g���b�N�Ƃ��ĔF�������܂ł̒���
        );
    end
    
    % �O�i���o�p�I�u�W�F�N�g�̒�`
    if isempty(detector)
        detector = vision.ForegroundDetector('NumGaussians', 3, ...
            'NumTrainingFrames', 40, 'MinimumBackgroundRatio', 0.7);
    end

    measurementNoise = 100*eye(2);  
    % �O�i���o
    mask = detector.step(frame);
    % �m�C�Y����
    mask = imopen(mask, strel('rectangle', [6, 6]));
    mask = imclose(mask, strel('rectangle', [50, 50])); 
    mask = imfill(mask, 'holes');
    % �v���p�e�B���
    stats = regionprops(mask, 'Centroid', 'BoundingBox');

    % objectDetections�I�u�W�F�N�g��Pack
    numDetections = size(stats, 1);
    detections = cell(numDetections, 1);
    if ~isempty(stats)
        for i = 1:numDetections
            detections{i} = objectDetection(frameCount, stats(i).Centroid, ...
                'MeasurementNoise', measurementNoise, ...
                'ObjectAttributes', {stats(i).BoundingBox});
        end
    end

    % �g���b�N�X�V
    confirmedTracks = updateTracks(tracker, detections, frameCount);
end

function filter = initDemoFilter(detection)
    % �J���}���t�B���^�̏�����
    
    % ������Ԃ̒�`
    state = [detection.Measurement(1); 0; detection.Measurement(2); 0];

    % �����덷�����U�s��̒�`
    stateCov = diag([50, 50, 50, 50]);

    % �J���}���t�B���^�̒�`(2D �������f��)
    filter = trackingKF('MotionModel', '2D Constant Velocity', ...    
        'State', state, ...
        'StateCovariance', stateCov, ... 
        'MeasurementNoise', detection.MeasurementNoise(1:2,1:2) ...    
        );
end

% Copyright 2018 The MathWorks, Inc.