clear all;clc;close all;imtool close all

%% �Ȗʂւ̉�A
%   �摜�̓Ǎ��ݥ�e�X�g
G = imread('I3_06_2_IMG_blockG.jpg');
G = im2double(G);
figure;imshow(G,[]);

%% �\�ʃv���b�g
figure;surf(double(G));shading interp;

%% ���S������菜��
s = G;
s(120:240, 70:190) = NaN;
figure;surf(double(s));shading interp;

%% �������x����̂��߁A�f�[�^�_�̊Ԉ��� (NaN�̑��)
mask = true(size(s));
mask([1:20:end], [1:20:end]) = false;
s(mask) = NaN;

%% �f�[�^�̏����FNaN���������AxData,yData,zData�̃x�N�g���̌`�֕ϊ�
[xData, yData, zData] = prepareSurfaceData([1:size(s,1)], [1:size(s,2)], s);

%% GUI�c�[���ōs���Ƃ�
%cftool  % X�EY�EZ�f�[�^ => xData�EyData�EzData�Ǝw��A��������I���Ax��y�̎������S����
%        % �ߎ��v���_�E�����j���[ => "���[�N�X�y�[�X�֕ۑ�"��I��
%        % "OK" => fittedmodel�̖��O�Ń��[�N�X�y�[�X�֕ۑ������

%% �R�}���h�ōs���Ƃ�
% �ߎ��^�C�v�ƃI�v�V������ݒ�
ft = fittype( 'poly44' );
% ���f�����f�[�^�ɋߎ����܂��B
fittedmodel = fit( [xData, yData], zData, ft)

%% �ߎ����ʂ��v���b�g���܂��B(�Ԉ������� x�Ey �_�ɑ΂�)
figure( 'Name', '�ߎ�');
% plots "z versus x and y" and plots "sfit over the range of x and y".
h = plot( fittedmodel, [xData, yData], zData );
legend( h, '�ߎ�', 'z vs. x, y', 'Location', 'NorthEast' );
% ���x�� Axes
xlabel( 'x' );
ylabel( 'y' );
zlabel( 'z' );
grid on
view( -98.5, 18.0 );

%% �w�i�̖ʂ��A���摜��x�Ey�ׂ̍���(�S�s�N�Z���ʒu)�Ōv�Z���A
%   �摜�f�[�^�ɖ߂�
[gridX gridY] = meshgrid([1:size(G,2)], [1:size(G,1)]);
backGround1 = fittedmodel(gridX(:), gridY(:));  % ��x�N�g��
% ��x�N�g����2�����֕ύX
backGround2 = reshape(backGround1, size(G,1), size(G,2));
figure;imshow(backGround2,[]);

%% �w�i�̋ǖʂ����������␳��摜�𐶐�
finalImage = G - backGround2;
imtool(finalImage,[0,0.2]);

%% �I��











%% ��l�����邾���ł���΁A�K����l���̎g�p���\
BW = imbinarize(G, 'adaptive','ForegroundPolarity','bright','Sensitivity',0.57);
figure; imshow(BW);

%% ��A�����ʂ̍ő�l�|�C���g��T�� (Optimization Toolbox���K�v)
%       �ɑ傪��������ꍇ�ɂ͒���
% �ړI�֐� (�ϐ��͈�j�ւ̃n���h������
%    �����̈���������ꍇ�́A�����֐����쐬���P�̃x�N�g���ɂ܂Ƃ߂�
%    fmincon�͍ŏ��l��T���̂ŁA�ő�l��T�������֐���-1���|����
h = @(x) -1 * fittedmodel(x(1), x(2));
%% ���������l�̐ݒ�
x0 = [200; 150];
%% ��������Fy �̂ݐ��`�s��������  0<= x <=250, 0<= y <=200
l = [  0;   0]
u = [250; 200]
%% �œK���I�v�V�����̐ݒ�
options = optimset('LargeScale', 'off');
%% ��������t�̍œK��
[x, fval] = fmincon(h, x0, [], [], [], [], l, u, [], options)

%%



%% (�Q�l) �Ȗʉ�A�p�e�X�g�摜�̍쐬�p�X�N���v�g %%%%%%
% �t�@�C������摜�Ǎ��݁E�\��

I=imread('rice.png');        % �t�@�C������摜�Ǎ���
figure; imshow(I);           % �摜�̕\��
figure; surf(double(I));     % �\�ʃv���b�g
        shading interp;      % �\�������₷��

Ierode=imerode(I, ones(15));     % ���k�����ɂ��ė��̏���
figure;imshow(Ierode);
figure; ...
surf(double(Ierode));shading interp;     % �w�i�\�ʃv���b�g

Fave = fspecial('average', 30);
Iave = imfilter(Ierode,Fave,'replicate');
figure;imshow(Iave,[]);
a = Iave*2;

b = imread('coins.png');
imtool(b)
c = (b(177:246, 86:155)-72)/4;
d = imresize(c,1.7);
figure;imshow(d);

a(121:239, 71:189) = a(121:239, 71:189) + d;
figure;imshow(a,[]);
figure;surf(double(a));shading interp;
imwrite(a, 'IMG_blockG.jpg');

%%

% Copyright 2014 The MathWorks, Inc.


