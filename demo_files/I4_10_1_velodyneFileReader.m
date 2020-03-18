%% Velodyne LiDAR PCAP(Point Capture)�t�@�C���̓ǂݍ���

%% ������
clear; close all; clc;

%% Velodyne PCAP�̃t�@�C�����[�_�[���`
veloReader = velodyneFileReader('lidarData_ConstructionRoad.pcap','HDL32E');

%% �|�C���g�N���E�h�v���C���[��ݒ�

% �\���͈͂�ݒ�
xlimits = [-60 60];
ylimits = [-60 60];
zlimits = [-20 20];

player = pcplayer(xlimits,ylimits,zlimits);

% ���̃��x��
xlabel(player.Axes,'X (m)');
ylabel(player.Axes,'Y (m)');
zlabel(player.Axes,'Z (m)');

%% �_�Q��ǂݏo���Ȃ���\��

% �ǂݏo��������ݒ�
veloReader.CurrentTime = veloReader.StartTime + seconds(0.3); 
while(hasFrame(veloReader) && player.isOpen() && (veloReader.CurrentTime < veloReader.StartTime + seconds(10)))
    % �_�Q�ǂݏo��
    ptCloudObj = readFrame(veloReader);
    
    % �_�Q�\��
    view(player,ptCloudObj.Location,ptCloudObj.Intensity);
    
    % 0.1�b�ҋ@(��茵���ɕ\�����������ꍇ��fixed rate��timer���g�p���邱��)
    pause(0.1);
end

%%
% Copyright 2018 The MathWorks, Inc.
