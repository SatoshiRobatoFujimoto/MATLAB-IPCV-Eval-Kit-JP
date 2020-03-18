%% �e�L�X�g�̌X���̏C��
clc;close all;imtool close all;clear;

%% �e�X�g�摜�̍쐬
x = imread('text.png');
I = uint8(x(5:60,5:end-40)*255);
I = imrotate(I, 30, 'bicubic');     % �����v����30�x��]
figure; imshow(I);

%% �摜�̂ڂ��� 
BW = imdilate(logical(I), strel('disk',4));  
figure; imshow(BW);

%% Hough�ϊ����A�p�x�����߁A�t��]�␳
%      H:     �n�t�ϊ��s��
%      theta: x���l : �p�x(��)   -90���`89��  ����X���ɑ΂��Ď��v���ɒ�`
%      rho  : y���l
[H,theta,rho] = hough(BW);
peak = houghpeaks(H, 1)        % �s�[�N�̓_��theta��rho�̔ԍ��g
%% �֐� houghlines ���g���Č��o���ꂽ���̕\��
lines = houghlines(BW, theta, rho, peak);      %lines�F point1, point2, theta, rho �����\����
% ���̃C���[�W�ɏd�˂Đ����v���b�g
hold on
xy = [lines.point1; lines.point2];   %   xy : [x1 y1; x2 y2]
plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
hold off

%% �t��]���ĕ␳
if theta(peak(1,2)) > 0
    ang = 90 - theta(peak(1,2));
else
    ang = -1 * (90 + theta(peak(1,2)));
end
Irot = imrotate(I, -1 * ang, 'bicubic');     %ang���t��]
imtool(Irot);

%% ����ɁA�̈�̉��̕����̉��ցA�������ߎ����ČX�����ďC��
BW2 = imdilate(logical(Irot), strel('disk',4)); 
[C, Ind] = max(flipud(BW2));
Ind(Ind == 1) = [];                       %�������Ȃ�����폜
y = polyfit(0:(size(Ind,2)-1), Ind, 1);   %�������t�B�e�B���O
ang2 = atan(y(1)) * (180/pi);             %�����̌X������p�x���v�Z
Irot2 = imrotate(Irot, -1 * ang2, 'bicubic');      %ang2�̊p�x���t��]
imtool(Irot2);

%% [�ʂ̕��@] Hough�ϑO�ɃG�b�W���o
BWedge = edge(BW);
figure; imshow(BWedge);

%% Hough�ϊ����A�p�x�����߁A�t��]�␳
[H,theta,rho] = hough(BWedge);
peak = houghpeaks(H, 1)        % �s�[�N�̓_��theta��rho�̔ԍ��g
if theta(peak(1,2)) > 0
    ang = 90 - theta(peak(1,2));
else
    ang = -1 * (90 + theta(peak(1,2)));
end
Irot2 = imrotate(I, -1 * ang, 'bicubic');    %ang���t��]
imtool(Irot2);

%%
% This is modified version of the following example.
% http://www.mathworks.com/help/releases/R2014a/vision/examples/text-rotation-correction.html
%
% Copyright 2014 The MathWorks, Inc.

