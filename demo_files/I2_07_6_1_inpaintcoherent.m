%% �摜�̏C���i�C���y�C���e�B���O�E�s�v���̏����j

%% �摜�ǂݍ��݂Ɖ���
I = imread('coloredChips.png');
figure
imshow(I,[])

%% �C���ӏ����~�Ŏw��
h = drawcircle('Center',[130,42],'Radius',40);
numRegion = 6;
roiCenter = [130 42;433 78;208 108;334 124;434 167;273 58];
roiRadius = [40 50 40 40 40 30];
roi = cell([numRegion,1]);
for i = 1:numRegion
    c = roiCenter(i,:);
    r = roiRadius(i);
    h = drawcircle('Center',c,'Radius',r);
    roi{i} = h;
end

%% createMask�֐��Ŏw�肵��ROI�̃}�X�N�𐶐�
mask = zeros(size(I,1),size(I,2));
for i = 1:numRegion
    newmask = createMask(roi{i});
    mask = xor(mask,newmask);
end
% ����
montage({I,mask});
title('�C���O�摜 vs �C���ӏ��̃}�X�N�摜');

%% �Y���ӏ��̉摜�C��
J = inpaintCoherent(I,mask,'SmoothingFactor',0.5,'Radius',1);
montage({I,J});
title('�C���O�摜 vs �C����摜');

%% 
% Copyright 2019 The MathWorks, Inc.