clear all;clc;close all;imtool close all

%% �Î~��@�摜�����E��͂̃��[�N�t���[ %%%%%%%%%%%%%%
% �Î~�摜�̓Ǎ���
A=imread('peppers.png');
%
% �����Ɋe��摜�������� �̃R�[�h��}�� �|�|�|�|�|�|�|�|�|
%
%% ��͌��ʂ̑}��(��F�ʂ˂����l�p�ň͂�)
loc = [187 75 82 63];     % ��F���W����͂ɂ�蓾��ꂽ�Ƃ�����
A1 = insertShape(A, 'Rectangle', loc, 'Color', 'cyan', 'LineWidth', 3);
%% �Î~�摜�̕\��
figure; imshow(A1);       % Figure����J���A�摜��\��
%% ���ʂ̏����o��
imwrite(A1, 'tmp_result.png');

%%



% Copyright 2014 The MathWorks, Inc.
