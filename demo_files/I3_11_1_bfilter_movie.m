%% GPU Coder �f�� : Bilateral Filter�̍�����
% Bilateral Filter�̓G�b�W�L�[�v�^�̃t�B���^�Ƃ��Ă��ǂ��m���Ă���A
% ��p�摜�����ȂǗl�X�ȕ���ŗp�����Ă��܂��B
% �P�x���ɉ����ďd�ݕt���v�Z���s���K�v�����邽�߁A
% ���[�v���ŋǏ��̈�𒊏o > �d�݌v�Z > �t�B���^�����O�A�Ƃ���������ɂȂ�܂��B
%
% �������̂͂�����X�e���V���v�Z�̈��ƂȂ�܂����A�����GPU Coder���g����
% ���������s���܂��B
%
% �{�f�������s���邽�߂ɂ́AGPU�����ڂ���Ă���}�V�����K�v�ƂȂ�܂��B
% ���s�ɕK�v�ȃf�o�C�X�A�c�[�����̏����ɂ��܂��ẮA���L�h�L�������g��������������.
% <https://www.mathworks.com/help/releases/R2017b/gpucoder/getting-started-with-gpu-coder.html>
% 

clear; close all; clc;
%% �r�f�I�ǂݎ��p&�r���[���[�I�u�W�F�N�g�̒�`
videoFReader = vision.VideoFileReader('potholes2.avi');
videoPlayer = vision.VideoPlayer;

%% �t���[�����[�g�v���p�ϐ���`
t = tic();
cnt = 1;
fps = single(0.0);

%% Stop �{�^���\��
a=true;
sz = get(0,'ScreenSize');
figure('MenuBar','none','Toolbar','none','Position',[20 sz(4)-100 100 70])
uicontrol('Style', 'pushbutton', 'String', 'Stop',...
        'Position', [20 20 80 40],...
        'Callback', 'a=false;');

%% ���[�v�Đ�
reset(videoFReader)
while ~isDone(videoFReader) && a
    videoFrame = videoFReader(); %1�t���[���ǂݍ���
    bimg = bfilter2cGPC(videoFrame); %Bilateral Filter����
    bimg = insertText(bimg, [20 20], ['Running at ' num2str(round(fps,2)) 'fps'],...
        'Font', 'Calibri', 'FontSize', 14, 'BoxOpacity',0.6,'TextColor','black');
    
    videoPlayer([videoFrame bimg]);
    
   % ���Ԍv��
   % 5�t���[���̏��v���Ԃ���t���[�����[�g���v��
   cnt = cnt + 1;
   if (mod(cnt,5) == 0)
       t = toc(t);
       fps = single(5/t);
       t = tic();
   end

end

%% GPU Coder�𗘗p����MEX����
cfg = coder.gpuConfig('mex');
codegen -args {videoFrame} -config cfg bfilter2cGPC -o bfilter2cGPC_mex

%% ���[�v�Đ�
t = tic();
cnt = 1;
a = true;
fps2 = single(0.0);
reset(videoFReader)
reset(videoPlayer)
while ~isDone(videoFReader)
    videoFrame = videoFReader(); %1�t���[���ǂݍ���
    bimg = bfilter2cGPC_mex(videoFrame); %Bilateral Filter����(MEX)
    bimg = insertText(bimg, [20 20], ['Running at ' num2str(round(fps2,2)) 'fps'],...
        'Font', 'Calibri', 'FontSize', 14, 'BoxOpacity',0.6,'TextColor','black');
    
    videoPlayer([videoFrame bimg]);
    
   % ���Ԍv��
   % 5�t���[���̏��v���Ԃ���t���[�����[�g���v��
   cnt = cnt + 1;
   if (mod(cnt,5) == 0)
       t = toc(t);
       fps2 = single(5/t);
       t = tic();
   end

end

%% MEX���ɂ�鍂�����̊���
fps2 / fps

%%
release(videoFReader)
release(videoPlayer)

%% 
% Copyright 2018 The MathWorks, Inc.