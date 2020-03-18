%% ������
clear;clc;close all;imtool close all

%% Step 1: �g���b�L���O������悸���o
% ��F���p�I�u�W�F�N�g�̍쐬
faceDetector = vision.CascadeObjectDetector();

% 1�t���[���Ǎ��݁A�猟�o�����s
videoFileReader = vision.VideoFileReader('visionface.avi');
videoFrame      = step(videoFileReader);
bbox            = step(faceDetector, videoFrame);

% ���o������̎���Ɏl�p��`�悵�A�摜��\��
videoOut = insertObjectAnnotation(videoFrame,'rectangle',bbox,'Face');
figure, imshow(videoOut), title('Detected face');


%% Step 2: Identify Facial Features To Track
% Get the skin tone information by extracting the Hue from the video frame
% converted to the HSV color space.
% Hue�`���l���ŕ\�����A��̎���Ɏl�p��`��
% ���F���g���b�L���O��������Ƃ��ėp����B(�炪�ړ�������X���Ă��ς��Ȃ�������)
[hueChannel,~,~] = rgb2hsv(videoFrame);   % HSV��Ԃ֕ϊ�
figure, imshow(hueChannel), title('Hue channel data');
rectangle('Position',bbox(1,:),'LineWidth',2,'EdgeColor',[1 1 0])


%% STEP3 : ����g���b�L���O
% �@�̗̈��Hue�q�X�g�O�����Ńg���b�L���O(�w�i���܂܂�Ȃ�����)
noseDetector = vision.CascadeObjectDetector('Nose');
faceImage    = imcrop(videoFrame,bbox(1,:));
noseBBox     = step(noseDetector,faceImage);

% The nose bounding box is defined relative to the cropped face image.
% Adjust the nose bounding box so that it is relative to the original video
% frame.
noseBBox(1,1:2) = noseBBox(1,1:2) + bbox(1,1:2);

% Create a tracker object.
tracker = vision.HistogramBasedTracker;

% tracker���A�@�̈�̃s�N�Z����Hue�ŏ�����
initializeObject(tracker, hueChannel, noseBBox(1,:));

% Create a video player object for displaying video frames.
videoInfo    = info(videoFileReader);
videoPlayer  = vision.VideoPlayer('Position',[300 300 videoInfo.VideoSize+30]);

% Track the face over successive video frames until the video is finished.
while ~isDone(videoFileReader)

    % �P�t���[���Ǎ���
    videoFrame = step(videoFileReader);

    % ����RGB���AHSV�֕ϊ�
    [hueChannel,~,~] = rgb2hsv(videoFrame);

    % �O�t���[���̕@������Hue�q�X�g�O������p���A�g���b�L���O
    bbox = step(tracker, hueChannel);

    % Insert a bounding box around the object being tracked
    videoOut = insertObjectAnnotation(videoFrame,'rectangle',bbox,'Face');

    % Display the annotated video frame using the video player object
    step(videoPlayer, videoOut);

end

% Release resources
release(videoFileReader);
release(videoPlayer);

% Copyright 2014 The MathWorks, Inc.
