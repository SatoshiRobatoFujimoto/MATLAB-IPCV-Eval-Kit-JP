%% RANSAC(MSAC)�ɂ��m�C�Y�f�[�^�ւ̑������t�B�b�e�B���O

%% ������
clear; close all; clc; rng('default');

%% �����Ȑ�(2���֐�)�̎�����_�𐶐�
x = (-10:0.1:10)';
y = (36-x.^2)/9;
figure
plot(x,y)
title('�����Ȑ�(2���֐�)')

%% �O��l�Ƃ��ăm�C�Y��t��
y = y+rand(length(y),1);
y([50,150,99,199]) = [y(50)+12,y(150)-12,y(99)+33,y(199)-23];
plot(x,y)
title('�����Ȑ�(2���֐�)�ɊO��l�Ƃ��ăm�C�Y�t��')
shg;

%% RANSAC(MSAC)�ɂ�鑽�����t�B�b�e�B���O
N = 2;           % 2���Ȑ�
maxDistance = 1; % inlier(�O��l�łȂ�)�Ƃ݂Ȃ��ő勗��

% 2���Ȑ��Ƀt�B�b�e�B���O
[P, inlierIdx] = fitPolynomialRANSAC([x,y],N,maxDistance);
disp('2���֐��̌W��(y=ax^2+bx+c)');
disp(P);

%% �t�B�b�e�B���O���ʂ̉���
yRecoveredCurve = polyval(P,x);
figure
plot(x,yRecoveredCurve,'-g','LineWidth',3)
hold on
plot(x(inlierIdx),y(inlierIdx),'.',x(~inlierIdx),y(~inlierIdx),'ro')
legend('�Ȑ�','Inlier�_','Outlier�_(�O��l)')
hold off

%% �C�ӂ̐������f���ւ̃t�B�b�e�B���O

%% �t�B�b�e�B���O�Ώۂ̊O��l���܂ޓ_�Q�����[�h
load pointsForLineFitting.mat
plot(points(:,1),points(:,2),'o');
hold on
shg;

%% �ŏ����@�Ńt�B�b�e�B���O
% �O��l�Ɉ��������Ă��܂��t�B�b�e�B���O�ł��Ȃ�
modelLeastSquares = polyfit(points(:,1),points(:,2),1);
x = [min(points(:,1)) max(points(:,1))];
y = modelLeastSquares(1)*x + modelLeastSquares(2);
plot(x,y,'r-')
shg;

%% RANSAC(MSAC)�̃t�B�b�e�B���O�֐��ƕ]���֐���ݒ�
fitLineFcn = @(points) polyfit(points(:,1),points(:,2),1); % plyfit���t�B�b�e�B���O�֐��ɂ���
evalLineFcn = ...   % �Ȑ��Ɠ_�̋������v�Z����֐�
  @(model, points) sum((points(:, 2) - polyval(model, points(:,1))).^2,2);

%% RANSAC�Ńt�B�b�e�B���O
sampleSize = 2; % RANSAC��1���[�v�ŃT���v�����O����_��
maxDistance = 2; % inlier(�O��l�łȂ�)�Ƃ݂Ȃ����f������̋���
[modelRANSAC, inlierIdx] = ransac(points,fitLineFcn,evalLineFcn, ...
  sampleSize,maxDistance);
modelRANSAC

%% inliner�̓_�������g���čēx�Aplyfit�ōŏ����t�B�b�e�B���O
modelInliers = polyfit(points(inlierIdx,1),points(inlierIdx,2),1);

%% ���ʂ̉���
inlierPts = points(inlierIdx,:);
x = [min(inlierPts(:,1)) max(inlierPts(:,1))];
y = modelInliers(1)*x + modelInliers(2);
plot(x, y, 'g-')
legend('�O��l���܂ފϑ��_','�ŏ����t�B�b�e�B���O','RANSAC�ɂ�郍�o�X�g�t�B�b�e�B���O');
hold off
shg;

%% 
% Copyright 2018 The MathWorks, Inc.
