%% �Ȃ����Ă���USB�J�����̃��X�g��\��
webcamlist

%% �J��������摜���捞�ރI�u�W�F�N�g�𐶐�
camera = webcam('Logicool HD Pro Webcam C920')    %��L webcamlist�ŕ\�����ꂽ���̂̒�����A�g�p����J�������w��
% camera = webcam       %���̋L�q���́AUSB�J������1�݂̂Ȃ����Ă���ꍇ�̂݉\

camera.AvailableResolutions
camera.Resolution = '640x480'    %�捞�މ摜�̉𑜓x��ݒ�

% preview(camera)       % �v���r���[����ׂ̊֐�

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
  I = snapshot(camera);        %1�t���[����荞�� (uint8)
  Itxt = step(texts,I,fps);    %�t���[�����[�g�̏�����
  step(viewer,Itxt);           %�t���[���\��

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
clear('camera');
release(viewer);
release(texts);

%%
%  Copyright 2014 The MathWorks, Inc.

