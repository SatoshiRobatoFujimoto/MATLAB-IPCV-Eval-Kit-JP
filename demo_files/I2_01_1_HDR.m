%% �n�C �_�C�i�~�b�N �����W �C���[�W�̎戵��

clear;clc;close all;imtool close all

%% �n�C �_�C�i�~�b�N �����W �C���[�W�̓Ǎ���
hdr_image = hdrread('office.hdr');   % m x n x 3 single

max(hdr_image(:))
min(hdr_image(:))

imtool(hdr_image);      % 1.0 �ȏ�͖O�a

hdr_image(66,637,3)     % 3.2813
hdr_image(66,634,:)     % 0.4492, 0.5898, 0.7656

%% �g�[���}�b�s���O (uint8��)
rgb = tonemap(hdr_image);

%% ���ʂ̕\��
figure;imshow(rgb);

rgb(66,637,3)          % �ő�l��255�փ}�b�s���O����Ă��܂�


%% ��A�̃��[�_�C�i�~�b�N�����W�摜�t�@�C�����g������
files = {'office_1.jpg', 'office_2.jpg', 'office_3.jpg', ...
         'office_4.jpg', 'office_5.jpg', 'office_6.jpg'};
       
% �e�摜�̑��ΘI���l
expTimes = [0.0333, 0.1000, 0.3333, 0.6250, 1.3000, 4.0000];

% �ł����邢�C���[�W�ƍł��Â��C���[�W�Ԃ̒��Ԃ̘I���l���A
% �n�C �_�C�i�~�b�N �����W�̌v�Z�ɑ΂��āA��{�I���Ƃ��Ďg�p
hdr = makehdr(files, 'RelativeExposure', expTimes );
hdr1 = makehdr(files, 'RelativeExposure', expTimes ./ expTimes(1));

imtool(hdr,[0 5])
D = imabsdiff(hdr,hdr1);
imtool(D)


rgb = tonemap(hdr);
rgb1 = tonemap(hdr1);

figure; imshow(rgb)
figure; imshow(rgb1)

D = imabsdiff(rgb,rgb1);
imtool(D)

% Copyright 2014 The MathWorks, Inc.
