% �}���`�y�[�WTIFF �t�@�C�� �̓Ǎ���

%% �摜�t�@�C���̏��̎擾
info = imfinfo('corn.tif')

%% ��Ԗڂ̉摜�̓Ǎ���
[I, map] = imread('corn.tif', 'Index',1, 'Info', info);
%% �\��
imtool(I, map)

%% ��Ԗڂ̉摜�̓Ǎ���
[I, map] = imread('corn.tif', 'Index',2, 'Info', info);
imtool(I, map)

%% ��Ԗڂ̉摜�̓Ǎ���
[I, map] = imread('corn.tif', 'Index',3, 'Info', info);
imtool(I, map)


% Copyright 2018 The MathWorks, Inc.