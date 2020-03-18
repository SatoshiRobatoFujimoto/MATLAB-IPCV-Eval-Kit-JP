clear all;clc;close all;imtool close all

%% �摜�̓Ǎ���
rgb=imread('I3_06_1_color_chart8.jpg');
figure;imshow(rgb);

%% �O���b�h����
%[x y] = getpts        % �}�E�X��24���̊e�p�l�����S�ߕӂ��N���b�N (���ォ��E��)
                      % �w���A���^�[���L�[

% �R�}���h��x, y�𐶐�����
[y,x] = meshgrid(size(rgb,1)/8:size(rgb,1)/4:size(rgb,1),...
    size(rgb,2)/12:size(rgb,2)/6:size(rgb,2));
x = x(:);
y = y(:);
hold on;
plot(x,y,'o-');

%% �}�E�X�Ŋe�p�l���ʒu���w�肵�AR(��)G(��)B(��)�l ���擾(�Z�N�V�������s)
Col = uint32(x);
Row = uint32(y);
% (Row, Col, R/G/B) ����`�C���f�b�N�X�֕ϊ� 
r_ind = sub2ind(size(rgb), Row, Col, repmat(uint32(1),24,1));
g_ind = sub2ind(size(rgb), Row, Col, repmat(uint32(2),24,1));
b_ind = sub2ind(size(rgb), Row, Col, repmat(uint32(3),24,1));
rgb = double(rgb);
% RGB�l���ʂ̃x�N�g���֊i�[
r_camera = rgb(r_ind)
g_camera = rgb(g_ind)
b_camera = rgb(b_ind)

%% EXCEL���t�@�����X R �f�[�^�ǂݍ��� (I3_06_1_color_checker_ref.xls)
% winopen('I3_06_1_color_checker_ref.xls');
%�������́AI3_06_1_color_checker_ref.xls���E�N���b�N���āA"MATLAB�̊O���ŊJ��"
% �����ς݂�importfile�֐����g��
rgb_ref = importfile('I3_06_1_color_checker_ref.xls');
rgb_ref = rgb_ref(:,4:6);

r_ref = rgb_ref(:,1);
cftool;      %�Ȑ��ߎ� GUI�c�[���iCurve Fitting Toolbox)���N�������
             % cftool���̐ݒ�FX�f�[�^��r_camera�AY�f�[�^��r_ref
             %                 ��������I���A�����͂Q����I��
             %                 �ߎ����j���[ -> ���[�N�X�y�[�X�ɕۑ� -> OK  �ŁA
             %                 �ߎ���MATLAB�I�u�W�F�N�g�Ƃ��ĕۑ� (fittedmodel)

%% ���[�N�X�y�[�X�ɕۑ����ꂽ���ʂ��m�F
if exist('fittedmodel','var')
    fittedmodel
end

%% �΁A�ɑ΂��ẮA�R�}���h���C���ŋߎ������������������E�\��
if exist('fittedmodel','var')
    curveRed   = fittedmodel;
else
    curveRed = fit(r_camera, rgb_ref(:,1),'poly2');      % �Ԃ̃t�B�b�e�B���O�����R�}���h���C���ōs���Ƃ�
end
curveGreen = fit(g_camera, rgb_ref(:,2),'poly2');
curveBlue  = fit(b_camera, rgb_ref(:,3),'poly2');

%% ����ꂽ�g�[���}�b�s���O�␳�Ȑ��ɂ��摜�̐F�␳
rgb_op(:,:,1) = reshape(  curveRed(rgb(:,:,1)), size(rgb(:,:,1)));
rgb_op(:,:,2) = reshape(curveGreen(rgb(:,:,2)), size(rgb(:,:,1)));
rgb_op(:,:,3) = reshape( curveBlue(rgb(:,:,3)), size(rgb(:,:,1)));

%% ���摜(��)�ƁA�␳�����摜(�E)�̕\��
figure; imshowpair(uint8(rgb), uint8(rgb_op), 'montage');

%% �I��









%% Spreadsheet Link EX �������ꍇ�́A���L�����s
% open('I3_06_1_color_checker_ref.xls');
%     ��L�R�}���h�����s��A����ŁA�C���|�[�g����MATLAB�ϐ��̌^�Ƃ��āA"�s��"��I��
%     �e�[�u���f�[�^����R,G,B�̐�������(3��)�E2�s�`25�s�ڂ�I�����A
%     �C���|�[�g�{�^�����N���b�N => colorcheckref�Ƃ����ϐ����Ń��[�N�X�y�[�X�ɃC���|�[�g�����
% rgb_ref = colorcheckerref;       % colorcheckref �� rgb_ref �Ƃ����ϐ�����


% Copyright 2014 The MathWorks, Inc.
