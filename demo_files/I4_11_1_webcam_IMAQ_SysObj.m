clc;close all;imtool close all;clear;

%% �J��������摜����荞�ނ��߂̃V�X�e���I�u�W�F�N�g�̐���
hCamera = imaq.VideoDevice('winvideo', 1, 'RGB24_640x480')      % ���ɍ��킹�āAWebcam�̔ԍ�(2�Ԗڂ̈���)��ݒ�
hCamera.ReturnedDataType = 'uint8';       %�f�t�H���g��Single�^�F�\����uint8�֕ϊ����A������

%% �r�f�I��\�����邽�߂̃I�u�W�F�N�g�̐���
viewer = vision.DeployableVideoPlayer;

%% �t���[�����[�g���������ނ��߂̃I�u�W�F�N�g�𐶐�
fps = single(0.0);
texts = vision.TextInserter('Running at %2.2f fps', ...
  'Color',[0, 255, 0], 'FontSize',30, 'Location',[20 20]); 

%% �t���[�����[�g�v���p
t = tic();
cnt = 1;

%% �X�g�b�v�{�^���̕\��
a=true;
sz = get(0,'ScreenSize');
figure('MenuBar','none','Toolbar','none','Position',[20 sz(4)-100 100 70])
uicontrol('Style', 'pushbutton', 'String', 'Stop',...
        'Position', [20 20 80 40],...
        'Callback', 'a=false;');

%% 1�t���[�����ɏ������邽�߂̃��[�v����
while (a)
% for i=1:200 
  I = step(hCamera);         %1�t���[���捞��
  Itxt = step(texts,I,fps);  %�t���[�����[�g�̏�����
  step(viewer,Itxt);         %1�t���[���\��

   % 30�t���[���̕��ς���t���[�����[�g�̌v�Z
   cnt = cnt + 1;
   if (mod(cnt,30) == 0)
    t = toc(t);
    fps = single(30/t);
    t = tic();
   end
   drawnow limitrate;
end

%%
release(hCamera);
release(viewer);
release(texts);

%%



%% �Q�l�F�e��ݒ�������
hCamera.DeviceProperties.FrameRate = '5';     %�t���[�����[�g��5fps(���b5�t���[��)�֕ύX





%%
%  Copyright 2014 The MathWorks, Inc.


