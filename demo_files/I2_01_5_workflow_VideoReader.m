clear; clc; close all; imtool close all

%% ����@�摜�����E��͂̃��[�N�t���[ %%%%%%%%%%%%%%
% ����̓Ǎ��݁E�\���E���o�� �p�̃V�X�e���I�u�W�F�N�g�̐���
%       VGA (480x640 pixels)
vidReader = VideoReader('tilted_face.avi'); 
%info = mmfileinfo('tilted_face.avi')
%info.Video        % Format: 'MJPEG', Height, Width
    % �J�������璼�ڎ捞�ޏꍇ�̗�
    % vidReader = imaq.VideoDevice('winvideo', 2, 'MJPG_640x480', 'ReturnedDataType','uint8');
    % ���jUSB�J�����͈Â���ʂł͑��x�i�t���[�����[�g�j���ቺ������̂�
vidPlayer = vision.DeployableVideoPlayer;
vidWriter = vision.VideoFileWriter('tmp_myFile.avi');


%% 1�t���[�������ɏ���
while hasFrame(vidReader)
   I = readFrame(vidReader);       % 1�t���[�� �Ǎ���
   %
   % �����Ɋe��摜�������� �̃R�[�h��}�� �|�|�|�|�|�|�|�|�|
   %
   step(vidPlayer, I);        % 1�t���[�� �\��
   %step(vidWriter, I);        % 1�t���[�� ���o��

end
%% ���������V�X�e���I�u�W�F�N�g�������[�X
%release(vidReader);
release(vidPlayer);
release(vidWriter);

%% �I��


% Copyright 2014 The MathWorks, Inc.


