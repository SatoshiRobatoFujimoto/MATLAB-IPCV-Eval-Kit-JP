%% ������
clear; close all; clc;

%% �e��V�X�e���I�u�W�F�N�g�̐���
% ����Ǎ��ݗp�̃I�u�W�F�N�g�̍쐬
filename = 'viptraffic.avi';
hVidReader = vision.VideoFileReader(filename, ...
                              'VideoOutputDataType','single', 'PlayCount',inf);
% �I�v�e�B�J���t���[�p�̃I�u�W�F�N�g�̍쐬
opticFlow = opticalFlowHS;

% �I�v�e�B�J���t���[�̕��ϒl���v�Z����I�u�W�F�N�g�̍쐬
hMean2 = vision.Mean('RunningMean', true);   % ���݂܂ł̑S�t���[���̕���

% Blob��́F�ʐρE���E�{�b�N�X�E���E�{�b�N�X����Blob�̖ʐϊ���
hblob = vision.BlobAnalysis(...
    'CentroidOutputPort', false, 'AreaOutputPort', true, ...
    'BoundingBoxOutputPort', true, 'ExtentOutputPort', true, ...
    'OutputDataType', 'double', ...
    'MinimumBlobArea', 250, 'MaximumBlobArea', 3600, 'MaximumCount', 80);

% �\���p�̃I�u�W�F�N�g�̍쐬
f = figure;
sz = get(0,'ScreenSize');
pos = [180 sz(4)-500 200+700 300];
f.Position = pos;
ax1 = axes('Position', [0, 0, 0.25, 1]);
ax2 = axes('Position', [0.25, 0, 0.25, 1]);
ax3 = axes('Position', [0.5, 0, 0.25, 1]);
ax4 = axes('Position', [0.75, 0, 0.25, 1]);

% �X�g�b�v�{�^���̕\��
a=true;
figure('MenuBar','none','Toolbar','none','Position',[20 sz(4)-100 100 70])
uicontrol('Style', 'pushbutton', 'String', 'Stop',...
        'Position', [20 20 80 40],...
        'Callback', 'a=false;');
    
%%
% ���[�v�����̃X�^�[�g
while (a)
    %% �����1�t���[���Ǎ��݁E�\��  ====> ���1:���̓r�f�I
    frame  = step(hVidReader);                   % �P�t���[���Ǎ���
    imshow(frame, 'Parent', ax1);                                 % �\��
    
    %% �I�v�e�B�J���t���[�̌v�Z�E�\��  ====> ���2
    grayFrame = rgb2gray(frame);                 % �J���[�摜���O���[�X�P�[���֕ϊ�
	flow  = estimateFlow(opticFlow, grayFrame);  % �I�v�e�B�J���t���[�v�Z
    
    imshow(ones(120, 160, 3, 'single'), 'Parent', ax2)
    hold(ax2, 'on')
    plot(flow,'DecimationFactor',[3 3],'ScaleFactor',10,'Parent',ax2);
    hold(ax2, 'off')    
    
    %% �ړ����̗̈�̒��o�E�\��  ====> ���3
    y1 = flow.Magnitude;    % �e��f�ł̑��x�̑傫���l���擾
		
    % ���x�̖ʓ����� => ���ԕ������� => *4 ��臒l�Ƃ���
    vel_th = 4 * step(hMean2, mean(y1(:)));

    % ���x��2�l�摜���쐬���AMedianFilter�Ńm�C�Y����
    segmentedObjects = medfilt2(y1 >= vel_th);

    % ���k�����Ŕ������������A�ԕ����̌���Close�����Ŗ��߂�   ===> ���3: ��l�摜�r�f�I (���x�̑傫����2�l�����A�N���[�Y����)
    segmentedObjects2 = imclose(imerode(segmentedObjects, strel('square',2)), strel('line',5,45));
    imshow(segmentedObjects, 'Parent', ax3)
    
    %% �Ԃ̔F���E�䐔�̌v���E�\��  ====> ���4
    % Blob��́F�ʐρE���E�{�b�N�X�E���E�{�b�N�X����Blob�̖ʐϊ���
    [area, bbox, extent] = step(hblob, segmentedObjects);

    isCar = extent > 0.4;   % ���E�{�b�N�X���̕��̂̊������A40%�ȏ�̂��̂��ԂƔF��
    numCars = sum(isCar);   % �Ԃ̑䐔�̌v��
    bbox(~isCar, :) = [];   % �ԂƔF���������E�{�b�N�X�̂ݎc��

    % �F�������Ԃ̎���Ɏl�p�����E�{�b�N�X��`��
    y2 = insertShape(frame, 'Rectangle', bbox, 'Color','green');
    
    % �Ԃ̑䐔���摜�̍���ɑ}��
    y2(1:30,1:30,:) = 0;   % ���������₷���悤�ɁA�w�i����������
		result = insertText(y2, [5 1], numCars, 'FontSize',18, ...
			                  'BoxColor','black', 'BoxOpacity',0, 'TextColor','white');     % ====> ���4
    imshow(result, 'Parent', ax4);           % �\��
        
    pause(0.1);                      % �E�F�C�g�����āA�Đ����x�����₷�������։�����
    drawnow;                         % �v�b�V���{�^���̃C�x���g�̊m�F
end                              % while ���[�v���̍Ō�

%%
release(hVidReader);
release(hMean2);
release(hblob);

%% �I��



% ��������ɂ����Ԃ̌��o
% �ォ��A22�E23�s�N�Z���ڂɉ�����
%
% ���x�̑傫���œ�l��
% �Ԑ��������k�����ŏ���
% �Ԃ̒��������N���[�Y����
% Blob��͂���ɂŁA���E�{�b�N�X��W���E�䐔�\��
%
% Figure��� Stop�{�^�� �ŏI��
% 
% The output video shows the cars which were tracked by drawing boxes
% around them. The video also displays the number of tracked cars.


%% Copyright 2004-2018 The MathWorks, Inc.
% This is a script for Tracking Cars Using Optical Flow
%
% This can be found by the following command
%     web([docroot '/vision/examples/tracking-cars-using-optical-flow.html'])
% or the following URL.
%     http://www.mathworks.com/help/releases/R2012b/vision/examples/tracking-cars-using-optical-flow.html

% This example shows how to track cars in a video by detecting motion using optical 
% flow. The cars are segmented from the background by thresholding the 
% motion vector magnitudes. Then, blob analysis is used to identify 
% the cars.
