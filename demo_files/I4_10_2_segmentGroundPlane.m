%% LiDAR�̓_�Q�f�[�^����H�ʌ��o

%% Velodyne PCAP�t�@�C�����[�_�[���`
velodyneFileReaderObj = velodyneFileReader('lidardata_ConstructionRoad.pcap','HDL32E');

%% pcplayer���`
xlimits = [-40 40];
ylimits = [-15 15];
zlimits = [-3 3];
player = pcplayer(xlimits,ylimits,zlimits);
xlabel(player.Axes,'X (m)')
ylabel(player.Axes,'Y (m)')
zlabel(player.Axes,'Z (m)')

%% �J���[�}�b�v���`
colors = [0 1 0; 1 0 0]; % �΂Ɛ�
greenIdx = 1; % �΂̃C���f�b�N�X
redIdx = 2; % �Ԃ̃C���f�b�N�X
colormap(player.Axes,colors)
title(player.Axes,'Segmented Ground Plane of Lidar Point Cloud');

%% �ŏ���200�_�Q��H�ʌ��o���A���ʂ�\��
for i = 1 : 200
    % ���݂̓_�Q��ǂݍ���
    ptCloud = velodyneFileReaderObj.readFrame(i);
    
    % ���x���s��쐬
    colorLabels = zeros(size(ptCloud.Location,1),size(ptCloud.Location,2));
    
    % �H�ʌ��o
    groundPtsIdx = segmentGroundFromLidarData(ptCloud);
    
    % �H�ʂ�΂̃C���f�b�N�X�ɂ���
    colorLabels(groundPtsIdx (:)) = greenIdx;
    % �H�ʈȊO��Ԃ̃C���f�b�N�X�ɂ���
    colorLabels(~groundPtsIdx (:)) = redIdx;
    
    % ���ʂ̉���
    view(player,ptCloud.Location,colorLabels)
end

%%
% Copyright 2018 The MathWorks, Inc.