%% Velodyne LiDAR(R)�f�o�C�X����_�Q�̎擾

%% velodynelidar�I�u�W�F�N�g�̒�`
lidar = velodynelidar('VLP16');

% �|�[�g�w��̏ꍇ
% v = velodynelidar('HDL32E','Port',3000) 

% �L�����u���[�V�����t�@�C���w��̏ꍇ
% v = velodynelidar('HDL32E','CalibrationFile','C:\utilities\velodyneFileReaderConfiguration\VLP32C.xml)'

% Model Value	Velodyne Model
% 'HDL32E'	HDL-32E sensor
% 'VLP32C'	VLP-32C Ultra Puck sensor
% 'VLP16'	VLP-16 Puck sensor
% 'PuckLITE'	VLP-16 Puck Lite sensor
% 'PuckHiRes'	VLP-16 Puck Hi-Res sensor

%% �_�Q�̃v���r���[
preview(lidar)
pause(10)
closePreview(lidar)

%% �_�Q�̃X�g���[�~���O�擾�J�n
start(lidar)

%% �ŐV�̓_�Q���擾
[pcloud, timestamp] = read(lidar, 'latest');
pcshow(pcloud);

%% �_�Q�̃X�g���[�~���O���~
stop(v)

%%
% Copyright 2019 The MathWorks, Inc.
