%% �֐S�̈�(ROI)�̎w��Ƒ���
clear;clc;close all;imtool close all

%% �摜�ǂݍ���
figure
im = imread('peppers.png');
imshow(im)

%% ���܂��܂�ROI�w��
h1 = drawellipse('Center',[127 174],'SemiAxes',[56 24],'RotationAngle',27);
h2 = drawcircle('Center',[152 278],'Radius',30,'Color','red');
h3 = drawfreehand('Position',[86 278;50 262;16 270;5 306;19 340;47 357;80 343;97 312],'Color','yellow');
h5 = drawline('Position',[235 226; 268 237],'Color','green');
h6 = drawpoint('Position',[334 225],'Color','magenta');
h7 = drawpolygon('Position',[448 227;419 308; 509 305],'Color','cyan');
h8 = drawpolyline('Position',[101 383;103 306;406 293],'Color','blue');
h9 = drawrectangle('Position',[185 78 79 54],'Color','white');
shg;

%% �A�V�X�g�t���̃t���[�n���h�œK���ȗ̈���͂�
h = drawassisted();

%% �}�X�N����
bw = createMask(h);
figure, imshow(bw);

%% ���������}�X�N���A���t�@�}�X�N�Ƃ��ăK�C�h�t�B���^�[��������
alphamat = imguidedfilter(single(bw),im,'DegreeOfSmoothing',2);
figure, imshow(alphamat);

%% �K�p�Ώۂ̉摜��ǂݍ��݁A���T�C�Y
target = imread('fabric.png');
alphamat = imresize(alphamat,[size(target,1),size(target,2)]);
im = imresize(im, [size(target,1), size(target,2)]);
figure, imshowpair(im,target,'montage');

%% �A���t�@�u�����h
fused = single(im).*alphamat + (1-alphamat).*single(target);
fused = uint8(fused);
figure, imshow(fused); shg;

%% �}�X�N�摜�̎��O��`
h = 150;  % ��������}�X�N�̍���
w = 250;  % ��������}�X�N�̕�
BW = false(h,w);
figure, imshow(BW);

%% drawpolygon��ROI�w��
x = [116 194 157 112 117];
y = [ 34  72 105  99  34];
hPolygon = drawpolygon('Position',[x' y']);
shg;

%% roipoly()�Ń}�X�N����
BW = roipoly(h, w, x, y);
figure; imshow(BW);

%% poly2mask()�Ń}�X�N����
BW = poly2mask(x, y, h, w);
figure; imshow(BW);

%% �ȉ~�`��ROI�w��
BW = false(150, 250);          % ��������}�X�N�Ɠ����T�C�Y
figure; h_im = imshow(BW);
position = [55 20 150 100];     % [xmin ymin width height]
e = drawellipse(gca, 'Center',position(1:2)+position(3:4)/2,...
    'SemiAxes',position(3:4)/2);
shg;

%% �ȉ~�`��ROI����}�X�N����
BW = createMask(e, h_im);
figure, imshow(BW);

%% 3D�̃L���[�{�C�h(������)�ł�ROI�w��
load seamount
figure;
hScatter = scatter3(x,y,z);
hCuboid = drawcuboid(hScatter);

%%
% Copyright 2018 The MathWorks, Inc.

