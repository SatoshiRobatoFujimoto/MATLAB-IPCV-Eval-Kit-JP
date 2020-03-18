%% CNN �ɂ��摜�̃K�e�S������
% USB�J�����̉摜����A
%  �J�b�v�A���b�v�g�b�vPC�A�s�U�A�r���v�A �̔F��

%% ������
clc;close all;imtool close all;clear;imaqreset;

%% �w�K�ς݂̕��ފ�̓Ǎ���
if ~exist('I5_06_2_2_myCNNTransferLearning.mat','file')
    error('<a href="matlab:edit I5_06_2_2_myCNNTransferLearning.m">I5_06_2_2_myCNNTransferLearning.m</a>�Ŋw�K�����s���Ă��������B');
end
d = load('I5_06_2_2_myCNNTransferLearning.mat');
convnet = d.netTransfer;

%% USB �J��������r�f�I���捞�ރI�u�W�F�N�g�̒�`
vidobj = imaq.VideoDevice('winvideo', 1, 'RGB24_320x240');
vidobj.ReturnedDataType = 'uint8';

%% PC�̉�ʂɃr�f�I��\������r���[���̒�`
viewer = vision.DeployableVideoPlayer;

%% �{�^���\��
a=true;
b=false;
sz = get(0,'ScreenSize');
figure('MenuBar','none','Toolbar','none','Position',[20 sz(4)-170 100 140])
uicontrol('Style', 'pushbutton', 'String', 'Stop',...
        'Position', [20 20 80 40],'Callback', 'a=false;');
uicontrol('Style', 'pushbutton', 'String', 'Recog On',...
        'Position', [20 80 80 40],'Callback', 'b=true;');

%% �J��������1�t���[�����Ǎ��ݏ���������
while (a) 
  I = step(vidobj);              % �J��������1��ʎ捞��
  I1 = I([7:233], [47:273], :);  % �T�C�Y�� 227x227��

  [labels, scores] = classify(convnet, I1);
  
  if b
    I = insertText(I, [1 1], ['Cu La Pi Wa: ' num2str(scores, '%6.2f')], 'FontSize', 14);
   
    Smax = max(scores); 
    if (Smax > -0.2)
      I = insertText(I, [80 80], cellstr(labels), 'FontSize',32); 
    end
  end
  step(viewer, I);
  
  drawnow limitrate;      % �v�b�V���{�^���̃C�x���g�̊m�F
end

%%
release(vidobj);
release(viewer);

%% Copyright 2018 The MathWorks, Inc. 