%% �Θb�I�ȉ摜�̏C��
%% �摜�̓ǂݍ��� 
I = imread('greensdistorted.png');
%% �Θb�I�ȑ���
% figure�E�B���h�E�̍쐬
h = figure('Name','Interactive Image Inpainting','Position',[0,0,700,400]);

% UI�p�l���̒ǉ�
dataPanel = uipanel(h,'Position',[0.01 0.5 0.25 0.5],'Title','Set parameter values','FontSize',10);

% �p�b�`�T�C�Y�����̂��߂�UI�̒ǉ�
uicontrol(dataPanel,'Style','text','String','Enter Patch Size','FontSize',10,'Position',[1 150 120 20]);
data.patchSize = uicontrol(dataPanel,'Style','edit','String',num2str(9),'Position',[7 130 60 20]);

% fill order��I�����邽�߂�UI��ǉ�
uicontrol(dataPanel,'Style','text','String','Select Filling Order','FontSize',10,'Position',[5 100 120 20]);
data.fillOrder = uicontrol(dataPanel,'Style','popupmenu','String',{'gradient','tensor'},'Position',[7 80 80 20]);

% �摜�\���̂��߂̃p�l����ǉ�
viewPanel = uipanel(h,'Position',[0.25 0 0.8 1],'Title','Interactive Inpainting','FontSize',10);
ax = axes(viewPanel);
%% �摜��\��
hImage = imshow(I,'Parent',ax); 
%% �摜�ɃR�[���o�b�N�֐���ǉ�
% ROI���w�肷��Ɖ摜�C�������s�����
hImage.ButtonDownFcn = @(hImage,eventdata)clickCallback(hImage,eventdata,data);
%% �g�p�@
% �X�e�b�v�P
% �p�b�`�T�C�Y��fill order��I������
% 
% �X�e�b�v�Q
% �摜��őΘb�I��ROI���w�肷��B�N���b�N/�h���b�O��ROI�̐��������A�{�^���𗣂��Ɨ̈�w�����������
%% �R�[���o�b�N�֐�
function clickCallback(src,~,data)
% �ϐ��̓���
fillOrder = data.fillOrder.String{data.fillOrder.Value};
pSize = data.patchSize.String;
patchSize = str2double(pSize);
% �t���[�n���hROI�̓��͎�t
h = drawfreehand('Parent',src.Parent);
% �}�X�N�̍쐬
mask = h.createMask(src.CData);
% �摜�C���̎��s
newImage = inpaintExemplar(src.CData,mask,'PatchSize',patchSize,'FillOrder',fillOrder);
% �摜�̍X�V
src.CData = newImage;
% ROI�n���h���̏���
delete(h);
end
%% 
% _Copyright 2019 The MathWorks, Inc._