%% Motion-Based Multiple Object Tracking
%    �g���b�L���O�Z�p�F����F���A��ʊĎ��A�����Ԃ̊댯���m���ւ̉��p
%�@�@Step#1�F�e�t���[�����ł̓����Ă��镨�̂̌��o
%    Step#2�F�t���[���Ԃł̊֘A�t��
% Kalman�t�B���^�[���g�p
% ���s�{�^���Ńf��

clc;close all;imtool close all;clear;

% Stop �{�^���\��
a=true;
sz = get(0,'ScreenSize');
figure('MenuBar','none','Toolbar','none','Position',[20 sz(4)-100 100 70])
uicontrol('Style', 'pushbutton', 'String', 'Stop',...
        'Position', [20 20 80 40], 'Callback', 'a=false;');
    
%% �e��System Objects�̐��� %%%%%
% ����Ǎ��݂̃I�u�W�F�N�g����
  obj.reader = vision.VideoFileReader('atrium.mp4');
% ����\���p�I�u�W�F�N�g�̐���
  obj.videoPlayer = vision.VideoPlayer('Position', [ 20, sz(4)-600, 700, 400]);
  obj.maskPlayer  = vision.VideoPlayer('Position', [740, sz(4)-600, 700, 400]);     
% �����Ă���O�i�����o����I�u�W�F�N�g�𐶐�
  obj.detector = vision.ForegroundDetector('NumGaussians', 3, ...
       'NumTrainingFrames', 40, 'MinimumBackgroundRatio', 0.7);
% �u���u��͗p�̃I�u�W�F�N�g�̍쐬�i���S�_�E���E�{�b�N�X�j
  obj.blobAnalyser = vision.BlobAnalysis( 'AreaOutputPort',false, ...
          'CentroidOutputPort', true,  'BoundingBoxOutputPort', true, ...
          'MinimumBlobArea', 400, 'ExcludeBorderBlobs',true);

% �g���b�N�i�e�g���b�N�ɁA�e�����Ă��镨�̂̏����i�[�j�̏�����
tracks = struct(...
  'id',           {}, ...       % ID�ԍ�
  'bbox',         {}, ...       %���t���[�����̋��E�{�b�N�X�i�\���p�j
  'kalmanFilter', {}, ...       %���̕��̃g���b�L���O�p�̃J���}���t�B���^�[
  'trails',       [], ...       % �O�Օ\���p�ɁA�ߋ��̈ʒu��ۑ�
  'age',               {}, ...  %�ŏ��Ɍ��o����Ă���̃t���[����
  'totalVisibleCount', {}, ...      %���o���ꂽ�S�t���[����           => ���ꂪ臒l�𒴂�����\������
  'consecutiveInvisibleCount', {}); %�A�������񌟏o�t���[����         => ���ꂪ臒l�𒴂����炱�̃g���b�N���폜

nextId = 1; % ID of the next track

%% ���C�����[�v %%%%%
while (a && ~isDone(obj.reader))
  frame = step(obj.reader);     % 1�t���[���ǂݍ���
  
  %% [�t���[�����œ����Ă���S���̂̌��o] %%%%%
  % �t���[�����̕��̂����o�F�����Ă��镨��(�̈�)�̌��o�Fmask��1���O�i�E0���w�i
  mask = step(obj.detector, frame);  % 2�l�}�X�N�摜�FForegroundDetector���g�p
  % �O�����F�ׂ��ȃm�C�Y�̏����E���𖄂߂�
  mask = imopen(mask, strel('rectangle', [3,3]));      %���k->�c���F���݁E�u���b�W����
  mask = imclose(mask, strel('rectangle', [15, 15]));  %�c��->���k�F���E�X���b�g����
  mask = imfill(mask, 'holes');
  % ���S�_�E���E�{�b�N�X�̌��o
  [centroids, bboxes] = step(obj.blobAnalyser, mask);

  %% [���t���[�����ł̈ʒu��O�t���[������\��] %%%%%
  % �J���}���t�B���^��p���āA�O�t���[���܂łɌ��o�ς݂̊e����(�g���b�N)�̈ʒu�\��
  for i = 1:length(tracks)
    bbox = tracks(i).bbox;    % �O�t���[���ł̋��E�{�b�N�X
    % ���t���[���ł̈ʒu�̗\��
    predictedPosition = int32(predict(tracks(i).kalmanFilter));
    % ���E�{�b�N�X�̒��S���A�\���d�S�ʒu�֒���
    tracks(i).bbox = [predictedPosition - bbox(3:4)/2, bbox(3:4)];
  end
  
  %% �����o����(�g���b�N)�ɁA���o���ꂽ���̂�Ή��t�� %%%%%
  % �R�X�g�̌v�Z�F�����o���̗̂\���ʒu�Ɗe���o���̂̋���
  cost = zeros(length(tracks), size(centroids, 1));         % �g���b�N�� x ���o��
  for i = 1:length(tracks)
      cost(i, :) = distance(tracks(i).kalmanFilter, centroids);
  end
  
  % �e�g���b�N�Ɍ��o���ꂽ���̂����� (�n���K���A���A���S���Y���F�R�X�g�̍��v���ŏ��ɂȂ�悤�Ɂj
  % assignment:�g���b�N�ԍ��ƌ��o�ԍ��̑g����������
  costOfNonAssignment = 20;     %�������Ɗ����g���b�N�ɃA�T�C������Ȃ����̑�����=>�V�����g���b�N���������������
  [assignments, unassignedTracks, unassignedDetections] = ...
              assignDetectionsToTracks(cost, costOfNonAssignment);

  %% �Ή����镨�̂����������g���b�N�̏��X�V %%%%%
  for i = 1:size(assignments, 1)
      trackIdx = assignments(i, 1);           %�g���b�N�̔ԍ�
      detectionIdx = assignments(i, 2);       %���o���̂̔ԍ�
      centroid = centroids(detectionIdx, :);  %���̌��o���ꂽ����i�̒��S�_�𒊏o�iobj.blobAnalyser.step(mask)�̌��ʂ��g�p�j
      bbox = bboxes(detectionIdx, :);         %���̌��o���ꂽ���̂̋��E�{�b�N�X�𒊏o�iobj.blobAnalyser.step(mask)�̌��ʂ��g�p)

      % ���o���ꂽ�ʒu�Ɨ\���l��p���āA���݈ʒu�𐄒�
      c2 = correct(tracks(trackIdx).kalmanFilter, centroid);

      % �e�g���b�N�����X�V�F���E�{�b�N�X�Aage�AtotalVisibleCount�AconsecutiveInvisibleCount
      tracks(trackIdx).bbox = bbox;
      tracks(trackIdx).trails{end+1} = c2;
      tracks(trackIdx).age = tracks(trackIdx).age + 1;
      tracks(trackIdx).totalVisibleCount = ...
          tracks(trackIdx).totalVisibleCount + 1;
      tracks(trackIdx).consecutiveInvisibleCount = 0;
  end
    
  %% �Ή����镨�̂�������Ȃ������g���b�N�̏��X�V %%%%%
  %           age�AconsecutiveInvisibleCount
  for i = 1:length(unassignedTracks)
    ind = unassignedTracks(i);
    %tracks(ind).trails{end+1} = predict(tracks(ind).kalmanFilter);    % �\���ʒu�O�Ղ̕\��
    tracks(ind).age = tracks(ind).age + 1;
    tracks(ind).consecutiveInvisibleCount = ...
                  tracks(ind).consecutiveInvisibleCount + 1;
  end
  

  %% ���������g���b�N������ %%%%%
  % �A��20�t���[���ȏ�s�ϑ��Ńg���b�N�������
  if ~isempty(tracks)
    % compute the fraction of the track's age for which it was visible
    ages = [tracks(:).age];
    totalVisibleCounts = [tracks(:).totalVisibleCount];
    visibility = totalVisibleCounts ./ ages;     % �Sage���Ŋϑ����ꂽ�t���[���̊���
      
    % find the indices of 'lost' tracks
    lostInds = (ages < 8 & visibility < 0.6) | ...
               ([tracks(:).consecutiveInvisibleCount] >= 20);   %20�t���[���ȏ�A���s�ϑ��ŏ���

    tracks = tracks(~lostInds);   %���������g���b�N�̏���
  end

  %% �V���Ɍ����������̂ɑ΂��A�V�����g���b�N�𐶐� %%%%%
  %      (�����ł̓A�T�C������Ȃ������g���b�N���A�V�����g���b�N�Ƃ���)
        centroids1 = centroids(unassignedDetections, :);           % Nx2 double
        bboxes = bboxes(unassignedDetections, :);                 % Nx4 int32
        
        for i = 1:size(centroids1, 1)
            
            centroid = centroids1(i,:);
            bbox = bboxes(i, :);
            
            % �����炵�����̈�ɑ΂��āA�J���}���t�B���^�[��1����
            % http://www.mathworks.com/videos/introduction-to-kalman-filters-for-object-tracking-79674.html
            kalmanFilter = configureKalmanFilter('ConstantVelocity', ...
                centroid, ...     % �������W
                [200, 50], ...    % InitialEstimateError ? Initial estimate uncertainty variance [�ʒu�p ���x�p]   ���x�E�����x�͏����l0
                [100, 25], ...    % MotionNoise ? Deviation of selected and actual model
                100);             % MeasurementNoise ? Variance inaccuracy of detected location  ���₷��MotionModel�D��

            
            % �V�����g���b�N�̐���
            newTrack = struct(...
                'id', nextId, ...
                'bbox', bbox, ...
                'kalmanFilter', kalmanFilter, ...
                'trails',{{}},...
                'age', 1, ...
                'totalVisibleCount', 1, ...
                'consecutiveInvisibleCount', 0);
            newTrack.trails{1} = centroid;
            
            % ���������V�����g���b�N���A�g���b�N�̔z��̍Ō�ɒǉ�
            tracks(end + 1) = newTrack;
            
            % nextId��1���₷
            nextId = nextId + 1;
        end

    
%% [���ʂ̕\��] %%%%%
        frame = im2uint8(frame);
        mask = uint8(repmat(mask, [1, 1, 3])) .* 255;  %uint8 RGB�֕ϊ�

        if ~isempty(tracks)

            reliableTrackInds = ...
                [tracks(:).totalVisibleCount] > 8;         % ���o��<8��̂��̂́A�܂��\�����Ȃ�
            reliableTracks = tracks(reliableTrackInds);
            
            if ~isempty(reliableTracks)
                % ���E�̎l�p�g�̍��W�̒��o
                bboxes = cat(1, reliableTracks.bbox);
                
                % ID�ԍ��̎擾
                ids = int32([reliableTracks(:).id]);
                
                labels = cellstr(int2str(ids'));
                predictedTrackInds = ...
                    [reliableTracks(:).consecutiveInvisibleCount] > 0;
                isPredicted = cell(size(labels));
                isPredicted(predictedTrackInds) = {' predicted'};    % ���肵���ꏊ�̏ꍇ
                labels = strcat(labels, isPredicted);
                
                % RGB�̃t���[���̒��ɁA�l�p�g��`��
                frame = insertObjectAnnotation(frame, 'rectangle', ...
                    bboxes, labels);
                
                % RGB�̃t���[�����ɁA�O�Ղ�\��
                for i = 1:length(tracks)
                  p = cat(1,tracks(i).trails{:});                % �g���b�N���ɁA�O�Ղ̍��W Nx2 ���擾
%                  frame = insertMarker(frame, p, 'o', 'color', 'red', 'size', 3);    % �O�Ղ�o�ŕ\��
                  if size(p,1) > 2                              % �O�Ղ���ŕ\��
                    frame = insertShape(frame, 'Line', reshape(p',1,[]), 'color', 'red', 'SmoothEdges',false);
                  end
                end
                
                % �}�X�N�摜���ɁA�l�p�g��`��
                mask = insertObjectAnnotation(mask, 'rectangle', ...
                    bboxes, labels);
                % �}�X�N�摜���ɁAcentroids���{�ŕ\��
                mask = insertMarker(mask, centroids, 'plus');     % �ΐF (���o���ꂽ�S���̂̒��S�_)
            end
        end
        
        % �\��
        obj.videoPlayer.step(frame);          % RGB�t���[���̕\��
        obj.maskPlayer.step(mask);           % �}�X�N�̕\��
        
  drawnow;             % �v�b�V���{�^���̃C�x���g�̊m�F
end


% Copyright 2014 The MathWorks, Inc.

release(obj.reader);
release(obj.videoPlayer);
release(obj.maskPlayer);
release(obj.detector);

