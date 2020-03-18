%% SLIC �X�[�p�[�s�N�Z����p�����Z�O�����e�[�V����(�̈敪��)
% SLIC�Fsimple linear iterative clustering
clc;clear;close all;imtool close all;rng('default');

%% �摜�̓Ǎ��݁E�\���EL*a*b*�F��Ԃւ̕ϊ�
I = imread('lighthouse.png');
figure; imshow(I);
Ilab = rgb2lab(I);     % �ϓ��F���

%% �X�[�p�[�s�N�Z����p�����̈�ɕ���
%    �ڕW�F�ł��邾�������T�C�Y�́A600�̗ގ��F�̈�ɂȂ�悤�ɕ���
[Ls, N] = superpixels(Ilab, 600, 'IsInputLab',true);     % �f�t�H���g�ł͓�����L*a*b*�֕ϊ�
N                             % N :���ʓI�ɐ������ꂽ�X�[�p�[�s�N�Z����
imtool(Ls, []);               % Ls:��f�l�����āA���x���摜�ɂȂ��Ă���̂��m�F   

%% �X�[�p�[�s�N�Z���̕\��
Bmask = boundarymask(Ls);             % ���x�����E���g���[�X�i2�l�摜�j
I1 = imoverlay(I, Bmask,'cyan');      % �摜���ɁA2�l�摜���w��F�ŏ㏑��
figure;imshow(I1); shg;

%% �X�[�p�[�s�N�Z�����ɕ��ϒl���Z�o���A���̗̈�̐F��u������\��
pixIdxList = label2idx(Ls);    % �e���x���̈�̍s��C���f�b�N�X���擾
sz = numel(Ls);                % ��f��
for  i = 1:N    % �e�X�[�p�[�s�N�Z�����Ɍv�Z
  superLab(i,1) = mean(Ilab(pixIdxList{i}      ));  % L*�������ϒl
  superLab(i,2) = mean(Ilab(pixIdxList{i}+   sz));  % a*�������ϒl
  superLab(i,3) = mean(Ilab(pixIdxList{i}+ 2*sz));  % b*�������ϒl
end
I2 = label2rgb(Ls, lab2rgb(superLab));
figure; imshowpair(I, imoverlay(I2, boundarymask(Ls),'cyan'), 'montage'); truesize;

%% K-means�ł���ɁA�F�̗ގ��x��p���N���X�^�����O
numColors = 3;  % 3�ɕ���
Lc = imsegkmeans(I2,numColors,'NormalizeInput',false);
I3  = label2rgb(Lc); % ���x���摜��RGB�摜�ɕϊ�
% �摜���ɁA2�l�摜���w��F�ŏ㏑��
imshow(I3); shg;

%% ���䕔���𒊏o
% �摜�[�ɐڂ��Ă���̈�������i���x�����ɏ����j
Lm = imclearborder(Lc==1);
for i = 2:numColors
  Lm = [Lm imclearborder(Lc==i)];
end
% �ʐς̑傫�����2�̗̈�𒊏o
maskA  = bwareafilt(Lm, 2);
% �}�X�N�̐�������ʂ̕\��
maskA1 = reshape(maskA, [size(Ls), numColors]);
maskA2 = sum(maskA1, 3);
maskA3 = imfill(maskA2, 'holes');       % �}�X�N�̌��𖄂߂�
Iout = imoverlay(I, ~maskA3, 'green');
figure; imshow(Iout);                   % �\��

%% Copyright 2018 The MathWorks, Inc.
