%% imageBatchProcessor�ɂ��o�b�`����

%% �T���v���f�[�^�̐���
%     JPEG�́A1�r�b�g�C���[�W�ɔ�Ή�
[~,~,~] = mkdir('I2_13_MRIdata');
d = load('mri.mat');
image = squeeze(d.D);    %�傫��1�̑�3�������폜
for ind = 1:size(image,3)
    fileName = sprintf('Slice%02d.tif',ind);
    imwrite(image(:,:,ind),fullfile('I2_13_MRIdata', fileName));
end

%% imageBatchProcessor    �R�}���h
imageBatchProcessor
% �������́A�A�v���P�[�V���� �^�u����A�C���[�W�̃o�b�`�����p �A�v���P�[�V�����̋N��

%% �o�b�`����
% "�C���[�W�̎�荞��"�{�^���ŁA�摜�������Ă���t�H���_ I2_13_MRIdata ���w��
% "�֐���"�ɁA  I2_13_batchProcess.m  ���w��
% �悸�A�����I�����A"�I��Ώۂ�����" �����s���A���ʂ̊m�F(�g�����)
% �S�Ă����s�iParallel Computing Toolbox������΁A���񏈗��\�j
% �p�����[�^���g�p�������ꍇ�́Aglobal �ϐ������g�p

% Copyright 2018 The MathWorks, Inc.