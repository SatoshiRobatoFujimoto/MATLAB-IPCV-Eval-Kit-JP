%% MRI�摜��3�����K�E�V�A���t�B���^�����O
clear; clc; close all;    % ������

%% MRI�摜�̓Ǎ��ݥ�\��
mri = load('mri');          % �摜�̓Ǎ��� (27����MRI�f�ʉ摜)
D = mri.D(:, :, :, 1:15);   % 15�Ԗڂ܂ł̉摜��؂�o��
figure; montage(D);      % D �́A128x128x1x15 �̔z��ix1�́A�O���[�X�P�[���ׁ̈j

%% ���f�[�^�̃{�����[���f�[�^��3�����\�� %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���ʂ̕\��
D = squeeze(D);      % ���������炵�A128x128x27�̔z��֕ϊ�
vol = isosurface(D, 5);  % ��ԊO�̑��ʁF�l5�̓��l�ʂ́A���_�Ɩʂ����߂�i�w�i�͒l0�j
figure; patch(vol, 'FaceColor','red', 'EdgeColor','none');  % ���l�ʂ�\��
view(-40,24)                  % ���_�̈ʒu
daspect([1 1 0.3])            % X,Y,Z�����̃A�X�y�N�g��̐ݒ�
colormap(gray); box on; camlight; lighting gouraud; % �Ɩ����e��ݒ�@�@�@�@goraud�ŐF�����炩�ɕω�����悤��

%% ��f�ʂ̕\��
sec = isocaps(D, 5);   % ���l�f�ʁi���l�ʂ�������Ƃ��̒[�̐ؒf�ʁj�̒��_��ʥ�P�x�����߂�
patch(sec, 'FaceColor','interp', 'EdgeColor','none'); shg; % ���l�f�ʂ̕\��

%% 3�����K�E�V�A���t�B���^�E�e�X���C�X�摜�̕\�� %%%%%%%%%%%%%%%%%%%%%%%%%
sigma = [2 2 2];                       % �K�E�V�A���t�B���^�̊e���������̕W���΍�
volSmooth = imgaussfilt3(D, sigma);    % 3�����K�E�V�A���t�B���^�̓K�p
figure; montage(reshape(volSmooth, [128 128 1 15])); % �e�X���C�X�摜�̕\��
%% ���ʂ�3�����\��
vol = isosurface(volSmooth, 5);  % ��ԊO�̑��ʁF�l5�̓��l�ʂ́A���_�Ɩʂ����߂�i�w�i�͒l0�j
figure; patch(vol, 'FaceColor','red', 'EdgeColor','none');  % ���l�ʂ�\��
view(-40,24)                  % ���_�̈ʒu
daspect([1 1 0.3])            % X,Y,Z�����̃A�X�y�N�g��ݒ�
colormap(gray); box on; camlight; lighting gouraud; % �Ɩ����e��ݒ�@�@�@�@goraud�ŐF�����炩�ɕω�����悤��
sec = isocaps(volSmooth, 5);     % ���l�f�ʁi���l�ʂ�������Ƃ��̒[�̐ؒf�ʁj�̒��_��ʥ�P�x�����߂�
patch(sec, 'FaceColor','interp', 'EdgeColor','none'); shg; % ���l�f�ʂ̕\��

%% 3���̔C�ӂ̃t�B���^ (imfilter) %%%%%%%%%%%%%%%%%%%
F = ones(3,3,3)/27          % 3x3x3 �̃t�B���^�W����`
volAve = imfilter(D, F);    % 3�������ω��t�B���^�̓K�p
figure; montage(reshape(volAve, [128 128 1 15])); % �e�X���C�X�摜�̕\��
%% ���ʂ�3�����\��
vol = isosurface(volAve, 5);  % ��ԊO�̑��ʁF�l5�̓��l�ʂ́A���_�Ɩʂ����߂�i�w�i�͒l0�j
figure; patch(vol, 'FaceColor','red', 'EdgeColor','none');  % ���l�ʂ�\��
view(-40,24)                  % ���_�̈ʒu
daspect([1 1 0.3])            % X,Y,Z�����̃A�X�y�N�g��ݒ�
colormap(gray); box on; camlight; lighting gouraud; % �Ɩ����e��ݒ�@�@�@�@goraud�ŐF�����炩�ɕω�����悤��
sec = isocaps(volAve, 5);     % ���l�f�ʁi���l�ʂ�������Ƃ��̒[�̐ؒf�ʁj�̒��_��ʥ�P�x�����߂�
patch(sec, 'FaceColor','interp', 'EdgeColor','none'); shg; % ���l�f�ʂ̕\��

%% 3�����̌��z���x�̌v�Z %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Gmag, Gaz, Gelev] = imgradient3(D);
sz = size(D);
figure;
montage(reshape(Gmag,sz(1),sz(2),1,sz(3)),'DisplayRange',[]);




%% Copyright 2015 The MathWorks, Inc.
