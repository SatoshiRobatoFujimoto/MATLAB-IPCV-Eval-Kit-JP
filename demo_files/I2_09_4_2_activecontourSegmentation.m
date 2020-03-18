%% ���I�֊s��p�����Z�O�����e�[�V����
clc;close all;imtool close all;clear;

%% �摜�̓Ǎ���
G = imread('I2_09_4_2_nuclei.jpg');
imshow(G);

%% �}�X�N�̍쐬�i�����G�b�W�j
mask = zeros(size(G));
mask(25:end-25,25:end-25) = 1;
imshow(mask);shg;

%% ���݂̃}�X�N�̗֊s��`��
imshow(G); shg; hold on;
b = bwboundaries(mask, 'noholes'); % �֊s�𒊏o
plot(b{1}(:,2),b{1}(:,1),'r','LineWidth',3);
hold off;

%% ���I�֊s���g�p�����Z�O�����e�[�V����
%    ���v400��̔������A1�X�e�b�v10�񂸂ɕ����ăA�j���[�V�����\��
stepsize=10;
for k = 1:400/stepsize
  mask = activecontour(G, mask, stepsize);

  % ���݂̃}�X�N�̗֊s��`��
  imshow(G); title(sprintf('Iteration %d',k*stepsize),'FontSize',16);
  b = bwboundaries(mask, 'noholes'); % �֊s�𒊏o
  hold on;
  for k=1:size(b)
    plot(b{k}(:,2),b{k}(:,1),'r','LineWidth',3);
  end
  hold off;
  drawnow;
end


%% �C���[�W�̗̈敪�� �A�v���P�[�V����: 
imageSegmenter(G);


%% Copyright 2013-2014 The MathWorks, Inc.

